#setwd("C:/Users/c.langdon/OneDrive - University of Miami/A16N 2023/QC files")
#setwd("~/Library/CloudStorage/OneDrive-UniversityofMiami/A16N 2023/QC files")
#setwd("C:/Users/c.langdon/OneDrive - University of Miami/A13_5/2024 cruise/merged")
#setwd("H:/My Drive/Riley Palmer/IAPSO CTD Oxygen calibration comparison/cruise data")
setwd("/Users/christopherlangdon/Library/CloudStorage/GoogleDrive-langdonlab120@gmail.com/My Drive/Riley Palmer/IAPSO CTD Oxygen calibration comparison/cruise data")

require(readr)
require(seacarb)
require(dplyr)

#data <- read_csv("A16N 2023 Wink QC.csv")
#data <- read_csv("all stations 27Jan24.csv")
#data <- read_csv("A16N 2024 QC 17Mar24.csv")
#data <- read_csv("33H320240201_hy1 QCd 06Nov24.csv")
data <- read_csv("45CE20170427_hy1 oxygen bottle data.csv")

data$POTDEN=swSigmaTheta(data$CTDSAL,data$CTDTMP,data$CTDPRS)

data=select(data,STNNBR,BTLNBR,CTDPRS,POTDEN,CTDOXY,CTDOXY_FLAG_W,OXYGEN,OXYGEN_FLAG_W)
write.csv(data,'45CE20170427_hy1 bottle data.csv')

