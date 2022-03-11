library(readxl)
library(readr)
library(dplyr)
library(writexl)
library(lubridate)
library(zoo)

stockvsppto<-read_xlsx("stockvsppto_030322.xlsx",sheet = "STOCK Vs.PPTO",skip = 5)
# str(stockvsppto)
colnames(stockvsppto)[2]<-"CODIGO"
syslanstock<-read_xlsx("stockvsppto_030322.xlsx",sheet = "STOCK AL 03.03",skip = 4)
# str(syslanstock)
syslanstock<-syslanstock %>% filter(VIGENCIA>10)
# unique(syslanstock$VIGENCIA)
# SELECCIONO SOLO LAS COLUMNAS QUE VOY A TRAER
syslanstock<-syslanstock %>% select(CODIGO,LOTE,VCTO,VTAS,CUARENT,PRODIS)

# cruzo el original con la data de syslan
# EL ALL.X tiene que ser TRUE para que traiga todos los valores incluso los que no tienen stock en el syslanweb, no poner false ojo
stockvspptocruzado<-merge(x=stockvsppto,y=syslanstock,by.x = "CODIGO",all.x = TRUE)
stockvspptocruzado<-stockvspptocruzado %>% arrange(Presentación)
# convirtiendo los formatos a fecha correctos
guion<-which(substr(stockvspptocruzado$VCTO,start = 3,stop = 3)=="-")
stockvspptocruzado$VCTO[guion]<-paste0("01-",stockvspptocruzado$VCTO[guion])


# str(stockvspptocruzado)

# generamos las variables para que nos solicitó katty
# stockvspptocruzado$`Ppto Unid`
presentaciónunida<-stockvspptocruzado %>% group_by(Presentación) %>%
  dplyr::summarise(Lote=paste(LOTE,collapse = " , "),Vencimiento=paste(VCTO,collapse = " , "),Unidades=paste(VTAS,collapse = " , "),
                   PPTOsoles=mean(as.numeric(`Ppto S/`)), PPTOunidades=mean(as.numeric(`Ppto Unid`)), 
                   STOCK=mean(as.numeric(Stock)), CODIGO=CODIGO[1], DIFERENCIA=(as.numeric(Stock)- as.numeric(`Ppto Unid`))[1],ESTADO=Estado[1])

# str(presentaciónunida)
# ordenamos las variables para que sea presentable
presentaciónunida<-presentaciónunida %>% select(Presentación, CODIGO, PPTOsoles, PPTOunidades, STOCK, DIFERENCIA, ESTADO, Vencimiento, Lote, Unidades)




write_xlsx(presentaciónunida,paste0("stockvspptocruzado_hoy_",today(),".xlsx"))

rm(list = ls())
