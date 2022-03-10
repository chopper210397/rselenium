#-----------------------------------------------------------------#
#                      PRECIOS MINSA                              #
#-----------------------------------------------------------------#

# cargando paquetes
library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(writexl)
# install.packages("openxlsx")
library(openxlsx)

# leyendo paul
datapaul<-read_xlsx("Ventas Lansier 2022 DataPaul.xlsx",sheet = "datapaul",
                    col_types = c("numeric","numeric","text","numeric","text","text","text","text","text","text",
                                  "numeric","numeric","numeric","numeric","numeric","numeric","text","text","text","text",
                                  "text","numeric","numeric","text","numeric","text","text","text","text","numeric"
                                  ,"text","text"))

# datapaul<-read_xlsx("Ventas Lansier 2022 DataPaul.xlsx",sheet = "datapaul")
# str(datapaul)
# unique(datapaul$tipocl)
# seleccionando el periodo del mes anterior para hacer los precios minsa
# datapaul<-datapaul %>% filter(periodo==paste0(substr(today(),0,4) ,ifelse( month(today())-1<10,paste0("0",month(today())-1),month(today())-1 )))
# seleccionando un mes cualquiera a elección, se debe cambiar el "202201" por la fecha deseada, solo escribir y correr ese código
datapaul<-datapaul %>% filter(periodo=="202201")

# seleccionando distribuidores porque es lo unico que nos importa para precios minsa
datapaul<-datapaul %>% filter(tipocl=="DISTRIBUIDORES")
datapaul<-datapaul %>% filter(codart!="NA")
a<-datapaul %>% group_by(codart,artdes,codclie,clienom,idfactura) %>% summarise(Unidades=sum(cant),Soles=sum(subtotal))
a<-a %>% filter(codart!="TEXTO")
# ELIMINANDO PRODUCTOS COVID
a<-a %>% filter(!(codart %in% c("VESOGVT001","VESOGVT002","VESOTR001","VESOTR002","VESOTR003","VESOTR004")))
a<-a %>% filter(clienom!="METRONIC SAC")
a<-a %>% filter(clienom!="Cuota")
# creando el precio
a<-a %>% mutate(Precio=Soles/Unidades)
# redondeando a 3 digitos porque ellos quieren que esté asi
a$Precio<-round(a$Precio,digits = 3)
a$Soles<-round(a$Soles,digits = 3)
# ordenando por artdes
a<-a %>% arrange(artdes,-Precio)
# con esto evitamos que se repitan los clientes por producto
a<-a %>% distinct(codart,.keep_all = TRUE)

# ahora hacer una columna con el mayor, menor y media de precio por producto
maximo<-a %>% group_by(artdes) %>% summarise(Maximo=max(Precio))
minimo<-a %>% group_by(artdes) %>% summarise(Minimo=min(Precio))
promedio<-a %>% group_by(artdes) %>% summarise(Media=mean(Precio))

# uniendo los valores hallados con la data original
a<-merge(a,maximo,by = "artdes",all.x = TRUE)
a<-merge(a,minimo,by = "artdes",all.x = TRUE)
a<-merge(a,promedio,by = "artdes",all.x = TRUE)

# redondeando a 3 digitos los valores hallados
a$Maximo<-round(a$Maximo,digits = 3)
a$Minimo<-round(a$Minimo,digits = 3)
a$Media<-round(a$Media,digits = 3)

# RECORDAR QUE NO DEBEN HABER PRODUCTOS COVID AQUI
# HASTA AQUI GENERAMOS EL FORMATO QUE SIRVE PARA PRECIOS MINSA Y PRECIOS PRODUCCIÓN
# write_xlsx(a,"sustentopreciosminsa.xlsx")

# con esto descubrimos cual es el numero de fila para el primer ejemplar de cada producto
filasbordear<-1
for (i in 1:nrow(maximo)) {
  filasbordear[i]<-which(a$artdes %in% maximo$artdes[i] , arr.ind = TRUE)[1]  
  
}

wb <- openxlsx::createWorkbook()

addWorksheet(
  wb = wb,
  sheetName = "Preciosminsa"
)
rangeRows=filasbordear
rangecols=1:11

insideBorders <- openxlsx::createStyle(
  border = c( "bottom"),
  borderStyle = "thin"
)

openxlsx::addStyle(
  wb = wb,
  sheet = "Preciosminsa",
  style = insideBorders,
  rows = rangeRows,
  cols = rangecols,
  gridExpand = TRUE
)

writeData(wb,"Preciosminsa",a,startRow = 1,startCol = 1)

saveWorkbook(wb,file = "prueba.xlsx",TRUE)

rm(list = ls())
