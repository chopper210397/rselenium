library(readxl)
library(dplyr)
library(lubridate)
library(readr)
#--------------------
# ------------ con trimws puedo quitar los espacios iniciales y finales de un texto --------- #
# x<- "  texto con espacios "
# trimws(x,"b")
#--------------------
data<-read.csv(file = "C:/Users/LBarrios/Downloads/VTADTOFTEPL1639575419528_1522.csv")
data<-data %>% mutate(fecha_update=(as.Date(paste0(ifelse(day(today())-1<10,paste0("0",day(today())-1),day(today())-1),
                                     "/",
                                     month(today()),
                                     "/",
                                     year(today())),"%d/%m/%Y")))
data<-data %>% mutate(periodo=as.Date( paste0("01","/",month(today()),"/",year(today())),"%d/%m/%Y")) #esta fecha esta para el mes actual, si se desea algun mes en especial se debe cambiar
# -------------formato stock-----------
# fecha_update
# COD_LOCAL
# DESCRIPCION
# INVENTARIO.u.
# INVENTARIO.S.
# -----------formato ventas-----------
# periodo
# fecha_update
# DESCRIPCION
# COD_LOCAL
# VTA_PERIODO_UNID
# VALOR_VTA_PUB_PERIODO_S
stock<-data %>% select(fecha_update,COD_LOCAL,DESCRIPCION,INVENTARIO.u.,INVENTARIO.S.)
write_tsv(stock, file = "stockb2b.txt", na = " ")

venta<-data %>% select(periodo,fecha_update,DESCRIPCION,COD_LOCAL,VTA_PERIODO_UNID,VALOR_VTA_PUB_PERIODO_S)
write_tsv(venta, file = "ventab2b.txt",na = " ")




