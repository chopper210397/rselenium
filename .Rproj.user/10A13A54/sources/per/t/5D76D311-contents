library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)
library(readxl)
library(lubridate)
Sys.sleep(10)
# este pagina es la que nos brinda la parte de application/vnd.... , esto es necesario ponerlo para que el buscador de firefox no nos pregunte si queremos 
# guardar o abrir el archivo, porque eso mata todo el codigo, mediante este codigo, especifico para documentos con terminación xls, podemos saltar el pop-up
# y descargar directamente en la carpeta de descargas o downloads de la página.
# https://www.freeformatter.com/mime-types-list.html
driver <- rsDriver(browser = c("firefox"),port = 4440L, extraCapabilities = makeFirefoxProfile(list(
  "browser.helperApps.neverAsk.saveToDisk"="application/vnd.ms-excel")
))

remote_driver <- driver[["client"]]

# install.packages("Rtools") por seacaso

Sys.sleep(6)
remote_driver$navigate("http://www.lansierweb.com:9300/FACTURACION/FacturacionMetronic.aspx?JER=divMenuLBTR_1_01.02")
Sys.sleep(7)
# con esto hacemos click en LABORATORIOS LANSIER S.A.C 
# FORMA GENIAL DE SELECCIONAR MEDIANTE ID Y VALUE, NO SABIA HACERLA ANTES
empresa<- remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
empresa$clickElement()  

# CODIGOS QUE PUEDEN SER UTILES MAS ADELANTE

# empresa$highlightElement()
# options<-empresa$selectTag()
# options$text
# options$value
# options$selected
# options$elements[[2]]$clickElement()
# options$elements
# rm(empresa)

# USUARIO
username<-remote_driver$findElement(using = "id", value = "txtUsuario")
username$sendKeysToElement(list("ABA"))

# PASSWORD
psswd<-remote_driver$findElement(using = "id",value = "txtClave")
psswd$sendKeysToElement(list("72722698","\uE007"))

# ahora que ya entre a la pagina solo falta hacer click en  descargar excel
# DESCARGAR EXCEL
# PARA SELECCIONAR EL EXCEL AL PARECER CUALQUIERA DE ESTOS COMANDOS ME ES VALIDO, MAS ADELANTE PROBAR DE NUEVO
Sys.sleep(7)
downloadexcel<-remote_driver$findElement(using = "id",value = "ctl00_ContentPlaceHolder1_ibtn_Excel")
# downloadexcel<-remote_driver$findElement(using = "class",value = "Boton")
# downloadexcel<-remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
# downloadexcel<-remote_driver$findElement(using = "xpath",value = "//*[@id='ctl00_ContentPlaceHolder1_ibtn_Excel']")
# downloadexcel<-remote_driver$findElement(using = "css",value = "html.js.canvas.canvastext.geolocation.crosswindowmessaging.no-websqldatabase.indexeddb.hashchange.historymanagement.draganddrop.websockets.rgba.hsla.multiplebgs.backgroundsize.borderimage.borderradius.boxshadow.opacity.cssanimations.csscolumns.cssgradients.no-cssreflections.csstransforms.csstransforms3d.csstransitions.video.audio.localstorage.sessionstorage.webworkers.no-applicationcache.svg.smil.svgclippaths.fontface body.sidebar-left.chart div#container form#aspnetForm div#page div#page-content.container_12 div#contenidoss div.grid_12 div div.box div.div_bloque input#ctl00_ContentPlaceHolder1_ibtn_Excel.Boton")
# downloadexcel<-remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
# downloadexcel<-remote_driver$findElement(using = "name",value = "ctl00$ContentPlaceHolder1$ibtn_Excel")
# downloadexcel<-remote_driver$findElement(using = "partial link text",value = "../App_Themes/COMERCIO/Images/botones/ico_excel.png")
# downloadexcel<-remote_driver$findElement(using = 'xpath', "//*[@id='ctl00_ContentPlaceHolder1_ibtn_Excel']")
# downloadexcel$getElementLocation()
# downloadexcel<-remote_driver$mouseMoveToLocation()
Sys.sleep(2)
# CLICK DESCARGA EXCEL: ESTAMOS USANDO OTRO METODO DISTINTO AL CLICK ELEMENT ANTERIOR, AHORA ESTAMOS HACIENDO OTRO METODO, SITUANDO EL MOUSE EN LA COORDENADA Y DANDOLE CLICK
remote_driver$mouseMoveToLocation(webElement = downloadexcel)
remote_driver$click(buttonId = "RIGHT")

# CON ESTO HASTA AQUI YA DEBERIA ESTAR DESCARGADO EL EXCEL

############################################################################################
############################################################################################
############    TRABAJANDO LA DATA    ############    TRABAJANDO LA DATA    ################
############################################################################################
############################################################################################

# gracias a este paquete pude leer el excel, ya que de otra forma no podia
# install.packages("XLConnect")
library(XLConnect)
library(dplyr)
Sys.sleep(3)
data <- readWorksheetFromFile("C:\\Users\\LBarrios\\Downloads\\FacMet_20211125.xls", sheet = "FacturacionMetronic",
                              startRow = 6,
                              startCol = 1)

# retirando las columnas que eran merge de las otras
data<-data %>% select(-Col6,-Col12)

data2<-data %>% filter(Periodo=="202111")
data3<-data2 %>% filter(Artículo!="MACUVIT X 60 CAPSULAS")
rm(data3)



