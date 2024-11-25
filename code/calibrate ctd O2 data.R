#setwd("~/OneDrive - University of Miami/ECOA/ECOA-2 2128/Seabird CTD cnv files/0304309/2.2/data/0-data/CTD")
#setwd("C:/Users/c.langdon/OneDrive - University of Miami/ECOA/ECOA-2 2018/Seabird CTD cnv files/0194299/1.1/data/0-data/CTD")
#setwd("~/OneDrive - University of Miami/ECOA/ECOA-1 2015")
#setwd("C:/Users/c.langdon/OneDrive - University of Miami/ECOA/ECOA-3 2022/Oxygen QC")
setwd("/Users/christopherlangdon/Library/CloudStorage/GoogleDrive-langdonlab120@gmail.com/My Drive/Riley Palmer/IAPSO CTD Oxygen calibration comparison/cruise data/SBE911 CTD raw files/SBE-profile-data")

require(readr)
require(ggplot2)
require(seacarb)

#g=g+theme(text=element_text(size=21,  family="sans"))

average=function(x){mean(x,na.rm=TRUE)}
len=function(x){length(x[x>=421])}
stdev=function(x){sd(x,na.rm=TRUE)}
se=function(x){sd(x,na.rm=TRUE)/sqrt(length(x))}
#Oxygen saturation concentration in umol/kg from Garcia and Gordon 1992 L&O
#check value T=10C S=35 274.6459
Cstar = function(T,S) {
  A0=5.80818
  A1=3.20684
  A2=4.11890
  A3=4.93845
  A4=1.01567
  A5=1.41575
  B0=-7.01211e-3
  B1=-7.25958e-3
  B2=-7.93334e-3
  B3=-5.54491e-3
  C0=-1.32412e-7
  Ts=log((298.15-T)/(273.15+T))
  exp(A0+A1*Ts+A2*Ts^2+A3*Ts^3+A4*Ts^4+A5*Ts^5+S*(B0+B1*Ts+B2*Ts^2+B3*Ts^3)+C0*S^2)
}

#SBE 43 
OX=function(V,P,T,S,Soc,Voff,Tcor,Pcor)
{
  (Soc*(V+Voff))*Cstar(T,S)*exp(Tcor*T)*exp(Pcor*P)
}

#data<- read_csv("winkler_matchup_density_langdon-2.csv")
#data <- read_csv("mastersamplingsheet_ECOA_Langdon_03162020.csv")
#data <- read_csv("mastersamplingsheet_ECOA_Langdon_03162020.csv")
#data <- read_csv("ECOA-1 deep stations.csv")
data <- read_csv("ctd60.csv")

#ctd_all <- read_csv("C:/Users/c.langdon/OneDrive - University of Miami/ECOA/ECOA-2 2018/Seabird CTD cnv files/0194299/1.1/data/0-data/CTD/ctd input data.csv")
#rmse <- read_csv("rmse.csv")
#data <- read_csv("DE line.csv")

#sta.data=subset(data,(Station==7 | Station==39 | Station==40 |Station==67) & O2.flag=='2')
#sta.data=subset(data,(Station==105 | Station==109 ) & O2.flag=='2')
#sta.data=subset(data, O2.flag=='2')

g=ggplot(data,aes(x=CTD.VOLT,y=OXYGEN))+
  geom_point()
g
ggplotly(g)
#ggsave("ECOA1 Winkler v sbe.volt.pdf")

g=ggplot()+
  geom_point(data=data,aes(x=POT.DENSITY,y=OXYGEN),color='black')+
  geom_point(data=data,aes(x=POT.DENSITY,y=CTD.VOLT),color='red')
g

g=ggplot()
g=g+geom_point(data=data,aes(x=CTDPRS,y=Wink),color='black')
g=g+geom_point(data=data,aes(x=CTDPRS,y=Sbeox0),color='red')
g=g+geom_line(data=data,aes(x=CTDPRS,y=Winkler),color='black',size=0.5)
g=g+geom_line(data=data,aes(x=CTDPRS,y=Sbeox0),color='red',size=0.5)
g
ggplotly(g)
ggsave('ECOA_1 DE line sta 1-7(black=Winkler, red=CTDO2).pdf')

g=ggplot(sta.data,aes(x=pot.density,y=Sbeox0,color=as.factor(Station)))
g=g+geom_point()
g

g=ggplot(sta.data,aes(x=Winkler,y=Sbeox0))
g=g+geom_point()
g=g + geom_abline(intercept = 0, slope = 1)
g
ggplotly(g)
ggsave('ECOA-1 SBE O2 sensor calibration all deep stations.pdf')

nlsout=nls(OXYGEN~Soc*(CTD.VOLT+Voff)*Cstar(CTDTMP,CTDSAL)*exp(1.6e-4*CTDTMP)*exp(Pcor*CTDPRS),start=c(Soc=0.5,Voff=-0.5,Pcor=1.46e-4),data=data)
summary(nlsout)
fit=summary(nlsout)
Soc=fit$parameters[1]
Voff=fit$parameters[2]
Pcor=fit$parameters[3]
Tcor=1.6e-4
#sta.data=subset(ctd_all,Sta>=78 & Sta<=80)
#sta.data$Ox.umol.kg=OX(sta.data$sbeox1V,sta.data$P,sta.data$T,sta.data$S,Soc,Voff,Tcor,Pcor)

discrete.data=subset(data,Station>=40 & Station<=45)
discrete.data$Ox.umol.kg=OX(discrete.data$sbeox1V,discrete.data$P,discrete.data$T,discrete.data$S,Soc,Voff,Tcor,Pcor)
discrete.data$residuals=discrete.data$Winkler-discrete.data$Ox.umol.kg
discrete.data$Soc=Soc
discrete.data$Voff=Voff
discrete.data$Pcor=Pcor
discrete.data$Tcor=Tcor
discrete.data$RMSE=fit$sigma

g=ggplot(sta.data,aes(x=P,y=Ox.umol.kg))
g=g+geom_line()
g=g+geom_point(data=subset(data,Station>=40 & Station<=45),aes(x=P,y=Winkler),color='red')
g=g + annotate("text", x = 60, y = 275, label = "ECOA2_40")
g=g+theme(text=element_text(size=14,  family="sans"))
g=g+labs(x="Pressure, db",y='Oxygen, umol/kg')
g
ggsave("ECOA2_40-45.pdf")

g=ggplot(discrete.data,aes(x=Winkler,y=Ox.umol.kg))
g=g+geom_point()
g=g+geom_smooth(method=lm)
g=g+labs(x="Winkler, umol/kg",y="SBE O2, umol/kg")
g=g+theme(text=element_text(size=14,  family="sans"))
g
ggplotly(g)
ggsave('SBE O2 v Winkler O2 Sta 40-45.pdf')

write.csv(sta.data,"ctd_40.csv")
write.csv(discrete.data,"discrete_40.csv")

g=ggplot(rmse,aes(x=RMSE))
g=g+geom_histogram(fill='lightgray')
g=g+theme(text=element_text(size=14,  family="sans"))
g=g+labs(x='RMSE of fit, umol/kg')
g
ggsave('Histogram of RMSE of CTD fit to Winkler data.pdf')
median(rmse$RMSE,na.rm=TRUE)
average(rmse$RMSE)
