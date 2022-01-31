#---------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#
# ---- DESCARGA DE DATA - DESCARGA DE DATA - DESCARGA DE DATA - DESCARGA DE DATA - DESCARGA DE DATA ----- #
#---------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

# install.packages("RSelenium")
library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)
#rvest parsea el html y lo pone en un formato manejable
#tidyverse sirve para hacer todo el manejo de datos
#rselenium es un sistema de java que sirve para testear o simular software

#estamos haciendo la conexion mediante firefox
driver <- rsDriver(browser = c("firefox"),port = 4446L)
remote_driver <- driver[["client"]]

remote_driver$open()
Sys.sleep(2)
# url de la pagina del login
remote_driver$navigate("http://179.43.97.82:8081/distribuidora/login.zul;jsessionid=3633CFA707580B3ED1A0B8A783EAE344")
Sys.sleep(2)
#enviar usuario
# rm(username,passwd,idlogin,idpasswd,key,id71lansier,iddescargadetalle,idgenpaquetes,idlinea,idmesdic,idmesnov,idpaquetes,idperiodo,key2)

username <- remote_driver$findElement(using = "class",value = "z-textbox")
username$clearElement()
username$sendKeysToElement(list("ksarmiento"))


#obteniendo id de el password
#con esto ya se que mi id es este, y como ya se que para el password solo cambia la letra final y el numero de caracteres no cambias
#entonces puedo modificarlo y listo, tengo el id para mi otra busqueda
key<-username$getElementAttribute("id")
key<-substr(key,1,4)
idpasswd<-paste0(key,"i")
idlogin<-paste0(key,"l")

#enviar contraseña
passwd <- remote_driver$findElement(using = "id",value = idpasswd)
passwd$clearElement()
passwd$sendKeysToElement(list("3217"))
Sys.sleep(2)

#click en login para entrar
login <- remote_driver$findElement(using = "id",value = idlogin)
login$clickElement()
# hasta aqui ya logre ingresar a la pagina logeandome, ahora a extraer la data necesaria

#click en compras
compras <- remote_driver$findElement(using = "class",value = "z-button")
compras$clickElement()
key2<-compras$getElementAttribute("id")
key2<-substr(key2,1,4)
idpaquetes<-paste0(key2,"50-cnt")
idgenpaquetes<-paste0(key2,"60-a")   
idlinea<-paste0(key2,"k0-btn")
id71lansier<-paste0(key2,"92")
idperiodo<-paste0(key2,"x0-btn")
idmesnov<-paste0(key2,"n2")
idmesdic<-paste0(key2,"a2")
iddescargadetalle<-paste0(key2,"h1")
#click en paquetes
paquetes <- remote_driver$findElement(using = "id",value = idpaquetes)
paquetes$clickElement()

#click en generar paquetes
generarpaquetes <- remote_driver$findElement(using = "id",value = idgenpaquetes)
generarpaquetes$clickElement()

#click en linea
linea <- remote_driver$findElement(using = "id",value = idlinea)
linea$clickElement()

#click en 71-LANSIER
LANSIER <- remote_driver$findElement(using = "id",value = id71lansier)
LANSIER$clickElement()

#click en el periodo
periodo <- remote_driver$findElement(using = "id",value = idperiodo)
periodo$clickElement()

#click en el mes deseado
# solo esta configurado para noviembre y diciembre ojo, para el proximo año se debe configurar de nuevo
clickmes <- remote_driver$findElement(using = "id",
                                      value = ifelse(month(today())==11,
                                                     idmesnov,
                                                     idmesdic))

clickmes$clickElement()

#click en descargar detalle
descargadetalle <- remote_driver$findElement(using = "id",value = iddescargadetalle)
descargadetalle$clickElement()

# una vez descargada la data, ahora toca formatear todo

#--------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------#
# --- FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA ----- #
#--------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------#
library(dplyr)
library(readxl)
library(lubridate)
library(writexl)

data<-read_xlsx(path = paste0("C:\\Users\\LBarrios\\Downloads\\LANSIER-",
                        year(today()),
                        "-",
                        ifelse(month(today())==12,"DICIEMBRE","ENERO"),
                        ".xlsx" ))
# names(data)

# creando columna fuente que diga M&M
data<-data %>% mutate(FUENTE="M&M")

# creando columna periodo con el primer dia del mes a actualizar
data<-data %>% mutate(periodo=paste0("01/",
                                     ifelse(month(today())<10,paste0("0",month(today())),month(today())),
                                     "/",
                                     year(today())))

# insertando columna ELIMINAR en vacio
data<-data %>% mutate(ELIMINAR="")

# creando columna DSCZONA 
data<-data %>% mutate(DSCZONA="")

# creando ppuni ppsol flag dpto dist prov que estaran vacias
data<-data %>% mutate(ppuni="") %>%
  mutate(ppsol="") %>% mutate(flag="") %>% mutate(dpto="") %>% mutate(dist="") %>% mutate(prov="")

# DATA2 TIENE EL FORMATO QUE SE CARGARIA AL SQL
data2<-data %>%
  select(FUENTE,
         periodo,NUMERO,
         FECHA,RUC,ELIMINAR,
         `NOMBRE CLIENTE`,DOCUMENTO,DESCRIPCION,CANTIDAD,
         SUBTOT,DSCZONA,VENDEDOR,ppuni,ppsol,flag,DEPARTAMENTO,LOCALIDAD,PROVINCIA)
# ---------------------------------------------------------------------------------------------- #
#----------------- trayendo data externa para validar y/o cruzar mi data ------------------------#
# ---------------------------------------------------------------------------------------------- #

# trayendo el excel con todas las localidades para mym con lo cual se cruzará todo
# con esto leo el maestro lansier con el cual cruzare mi data
maestrolansier <- read_xlsx("maestrolansier.xlsx")
localidadesmym <- read_xlsx("localidadesmym.xlsx")
localidadesmym<-localidadesmym %>% select(LOCALIDAD,ZONA)
# PRIMERO CRUZAMOS CONTRA EL MAESTRO LANSIER
# aqui selecciono lo que voy a cruzar
# df1<-data2 %>% select(Artículo)
df2<-maestrolansier %>% select(`M&M`,`artdsc VALID`,TIPO,equipo)
# cambio el nombre a df2 para que coincida el nombre de la columna articulo para poder hacer el merge
colnames(df2)<-c("DESCRIPCION","artdesvalid","tipo","equipo")
# con esto quito los espacios adelante y detrás del artdesvalid Y LOS ARTICULOS
data2$DESCRIPCION<-trimws(data2$DESCRIPCION,"b")
df2$DESCRIPCION<-trimws(df2$DESCRIPCION,"b")
df2$artdesvalid<-trimws(df2$artdesvalid,"b")
# validando productos
productosnuevosmym<-data2[!data2$DESCRIPCION %in% df2$DESCRIPCION,]
write_xlsx(productosnuevosmym,"productosnuevosmym.xlsx")
# ----------------------------------------------------- #
# ---CRUCE DE INFORMACIÓN PARA OBTENER LOS VALIDADOS--- #
# ----------------------------------------------------- #
# cruzando para obtener los validados, tipo y equipo
ArtdesValid2<-merge(x = data2, y = df2, by.x = "DESCRIPCION", all.x = TRUE)

# validando que esten las mismas localidades
localidadesnuevasmym<-ArtdesValid2[!ArtdesValid2$LOCALIDAD %in% localidadesmym$LOCALIDAD,]
write_xlsx(localidadesnuevasmym,"localidadesnuevasmym.xlsx")
#
# CRUZANDO PARA OBTENER LA LOCALIDAD
ArtdesValid3<-merge(x = ArtdesValid2, y=localidadesmym, by.x = "LOCALIDAD", all.x = TRUE)
ArtdesValid3<-ArtdesValid3 %>%
  select(FUENTE,periodo,NUMERO,FECHA,RUC,ELIMINAR,`NOMBRE CLIENTE`,DOCUMENTO,DESCRIPCION,artdesvalid,CANTIDAD,
                                      SUBTOT,DSCZONA,ZONA,VENDEDOR,tipo,equipo,ppuni,ppsol,flag,DEPARTAMENTO,LOCALIDAD,PROVINCIA)

write_xlsx(ArtdesValid3,"mym.xlsx")
# en esta ocasion todo ha cruzado asi que esta bien
# este codigo de abajo es para ver si todas las localidades son las mismas
# a<-subset(data, !(LOCALIDAD %in% localidadesmym$LOCALIDAD))
rm(list = ls())
