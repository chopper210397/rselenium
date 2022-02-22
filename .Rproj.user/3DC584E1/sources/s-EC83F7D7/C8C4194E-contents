# difarlib envia su data por correo
# leyendo excel
library(readxl)
library(dplyr)
library(lubridate)
library(readr)
library(RODBC)
library(qdapTools)
library(plyr)
library(lookup)
library(XLConnect)
# con esto leemos la data de una fecha en específico dado que si no tenemos la data de hoy pero
# queremos cargar la data que nos pasaron de otro día copiamos el nombre del archivo en vez de lo nuestro
# data<-read_xls("C:\\Users\\LBarrios\\Downloads\\1. CIERRE DE VENTAS LANSIER - ENERO 2022.xls", sheet = "DATA",skip = 4)
# PARA FECHA DISTINTA A LA DE HOY
data<-read_xls("C:\\Users\\LBarrios\\Downloads\\AVANCE DE VENTAS LANSIER 21.02.22.xls", sheet = "DATA",skip = 4)


# con esta leemos la data de hoy
# data<-read_xls(paste0("C:\\Users\\LBarrios\\Downloads\\AVANCE DE VENTAS LANSIER ",
#                       day(today()),".",
# ifelse(month(today())<10,paste0("0",month(today())),month(today())),
# ".22.xls"), sheet = "DATA",skip = 4)




# eliminado la fila de totales ya que es la última fila siempre la eliminamos
totalrow<-nrow(data)

# totalrow<-which(data$VALOR=="203541.4974")
data<-data[-totalrow,]
# cambiando formato de la fecha
data$FECHA<-paste0(ifelse(day(data$FECHA)<10,paste0(0,day(data$FECHA)),day(data$FECHA)),
                   "-",
                   ifelse(month(data$FECHA)<10,paste0(0,month(data$FECHA)),month(data$FECHA))  ,
                   "-",
                   year(data$FECHA))



# creando columna fuente que diga METRONIC
data<-data %>% mutate(FUENTE="DIFARLIB")

# creando columna periodo con el primer dia del mes a actualizar
data<-data %>% mutate(periodo=paste0("01/",
                                     ifelse(month(today())<10,paste0("0",month(today())),month(today())),
                                     "/",
                                     year(today())))

# insertando columna ELIMINAR en vacio
data<-data %>% mutate(ELIMINAR="")

# creando columna DSCZONA 
data<-data %>% mutate(DSCVEND="")

# creando ppuni ppsol flag dpto dist prov que estaran vacias
data<-data %>% mutate(ppuni="") %>% mutate(ppsol="") %>% mutate(flag="")

# UNIENDO PRODUCTO Y PRESENTACION PARA HACER ARTDES 
data$ARTDES<-paste0(data$PRODUCTO," ",data$PRESENTACION)

# seleccionando solo las columnas que nos interesan
# DATA2 TIENE EL FORMATO QUE SE CARGARIA AL SQL
# AQUI NO ESTOY PONIENDO ZONA NI DSCVEND NI TIPO NI EQUIPO
# NI ARTDESVALID PORQUE ESOS SERAN LOS QUE TRAERÉ CON EL MERGE
data2<-data %>%
  select(FUENTE,periodo,DOC,FECHA,`RUC/DNI`,ELIMINAR,
         `NOMBRE COMERCIAL`,TIPO,ARTDES,
         CANT.,VALOR,DSCVEND,VENDEDOR,ppuni,ppsol,flag,DEPARTAMENTO,DISTRITO...22,PROVINCIA...21)



# LEYENDO DATA NECESARIA PARA VALIDAR
maestrolansier <- read_xlsx("maestrolansier.xlsx")
# selecciono solo lo que voy a querer de maestro lansier que para este caso seria DIMEXA artdesvalid tipo y equipo
df2<-maestrolansier %>% select(DIFARLIB,`artdsc VALID`,TIPO,equipo)
# cambio el nombre a df2 para que coincida el nombre de la columna articulo para poder hacer el merge
colnames(df2)<-c("ARTDES","artdesvalid","tipo","equipo")
# CON ESTO QUITO LOS ESPACIOS AL COMIENZO Y EL FINAL DE LOS ARTICULOS PORQUE NO PERMITIAN CRUZAR TODO
data2$ARTDES<-trimws(data2$ARTDES,"b")
df2$ARTDES<-trimws(df2$ARTDES,"b")
df2$artdesvalid<-trimws(df2$artdesvalid,"b")

# PRODUCTOS NUEVOS ARTDESVALID
productosnuevosdifarlib<-data2[!data2$ARTDES %in% df2$ARTDES,]
write_xlsx(productosnuevosdifarlib,"productosnuevosdifarlib.xlsx")

# TRAYENDO ARTDESVALID TIPO Y EQUIPO
data_maestro<-merge(x = data2, y = df2, by.x = "ARTDES", all.x = FALSE)

# creando la combinacion
data_maestro<-data_maestro %>% mutate(COMBINACION=paste0(PROVINCIA...21,DISTRITO...22))
# TRAER DATA LOCALIDADES DIFARLIB
localidadesdifarlib <- read_xlsx("localidadesdifarlib.xlsx")
localidadesdifarlib<-localidadesdifarlib %>% select(COMBINACION,ZONA)
localidadesdifarlib$COMBINACION<-trimws(localidadesdifarlib$COMBINACION,"b")
localidadesdifarlib$ZONA<-trimws(localidadesdifarlib$ZONA,"b")
data_maestro$COMBINACION<-trimws(data_maestro$COMBINACION,"b")

# VALIDANDO ZONAS NUEVAS
localidadesnuevasdifarlib<-data_maestro[!data_maestro$COMBINACION %in% localidadesdifarlib$COMBINACION,]
write_xlsx(localidadesnuevasdifarlib,"localidadesnuevasdifarlib.xlsx")

# AQUI MANUALMENTE SE DEBE PREGUNTAR AL SEÑOR RICARDO A QUE ZONAS PERTENECEN ESAS NUEVAS LOCALIDADES, UNA VEZ AGREGADAS
# EN EL EXCEL DE LOCALIDADES DIMEXA YA SE DEBE REGRESAR A R Y CORRER ESTA VEZ EL PROGRAMA COMPLETO
data_maestro_localidades<-merge(x = data_maestro, y=localidadesdifarlib, by.x = "COMBINACION", all.x = TRUE)

data_maestro_localidades<-data_maestro_localidades %>%
  select(FUENTE,periodo,DOC,FECHA,`RUC/DNI`,ELIMINAR,`NOMBRE COMERCIAL`,TIPO,ARTDES,artdesvalid,CANT.,
         VALOR,DSCVEND,ZONA,VENDEDOR,tipo,equipo,ppuni,ppsol,flag,DEPARTAMENTO,DISTRITO...22,PROVINCIA...21)
# ERROR COMÚN: no deberia dar mas registros en data maestro localidades que en data maestro, deberían ser la misma
# cantidad de observaciones, esto ocurre porque en el archivo fuente hay filas repetidas lo cual esta mal y hace que el programa
# de errores, revisar esto en el archivo de localidades por lo general esto ocurre ahi porque hay repetidos

# x<-data_maestro[!data_maestro$COMBINACION %in% data_maestro_localidades$COMBINACION,]
# chequear que siempre data_maestro sea igual a data_maestro_localidades porque sino

write_xlsx(data_maestro_localidades,"difarlib.xlsx")
# limpiando nuestra ventana
rm(list=ls())

