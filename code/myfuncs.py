#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Feb 22 2024

@author: abosse
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import interp1d
import gsw
import ctd
import cmocean as cmo



def  sw_sals(R,T):
    Rt= R/2
    A0 = 0.0080
    A1 = -0.1692
    A2 = 25.3851
    A3 = 14.0941
    A4 = -7.0261
    A5 = 2.7081
    B0 = 0.0005
    B1 = -0.0056
    B2 = -0.0066
    B3 = -0.0375
    B4 = 0.0636
    B5 = -0.0144
    K = 0.0162
    
    dS= (T-15)/(1+K*(T-15))*(B0+B1*Rt**(1/2)+B2*Rt+B3*Rt**(3/2)+B4*Rt**2+B5*Rt**(5/2))
    S = A0 + A1*Rt**(1/2) + A2*Rt + A3*Rt**(3/2) + A4*Rt**2 + A5*Rt**(5/2) +dS
    
    return S


def filter_df(df,col):
    q_low = df[col].quantile(0.25)
    q_hi  = df[col].quantile(0.75)
    IQR =  q_hi - q_low
    upper_bound = q_hi + 1.5 *IQR
    lower_bound = q_low -1.5 *IQR
    
    df_filtered = df.loc[(df[col] > lower_bound) & (df[col] < upper_bound)]
    
    return df_filtered

def histogram_boxplot(data1, data2, xlabel = None, title = None, figsize=(9,8), leg1=None, leg2=None, xlim = None):
    """ Boxplot and histogram combined
    data: 1-d data array
    xlabel: xlabel 
    title: title
    font_scale: the scale of the font (default 2)
    figsize: size of fig (default (9,8))
    bins: number of bins (default None / auto)

    example use: histogram_boxplot(np.random.rand(100), bins = 20, title="Fancy plot")
    """
    sns.set(style="whitegrid")
    sns.set_context("talk")
    fig, (ax_box1, ax_box2, ax_hist) = plt.subplots(3, sharex=True, gridspec_kw={"height_ratios": (.1, .1, .8)}, figsize=figsize)
    sns.boxplot(x=data1, ax=ax_box1, color = 'tab:blue')
    sns.barplot(ax=ax_box1, x=data1, alpha=0.5, errorbar=('ci', 95))
    tit1="median = "+np.array2string(np.nanmedian(data1),precision=4)+", $\sigma$ = "+np.array2string(np.nanstd(data1),precision=4)
    ax_box1.set(title=tit1)
    sns.boxplot(x=data2, ax=ax_box2, color = 'tab:red')
    sns.barplot(ax=ax_box2, x=data2, alpha=0.5, errorbar=('ci', 95), color = 'red')
    tit2="median = "+np.array2string(np.nanmedian(data2),precision=4)+", $\sigma$ = "+np.array2string(np.nanstd(data2),precision=4)
    ax_box2.set(title=tit2)
    h1 = sns.histplot(data1, ax=ax_hist, label = leg1)
    h2 = sns.histplot(data2, ax=ax_hist, label = leg2)
    if xlabel: ax_hist.set(xlabel=xlabel)
    if xlim: ax_hist.set(xlim = xlim)
    plt.legend()
    plt.show()
    
    return fig

def convert_dates_to_days(dates, start_date=None, name='Day'):
    """Converts a series of dates to a series of float values that
    represent days since start_date.
    """

    if start_date:
        ts0 = pd.Timestamp(start_date).timestamp()
    else:
        ts0 = 0

    return ((dates.apply(pd.Timestamp.timestamp) - 
            ts0)/(24*3600)).rename(name)

def get_slope(df_obs1,df_obs2,plim):
    c_ref1 = df_obs1["Autosal C, S/m"].loc[df_obs1["PrDM"]>plim]
    c_ref2 = df_obs2["Autosal C, S/m"].loc[df_obs2["PrDM"]>plim]
    c_obs1 = df_obs1["C0S/m"].loc[df_obs1["PrDM"]>plim]
    c_obs2 = df_obs2["C1S/m"].loc[df_obs2["PrDM"]>plim]
    slope1 = np.sum(c_ref1*c_obs1)/np.sum(c_obs1**2)
    slope2 = np.sum(c_ref2*c_obs2)/np.sum(c_obs2**2)
    return slope1, slope2

def cor_cond(df,labC,labS,labT,df_slope,st):
    
    x = convert_dates_to_days(df.Date, start_date=st)
    xp = convert_dates_to_days(pd.Series(df_slope.index.values), start_date=st)
    yp = df_slope.slope.values
    slope = interp1d(xp, yp, fill_value="extrapolate")
    
    df["cor "+labC] = df[labC]*slope(x)
    df["cor "+labS] = gsw.SP_from_C(df["cor "+labC]*10,df[labT],df["PrDM"])
    plt.plot(xp,yp,'o')
    plt.plot(x,slope(x),'.')
    
    return df

def cor_cond_cast(df_c,df_slope,st):
    
    x = convert_dates_to_days(pd.Series(df_c._metadata['time']), start_date=st)
    xp = convert_dates_to_days(pd.Series(df_slope.index.values), start_date=st)
    yp = df_slope.slope.values
    slope = interp1d(xp, yp, fill_value="extrapolate")
    
    df_c['cS/m_adjusted'] = df_c['c0S/m']*slope(x)
    df_c['sal_adjusted'] = gsw.SP_from_C(df_c['cS/m_adjusted'].values*10,df_c['t90C_adjusted'].values,df_c.index)
    
    return df_c,slope(x)

def plot_all_cast(casts,opt,adj,lf):
    tlim1 = [0, 18]
    tlim2 = [0, 18]
    slim1 = [34, 37]
    slim2 = [34, 37]
    siglim1 = [26, 28]
    siglim2 = [26, 28]
    oxlim1 = [130, 270]
    oxlim2 = [130, 270]
    zlim1 = [0, 100]
    zlim2 = [100, 5000]
    lsta = 0
    if adj:
        extrastr = '_adj'
    else:
        extrastr = ''
    for ctd_cast,f in zip(casts,lf): 
        lsta += 1
        plt.close()
        fig = plt.figure(dpi=100,figsize=(12,16))
        for kplot,(var0,var1,var_adj,varlim,zzlim) in enumerate(zip(['t090C','sal00','sigma-é00','sbox0Mm/Kg','t090C','sal00','sigma-é00','sbox0Mm/Kg'],
                                           ['t190C','sal11','sigma-é11','','t190C','sal11','sigma-é11',''],
                                           ['t90C_adjusted','sal_adjusted','sigma0_adjusted','sbeox0Mm/Kg_adjusted','t90C_adjusted','sal_adjusted','sigma0_adjusted','sbeox0Mm/Kg_adjusted'],
                                           [tlim1,slim1,siglim1,oxlim1,tlim2,slim2,siglim2,oxlim2],
                                           [zlim1,zlim1,zlim1,zlim1,zlim2,zlim2,zlim2,zlim2])):
            ax = plt.subplot(2,4,kplot+1,xlim=varlim,ylim=zzlim)
            ctd.plot_cast(ctd_cast.iloc[ctd_cast.index<zzlim[1]][var0],label="CTD1")
            try :
                ctd.plot_cast(ctd_cast.iloc[ctd_cast.index<zzlim[1]][var1],label="CTD2")
            except :
                print(var1+' : error pas de CTD2 pour '+opt+ctd_cast._metadata['name'])
            if adj:
                try:
                    ctd.plot_cast(ctd_cast.iloc[ctd_cast.index<zzlim[1]][var_adj],label="adjusted",linewidth=2)
                except:
                    print(var1+' : empty data')
            plt.legend()  
        
        plt.suptitle(ctd_cast._metadata['name'])
        fig.set_size_inches(10,10)
        plt.tight_layout()
  
        fig.savefig('fig_corS/fig_CTD/'+opt+f[:-4],dpi=150)

def getrid_inversion(df,threshold=-0.01):
    # get rid of density inversion at the surface
    for c in df:
        ind = np.where(c['sigma0_adjusted'].iloc[c.index<20].diff().values < threshold)
        if len(ind[0])>0:
            ind = ind-np.ones(np.shape(ind)) # avoid removing top index
            print('Find inversion : remove '+str(np.size(ind)))
            for var in ['t90C_adjusted','sal_adjusted','cS/m_adjusted','sigma0_adjusted','potemp90C_adjusted']:
                c.loc[c.index.values[ind[0].astype(int)],var] = np.nan
                c[var] = c[var].interpolate()
    return df
    
def plot_control_section(ctd_mat,zmax=2900,tmin=12.9,tmax=14.5,smin=37,smax=38.8,omin=160,omax=270):
    import matplotlib as m
    plt.close()
    cm_t = m.colors.LinearSegmentedColormap('cm_t', cmo.tools.get_dict(cmo.cm.thermal),20)
    cm_s = m.colors.LinearSegmentedColormap('cm_s', cmo.tools.get_dict(cmo.cm.haline),20)
    cm_o = m.colors.LinearSegmentedColormap('cm_o', cmo.tools.get_dict(cmo.cm.oxy),20)

    f, [axt, axs, axo] = plt.subplots(3,dpi=200,figsize=(15,12))
    for var,axx,varmin,varmax,lab,cm in zip(['temp_adj','sal_adj','ox_adj'],[axt,axs,axo],[tmin,smin,omin],[tmax,smax,omax],
                                        [r'$\theta$ (°C)',r'$S_P$',r'[0$_2$] ($\mu$mol/kg)'],[cm_t,cm_s,cm_o]):
            cc=axx.pcolormesh(ctd_mat[var],vmin=varmin,vmax=varmax,cmap=cm.reversed(),alpha=0.8)
            ccs=axx.contour(ctd_mat['sig'],levels=[27, 27.5, 28, 28.5, 28.7, 28.9, 29, 29.05, 29.1, 29.11],colors='black',linewidths=1)
            plt.clabel(ccs, inline=True, fontsize=6)
            cbt=plt.colorbar(cc,ax=axx)
            cbt.set_label(lab)
            axx.set_ylim([0 , zmax])
            axx.invert_yaxis()
            axx.set_xlabel('# cast')
            axx.set_ylabel('Depth (m)')
    plt.tight_layout()
    f.savefig('adj_TSOsection'+str(zmax)+'.png')
