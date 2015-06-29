library(foreign)
library(countrycode)

# Note on the two data sets:
# 1) You'll have to download the WVS longitudinal file yourself. Notice I haven't touched the file name for transparency's sake.
# 2) wvsccodes is in this directory. I created it from WVS_EVS_Integrated_Dictionary_Codebook v_2014_09_22.xls, distributed by WVS.
# See accompanying blog post at svmiller.com for more information.

WVS <- read.dta("~/Dropbox/data/wvs/WVS_Longitudinal_1981_2014_stata_v2015_04_18.dta", convert.factors = FALSE) # Integrated, 1981-2014
WVSccodes <- read.csv("~/Dropbox/data/wvs/wvsccodes.csv")

WVS$wvsccode <- WVS$S003
WVS <- WVS[order(WVS$wvsccode), ]

WVS <- merge(WVS, WVSccodes, by=("wvsccode"), all.x=TRUE)

WVStable <- with(WVS, data.frame(wvsccode, country))
WVStable <- WVStable[!duplicated(WVS[, "wvsccode"]), ]
WVStable$ccode <-  countrycode(WVStable$country, "country.name", "cown")

WVStable$ccode[WVStable$country == "Serbia"] <- 345
WVStable$ccode[WVStable$country == "Serbia and Montenegro"] <- 345

write.table(WVStable,file="wvstable.csv",sep=",",row.names=F,na="")

# Note: you're on your own regarding Puerto Rico, Palestine, and Hong Kong.
# If, for your own reason, you want to keep those, I'd recommend 6 (Puerto Rico), 667 (Palestine), and 714 (Hong Kong).
