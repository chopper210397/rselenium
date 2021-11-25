library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)

driver <- rsDriver(browser = c("firefox"),port = 4447L)
remote_driver <- driver[["client"]]

remote_driver$open()

remote_driver$navigate("http://190.116.51.180:8080/dimexaproveedor/login.zul")

username<- remote_driver$findElement(using= "id", value="z_d__l")
username$clearElement()
username$senKeysToElement(list(P625))


passwd<-remote_driver$findElement(using="id",value="z_d__o")
passwd$clearElement()
passwd$sendKeysToElement(list(895623))

login <- remote_driver$findElement(using = "id",value ="z_d__r")
login$clickElement()


