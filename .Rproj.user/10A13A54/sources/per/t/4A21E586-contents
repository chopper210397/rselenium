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
username$sendKeysToElement(list("P625"))


passwd<-remote_driver$findElement(using="id",value="z_d__o")
passwd$clearElement()
passwd$sendKeysToElement(list("895623"))

login <- remote_driver$findElement(using = "id",value ="z_d__r")
login$clickElement()

# VENTA DETALLADA
ventadetallada <- remote_driver$findElement(using = "id",value = "z_d__u")
ventadetallada$clickElement()

# DESCARGANDO DATA PARA AREQUIPA
# LA PRIMERA UNIDAD AREQUIPA VIENE SELECCIONADA POR DEFECTO

# LINEA
LINEA <- remote_driver$findElement(using = "id",value = "z_d__a3-btn")
LINEA$clickElement()

# 128-LANSIER
LINEA128 <- remote_driver$findElement(using = "id",value = "z_d__h5-pp")
LINEA128$clickElement()

# DIVISION
DIVISION<- remote_driver$findElement(using = "id",value = "z_d__k5-btn")
DIVISION$clickElement()

# SALUD
SALUD<- remote_driver$findElement(using = "xpath",value = "/html/body/div[4]/table/tbody/tr[3]/td[2]")
SALUD$clickElement()

# BUSCANDO POR EL XPATH PUEDE SER UNA BUENA SOLUCION EN ALGUNOS CASOS
# DONDE NO ENCUENTRA NI MEDIANTE ID NI CSS



# PERIODO
PERIODO<- remote_driver$findElement(using = "id",value = "z_d__52-btn")
PERIODO$clickElement()

# NOVIEMBRE2021
NOVIEMBRE2021<- remote_driver$findElement(using = "id",value = "z_d__74 > td.z-comboitem-text")
NOVIEMBRE2021$clickElement()

# PROCESAR
PROCESAR<- remote_driver$findElement(using = "id",value = "z_d__b2")
PROCESAR$clickElement()

# EXPORTAR
EXPORTAR<- remote_driver$findElement(using = "id",value = "z_d__t3 > div > div")
EXPORTAR$clickElement()

# AHORA PARA PASAR A LA SIGUIENTE UNIDAD QUE SERIA HUANCAYO

# IGNORAR
IGNORAR<- remote_driver$findElement(using = "id",value = "z_d__u3 > div > div")
IGNORAR$clickElement()

# HASTA AQUI ME QUEDO, DE AQUI EN ADELANTE DEBERIA SER REPETIR LOS MISMOS PROCESOS DE ARRIBA PARA TODAS LAS ZONAS O UNIDADES
# NO HE AVANZADO CON METRONIC PORQUE EL VPN SE COLGO Y SIN EL VPN NO TENGO FORMA DE INSPECCIONA LA WEB



































