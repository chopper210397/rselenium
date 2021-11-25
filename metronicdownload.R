library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)

driver <- rsDriver(browser = c("firefox"),port = 4447L)
remote_driver <- driver[["client"]]


remote_driver$navigate("http://www.lansierweb.com:9300/FACTURACION/FacturacionMetronic.aspx?JER=divMenuLBTR_1_01.02")

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

# CLICK DESCARGA EXCEL: ESTAMOS USANDO OTRO METODO DISTINTO AL CLICK ELEMENT ANTERIOR, AHORA ESTAMOS HACIENDO OTRO METODO, SITUANDO EL MOUSE EN LA COORDENADA Y DANDOLE CLICK
remote_driver$mouseMoveToLocation(webElement = downloadexcel)
remote_driver$click(buttonId = "RIGHT")

# CON ESTO HASTA AQUI YA DEBERIA ESTAR DESCARGADO EL EXCEL
#########################################################################################



































