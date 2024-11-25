setwd("H:/My Drive/Riley Palmer/IAPSO CTD Oxygen calibration comparison/cruise data")
setwd("/Users/christopherlangdon/Library/CloudStorage/GoogleDrive-langdonlab120@gmail.com/My Drive/Riley Palmer/IAPSO CTD Oxygen calibration comparison/cruise data")

require(readr)
require(dplyr)
require(ggpubr)
require(ggplot2)
require(ggpmisc)
require(lookup)
require(plotly)

find_closest <- function(query, lookup) {
  lookup[which.min(abs(lookup - query))]
}

find_gte <- function(query, lookup) {
  lookup[min(which(lookup >= query))]
}


bottle <- read_csv("45CE20170427_hy1 bottle data.csv")
ctd <- read_csv("CE20170427 CTD downcast data.csv")


# Apply the closest match using mutate and dplyr
bottleold=filter(bottle,STNNBR>500)


for (i in 1:66) {
  ctdstn=filter(ctd,STNNBR==i)
  bottlestn=filter(bottle,STNNBR==i)
  bottlestn$closest_potden = sapply(bottlestn$POTDEN, find_closest, lookup = ctdstn$POTDEN)
  bottlestn$ctd.down=vlookup(bottlestn$closest_potden,ctdstn,'POTDEN','CTDO2') 
  bottlenew=rbind(bottleold,bottlestn)
  bottleold=bottlenew
}
  

write_csv(bottlenew,file='CE20170427 bottle O2 and CTDO2 downcast 19Nov24.csv')
bottlenew.qf2=filter(bottlenew,OXYGEN_FLAG_W==2)
bottlenew.qf3=filter(bottlenew,OXYGEN_FLAG_W==3)


#plot uncorrected downcast CTD O2 against Bottle O2

mymod=lm(OXYGEN ~ ctd.down,bottlenew.qf2)
summary(mymod)
b=coef(summary(mymod))[1]
m=coef(summary(mymod))[2]
rmse=sqrt(mean(mymod$residuals^2))


bottlenew.qf2$ctd.corr=b + m*bottlenew.qf2$ctd.down
ctd$corrected.CTD.downcast=round(b+m*ctd$CTDO2,1)
write.csv(ctd,'CE20170427 correctd CTD downcast O2 stn 4-66.csv')

g1=ggplot(bottlenew.qf2,aes(x=ctd.down,y=OXYGEN))+
  theme_classic()+
  geom_point()+
  stat_poly_line(color='black')+
  stat_poly_eq(formula = y ~ x,aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               parse=TRUE,label.x.npc = "right",coef.digits = 5)+
  labs(x='Uncorrected CTD downcast O2, uml/kg',y='Bottle, umol/kg')+
  annotate('text',label='RMSE = 3.85 umol/kg',x=170,y=350,hjust=0)
g1


g2=ggplot(bottlenew.qf2,aes(x=OXYGEN,y=ctd.corr))+
  theme_classic()+
  geom_point()+
  theme_classic()+
  geom_abline(intercept=0,slope=1)+
  labs(x='Bottle oxygen, uml/kg',y='corrected CTD downcast O2, umol/kg')+
  annotate('text',label='1:1 line',x=170,y=300,hjust=0)
g2

ggarrange(g1,g2)
ggsave('raw and corrected CTD O2 v Bottle O2.pdf')
