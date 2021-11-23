# install.packages("RSelenium")
library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)
#rvest parsea el html y lo pone en un formato manejable
#tidyverse sirve para hacer todo el manejo de datos
#rselenium es un sistema de java que sirve para testear o simular software

#estamos haciendo la conexion mediante firefox
driver <- rsDriver(browser = c("firefox"),port = 4443L)
remote_driver <- driver[["client"]]

remote_driver$open()

# url de la pagina del login
remote_driver$navigate("http://179.43.97.82:8081/distribuidora/login.zul;jsessionid=3633CFA707580B3ED1A0B8A783EAE344")

#enviar usuario
username <- remote_driver$findElement(using = "class",
                                      value ="z-textbox")

username$clearElement()
username$sendKeysToElement(list("ksarmiento", "\uE007"))


#enviar contraseña
passwd <- remote_driver$findElement(using = "class",
                                    value = "z-textbox")
passwd$clearElement()
passwd$sendKeysToElement(list("3217"))

#click en login para entrar
login <- remote_driver$findElement(using = "id",value = "z0FQl")
login$clickElement()
# hasta aqui ya logre ingresar a la pagina logeandome, ahora a extraer la data necesaria

#click en compras
compras <- remote_driver$findElement(using = "id",value = "jMeYx")
compras$clickElement()

#click en paquetes
paquetes <- remote_driver$findElement(using = "id",value = "jMeYa0-cnt")
paquetes$clickElement()

#click en generar paquetes
generarpaquetes <- remote_driver$findElement(using = "id",value = "jMeYb0-a")
generarpaquetes$clickElement()

#click en linea
linea <- remote_driver$findElement(using = "id",value = "jMeY20-btn")
linea$clickElement()

#click en 71-LANSIER
LANSIER <- remote_driver$findElement(using = "id",value = "jMeYp2")
LANSIER$clickElement()

#click en el periodo
periodo <- remote_driver$findElement(using = "id",value = "jMeY22-btn")
periodo$clickElement()

#click en el mes deseado
# solo esta configurado para noviembre y diciembre ojo, para el proximo año se debe configurar de nuevo
clickmes <- remote_driver$findElement(using = "id",
                                      value = ifelse(month(today())==11,
                                                     "jMeYe1",
                                                     "jMeYd1"))
clickmes$clickElement()

#click en descargar detalle
descargadetalle <- remote_driver$findElement(using = "id",value = "jMeYo0")
descargadetalle$clickElement()











