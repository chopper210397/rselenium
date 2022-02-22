library(RSelenium)
library(rvest)
library(tidyverse)
library(lubridate)
library(dplyr)
library(writexl)
library(readxl)
library(RODBC)

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

#--------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------#
# --- FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA - FORMATEO DE DATA ----- #
#--------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------#
# son 4 los departamentos que se descarga la data en dimexa
detalle <- read_xlsx("C:\\Users\\LBarrios\\Downloads\\detalle.xlsx")
detalle1 <- read_xlsx("C:\\Users\\LBarrios\\Downloads\\detalle (1).xlsx")
detalle2 <- read_xlsx("C:\\Users\\LBarrios\\Downloads\\detalle (2).xlsx")
detalle3 <- read_xlsx("C:\\Users\\LBarrios\\Downloads\\detalle (3).xlsx")

# combinando los 4 departamentos descargados de dimexa
data<-rbind(detalle,detalle1,detalle2,detalle3)
rm(detalle,detalle1,detalle2,detalle3)
# cambiando el formato de la fecha
data$FECHA<-paste0(ifelse(day(data$FECHA)<10,paste0(0,day(data$FECHA)),day(data$FECHA)),
                   "/",
                  ifelse(month(data$FECHA)<10,paste0(0,month(data$FECHA)),month(data$FECHA))  ,
                  "/",
                  year(data$FECHA))
# creando columna fuente que diga METRONIC
data<-data %>% mutate(FUENTE="DIMEXA")

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

# seleccionando solo las columnas que nos interesan
# DATA2 TIENE EL FORMATO QUE SE CARGARIA AL SQL
# AQUI NO ESTOY PONIENDO ZONA NI DSCVEND NI TIPO NI EQUIPO
# NI ARTDESVALID PORQUE ESOS SERAN LOS QUE TRAERÁN CON EL MERGE
data2<-data %>%
  select(FUENTE,periodo,`NUMERO FACTURA`,FECHA,`RUC CLIENTE`,ELIMINAR,
         `NOMBRE CLIENTE`,`TIPO DOCUMENTO`,`NOMBRE PRODUCTO`,
         CANTIDAD,`SUB TOTAL`,`NOMBRE VENDEDOR`,ppuni,ppsol,flag,DEPARTAMENTO,DISTRITO,PROVINCIA)

# marcar una E en eliminar cuando el nombre del vendedor sea BRUNY CHAVEZ SALAS o MERCEDES COTRINA VERGEL
# primero identificamos la posicion de las filas donde esta bruny y mercedes
BRUNYNROW<-which(data2$`NOMBRE VENDEDOR` == "BRUNY CHAVEZ SALAS", arr.ind=TRUE)
MERCEDESNROW<-which(data2$`NOMBRE VENDEDOR` == "MERCEDES COTRINA VERGEL", arr.ind=TRUE)
# ahora le decimos que para esas filas ponga una E en la columna Eliminar
data2$ELIMINAR[BRUNYNROW]="E"
data2$ELIMINAR[MERCEDESNROW]="E"
# data$ELIMINAR[BRUNYNROW]
# write_xlsx(data,"dimexa.xlsx")
# LEYENDO DATA NECESARIA PARA VALIDAR
maestrolansier <- read_xlsx("maestrolansier.xlsx")
# selecciono solo lo que voy a querer de maestro lansier que para este caso seria DIMEXA artdesvalid tipo y equipo
df2<-maestrolansier %>% select(DIMEXA,`artdsc VALID`,TIPO,equipo)
# cambio el nombre a df2 para que coincida el nombre de la columna articulo para poder hacer el merge
colnames(df2)<-c("NOMBRE PRODUCTO","artdesvalid","tipo","equipo")
# CON ESTO QUITO LOS ESPACIOS AL COMIENZO Y EL FINAL DE LOS ARTICULOS PORQUE NO PERMITIAN CRUZAR TODO
data2$`NOMBRE PRODUCTO`<-trimws(data2$`NOMBRE PRODUCTO`,"b")
df2$`NOMBRE PRODUCTO`<-trimws(df2$`NOMBRE PRODUCTO`,"b")
df2$artdesvalid<-trimws(df2$artdesvalid,"b")

# EL SIGUIENTE PASO ES OPCIONAL, PORQUE IGUAL EN EL MERGE SIGUIENTE NO SE TOMARÃÂ EN CUENTA LOS PRODUCTOS QUE NO SE CRUCEN
# antes de cruzar debemos validar que esten los mismo productos y cuales no reconoce
productosnuevosdimexa<-data2[!data2$`NOMBRE PRODUCTO` %in% df2$`NOMBRE PRODUCTO`,]
write_xlsx(productosnuevosdimexa,"productosnuevosdimexa.xlsx")
# lo hallado vendrÃÂ­a a ser lo que esta en nuestra data descargada y no esta en los productos de nuestro maestro

# ----------------------------------------------------- #
# ---CRUCE DE INFORMACIÃÂN PARA OBTENER LOS VALIDADOS--- #
# ----------------------------------------------------- #
# cruzando para obtener los validados, tipo y equipo
# ArtdesValid2<-merge(x = data2, y = df2, by.x = "NOMBRE PRODUCTO", all.x = TRUE)
# utilizamos con all.x = false porque de ese modo no trae las toallitas humedas ni alcohol en gel, dado que no
# son productos de lansier
data_maestro<-merge(x = data2, y = df2, by.x = "NOMBRE PRODUCTO", all.x = FALSE)
# CRUZANDO PARA OBTENER LA LOCALIDAD
# 1. concatenamos departamento + distrito de nuestra data_maestro para generar la llave
data_maestro<-data_maestro %>% mutate(LLAVE=paste0(DEPARTAMENTO,DISTRITO))
# TRAEMOS LA DATA DE LOCALIDADESDIMEXA
localidadesdimexa <- read_xlsx("localidadesdimexa.xlsx")
localidadesdimexa<-localidadesdimexa %>% select(LLAVE,ZONA)
localidadesdimexa$LLAVE<-trimws(localidadesdimexa$LLAVE,"b")
localidadesdimexa$ZONA<-trimws(localidadesdimexa$ZONA,"b")
data_maestro$LLAVE<-trimws(data_maestro$LLAVE,"b")
# por alguna razon con allx=true da mas filas de las que existen, habra que verificar de donde agrega mÃÂ¡s
# mientras que con allx=false trae el mismo numero de filas que hay en data_maestro que al parecer
# deberia ser lo correcto, hay que revisar ello

# VALIDANDO QUE HAYA LAS MISMAS LOCALIDADES TANTO EN NUESTRO EXCEL DESCARGADO COMO EN EL MAESTRO DE LOCALIDADES, 
# SI NO ESTAN DEBERÃÂN AGREGARSE PARA QUE PUEDAN CRUZARSE CORRECTAMENTE LUEGO.
localidadesnuevasdimexa<-data_maestro[!data_maestro$LLAVE %in% localidadesdimexa$LLAVE,]
write_xlsx(localidadesnuevasdimexa,"localidadesnuevasdimexa.xlsx")
#

# AQUI MANUALMENTE SE DEBE PREGUNTAR AL SEÃÂOR RICARDO A QUE ZONAS PERTENECEN ESAS NUEVAS LOCALIDADES, UNA VEZ AGREGADAS
# EN EL EXCEL DE LOCALIDADES DIMEXA YA SE DEBE REGRESAR A R Y CORRER ESTA VEZ EL PROGRAMA COMPLETO


data_maestro_localidades<-merge(x = data_maestro, y=localidadesdimexa, by.x = "LLAVE", all.x = TRUE)
# TRAEMOS LA DATA DE VENDEDORES PARA CRUZARLA MEDIANTE EL RUC
vendedoresdimexa<-read_xlsx("vendedoresdimexa.xlsx")
vendedoresdimexa<-vendedoresdimexa %>% select(ruc,flag)
colnames(vendedoresdimexa)<-c("RUC CLIENTE","DSCVEND")
# quitando los espacios en blanco delante y detrÃÂ¡s
data_maestro_localidades$`RUC CLIENTE`<-trimws(data_maestro_localidades$`RUC CLIENTE`,"b")
vendedoresdimexa$`RUC CLIENTE`<-trimws(vendedoresdimexa$`RUC CLIENTE`,"b")


# combinando y validando con la data de vendedoresdimexa para traer el dscvend o flag como estÃÂ¡ en vendedoresdimexa
dimexa<-merge(data_maestro_localidades,vendedoresdimexa,by.x = "RUC CLIENTE",all.x = TRUE)
# dandole orden a nuestro excel
dimexa<-dimexa %>%
  select(FUENTE,periodo,`NUMERO FACTURA`,FECHA,`RUC CLIENTE`,ELIMINAR,
         `NOMBRE CLIENTE`,`TIPO DOCUMENTO`,`NOMBRE PRODUCTO`,artdesvalid,
         CANTIDAD,`SUB TOTAL`,DSCVEND,ZONA,`NOMBRE VENDEDOR`,tipo,equipo,ppuni,ppsol,flag,DEPARTAMENTO,DISTRITO,PROVINCIA)


# # PARA RUC 20514304921 HACIENDO LOS CAMBIOS DEPENDIENDO DE LA ZONA A QUE DSCVEND PERTENECE
# nrowintifarma<-which(dimexa$`RUC CLIENTE` == "20514304921", arr.ind=TRUE)
# zonaintifarma<-dimexa$ZONA[nrowintifarma]
# ifelse(zonaintifarma=="LIMA CALLAO",dimexa$DSCVEND[nrowintifarma]<-"AB",
#        ifelse(zonaintifarma=="LIMA OESTE",dimexa$DSCVEND[nrowintifarma]<-"KM",
#               ifelse(zonaintifarma=="LIMA ESTE",dimexa$DSCVEND[nrowintifarma]<-"KM",
#                      ifelse(zonaintifarma=="LIMA NORTE",dimexa$DSCVEND[nrowintifarma]<-"JA",
#                             ifelse(zonaintifarma=="LIMA SUR",dimexa$DSCVEND[nrowintifarma]<-"JA",
#                                    )))))
# # PARA EL OTRO RUC 20543001075
# nrowotroruc<-which(dimexa$`RUC CLIENTE`=="20543001075",arr.ind = TRUE)
# zonanrowotroruc<-dimexa$ZONA[nrowotroruc]
# ifelse(zonanrowotroruc=="LIMA CALLAO",dimexa$DSCVEND[nrowotroruc]<-"AB",
#        ifelse(zonanrowotroruc=="LIMA OESTE",dimexa$DSCVEND[nrowotroruc]<-"KM",
#               ifelse(zonanrowotroruc=="LIMA ESTE",dimexa$DSCVEND[nrowotroruc]<-"KM",
#                      ifelse(zonanrowotroruc=="LIMA NORTE",dimexa$DSCVEND[nrowotroruc]<-"JA",
#                             ifelse(zonanrowotroruc=="LIMA SUR",dimexa$DSCVEND[nrowotroruc]<-"JA",
#                             )))))


# probando...
# encontrÃÂ© que la soluciÃÂ³n es la asignaciÃÂ³n mediante "<-", caso contrario me da una verificacion de verdad o falsedad
# dimexa$DSCVEND[nrowintifarma]
# dimexa$ZONA[nrowintifarma]
# # ahora le decimos que para esas filas ponga una E en la columna Eliminar
# data2$ELIMINAR[BRUNYNROW]="E"
# data2$ELIMINAR[MERCEDESNROW]="E"
# dimexa$ZONA[nrowintifarma]="LIMA OESTE"










# agregamos esta columna numero 24 para que se pueda subir la data directamente al sql
# dado que realmente nuestra data tiene 23 columnas pero en el sql hay 24
# dimexa[,24]=""
# colnames(dimexa)<-c("fuente","periodo","idfactura","fecha","ruc","eliminar","clienom",
#                     "tipocondi","artdes","artdesValid","cant","subtotal","dsczonadet","dsczona",
#                     "dscven","tipoart","colorequi","ppuni","ppsol","flag","dpto","distrito","provincia","categorizacion")
# #subiendo directamente al sql
# #conectando a ventalansier
# sqluis<-odbcConnect("SQLuis",uid = "sa",pwd = "Comercial.2020")
# # borrando el mes actual para que no se repita la data
# sqlQuery(sqluis,paste0("delete from Venta_Lansier where periodo='01/",
#                        ifelse(month(today())<10,paste0(0,month(today())),month(today())),
#                        "/",year(today()),"'") )
# # agregando la data de dimexa de este periodo al sql
# sqlSave(sqluis,dimexa,tablename = "Venta_Lansier",rownames = FALSE,append = TRUE,fast =FALSE)

# generando el xlsx con la data para subir al visor o sql
write_xlsx(dimexa,"dimexa.xlsx")
# limpiando nuestra ventana
rm(list=ls())

#-----------------------------------------------------------------------------------------------------------#
# el problema con vendedoresdimexa es que hay varios archivos que tienen repetido por lo tanto              #
# no se sabe cual es el correcto, cual seria la solucion?, si lo elimino no estoy seguro de cual tomar como #
# valor verdadero para validar                                                                              #
#-----------------------------------------------------------------------------------------------------------#

# problemas para vendedores
# hay dos empresas con estes ruc en el archivo vendedoresdimexa lo cual puede generara un error
# 20504680976 tiene 2 repetidos
# 20514304921 hay 4 repetidas
# 20510146345 hay 2 repetidas
# 20606023074 hay 2 repetidas
# 20600113519 hay 2 repetidas
# 20548480214 hay 2 repetidas





#-----------------------------------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------------#
# PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO # 
#-----------------------------------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# en la data original encontramos esto                                                                            #
# solo existe un registro 146269, sin embargo el merge para localidades con all.x=true lo duplica por             #
# alguna razÃÂ³n                                                                                                    #
# solo existen dos registros para 146270 pero ocurre el mismo problema que para 146269                            #
# para 378923 si son 3 los registros  
# en localidadesdimexa habia dos repetidos de huancavelicaacobambaacobamba ese tal vez duplicaba para los dos el registro
# osea en los archivos para cruzar no puede haber dos iguales en la llave                                         #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------------#
# PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO PROBLEMA QUE HABIA OCURRIDO # 
#-----------------------------------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------------#

# a<-as.data.frame(c("luis","pedro","pier","natalia","luisce", "evi", "pamela"))
# b<-as.data.frame(c("luis","pedro","pier","natalia","luisce", "evi", "pierito"))
# names(a)<-"a"
# names(b)<-"b"
# 
# lol<-a[!a$a %in% b$b,]
# nrow<-which(a$a==lol, arr.ind=TRUE)
# a[nrow,1]







