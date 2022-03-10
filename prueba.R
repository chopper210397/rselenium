library(dplyr)
library(readr)
library(readxl)
library(tidyr)

datarichi<-read_xlsx("GO TO COMERCIAL.xlsx",sheet = "Data")

  str(datarichi)
unique(datarichi$precio)

datarichi$precio[is.na(datarichi$precio)] <- 0

datarichi %>% group_by(artdes) %>% dplyr::summarise(DIMEXA=mean(precio))

tidydata<-datarichi %>% pivot_wider(id_cols = artdes,names_from = clienom,values_from = precio) %>% arrange(artdes)

datarichi %>% group_by(periodo,artdes,clienom) %>% dplyr::summarise(precio=precio)
