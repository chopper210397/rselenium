# install.packages("RSelenium")
library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)
#rvest parsea el html y lo pone en un formato manejable
#tidyverse sirve para hacer todo el manejo de datos
#rselenium es un sistema de java que sirve para testear o simular software

#estamos haciendo la conexion mediante firefox
driver <- rsDriver(browser = c("chrome"),port = 4446L)
remote_driver <- driver[["client"]]

remote_driver$open()
Sys.sleep(2)
# url de la pagina del login
remote_driver$navigate("http://179.43.97.82:8081/distribuidora/login.zul;jsessionid=3633CFA707580B3ED1A0B8A783EAE344")
Sys.sleep(2)
#enviar usuario
rm(username,passwd,idlogin,idpasswd,key,id71lansier,iddescargadetalle,idgenpaquetes,idlinea,idmesdic,idmesnov,idpaquetes,idperiodo,key2)

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












