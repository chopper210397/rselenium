library(RSelenium)
library(rvest)
library(dplyr)
library(lubridate)
library(readxl)
library(lubridate)
library(writexl)
# Sys.sleep(10)
# # este pagina es la que nos brinda la parte de application/vnd.... , esto es necesario ponerlo para que el buscador de firefox no nos pregunte si queremos 
# # guardar o abrir el archivo, porque eso mata todo el codigo, mediante este codigo, especifico para documentos con terminaciÃ³n xls, podemos saltar el pop-up
# # y descargar directamente en la carpeta de descargas o downloads de la pÃ¡gina.
# # https://www.freeformatter.com/mime-types-list.html
# # a veces se tiene que cambiar el nombre del port cuand no conecta al servidor remoto
# driver <- rsDriver(browser = c("firefox"),port = 4440L, extraCapabilities = makeFirefoxProfile(list(
#   "browser.helperApps.neverAsk.saveToDisk"="application/vnd.ms-excel")
# ))
# Sys.sleep(20)
# remote_driver <- driver[["client"]]
# 
# # install.packages("Rtools") por seacaso
# 
# Sys.sleep(6)
# remote_driver$navigate("http://www.lansierweb.com:9300/FACTURACION/FacturacionMetronic.aspx?JER=divMenuLBTR_1_01.02")
# Sys.sleep(7)
# # con esto hacemos click en LABORATORIOS LANSIER S.A.C 
# # FORMA GENIAL DE SELECCIONAR MEDIANTE ID Y VALUE, NO SABIA HACERLA ANTES
# empresa<- remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
# empresa$clickElement()  
# 
# # CODIGOS QUE PUEDEN SER UTILES MAS ADELANTE
# 
# # empresa$highlightElement()
# # options<-empresa$selectTag()
# # options$text
# # options$value
# # options$selected
# # options$elements[[2]]$clickElement()
# # options$elements
# # rm(empresa)
# 
# # USUARIO
# username<-remote_driver$findElement(using = "id", value = "txtUsuario")
# username$sendKeysToElement(list("ABA"))
# 
# # PASSWORD
# psswd<-remote_driver$findElement(using = "id",value = "txtClave")
# psswd$sendKeysToElement(list("72722698","\uE007"))
# 
# # ahora que ya entre a la pagina solo falta hacer click en  descargar excel
# # DESCARGAR EXCEL
# # PARA SELECCIONAR EL EXCEL AL PARECER CUALQUIERA DE ESTOS COMANDOS ME ES VALIDO, MAS ADELANTE PROBAR DE NUEVO
# Sys.sleep(7)
# downloadexcel<-remote_driver$findElement(using = "id",value = "ctl00_ContentPlaceHolder1_ibtn_Excel")
# # downloadexcel<-remote_driver$findElement(using = "class",value = "Boton")
# # downloadexcel<-remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
# # downloadexcel<-remote_driver$findElement(using = "xpath",value = "//*[@id='ctl00_ContentPlaceHolder1_ibtn_Excel']")
# # downloadexcel<-remote_driver$findElement(using = "css",value = "html.js.canvas.canvastext.geolocation.crosswindowmessaging.no-websqldatabase.indexeddb.hashchange.historymanagement.draganddrop.websockets.rgba.hsla.multiplebgs.backgroundsize.borderimage.borderradius.boxshadow.opacity.cssanimations.csscolumns.cssgradients.no-cssreflections.csstransforms.csstransforms3d.csstransitions.video.audio.localstorage.sessionstorage.webworkers.no-applicationcache.svg.smil.svgclippaths.fontface body.sidebar-left.chart div#container form#aspnetForm div#page div#page-content.container_12 div#contenidoss div.grid_12 div div.box div.div_bloque input#ctl00_ContentPlaceHolder1_ibtn_Excel.Boton")
# # downloadexcel<-remote_driver$findElement(using = 'xpath', "//select[@id='ddlEmpresa']/option[@value='1']")
# # downloadexcel<-remote_driver$findElement(using = "name",value = "ctl00$ContentPlaceHolder1$ibtn_Excel")
# # downloadexcel<-remote_driver$findElement(using = "partial link text",value = "../App_Themes/COMERCIO/Images/botones/ico_excel.png")
# # downloadexcel<-remote_driver$findElement(using = 'xpath', "//*[@id='ctl00_ContentPlaceHolder1_ibtn_Excel']")
# # downloadexcel$getElementLocation()
# # downloadexcel<-remote_driver$mouseMoveToLocation()
# Sys.sleep(2)
# # CLICK DESCARGA EXCEL: ESTAMOS USANDO OTRO METODO DISTINTO AL CLICK ELEMENT ANTERIOR, AHORA ESTAMOS HACIENDO OTRO METODO, SITUANDO EL MOUSE EN LA COORDENADA Y DANDOLE CLICK
# remote_driver$mouseMoveToLocation(webElement = downloadexcel)
# remote_driver$click(buttonId = "RIGHT")

# CON ESTO HASTA AQUI YA DEBERIA ESTAR DESCARGADO EL EXCEL

############################################################################################
############################################################################################
############    TRABAJANDO LA DATA    ############    TRABAJANDO LA DATA    ################
############################################################################################
############################################################################################

# gracias a este paquete pude leer el excel, ya que de otra forma no podia
# install.packages("XLConnect")
# install.packages("lookup")
# install.packages("plyr")
# install.packages("qdapTools")
library(qdapTools)
library(plyr)
library(lookup)
library(XLConnect)
library(dplyr)
library(readxl)
library(writexl)
library(RODBC)


data <- readWorksheetFromFile(paste0("C:\\Users\\LBarrios\\Downloads\\FacMet_",
                                     year(today()),
                                     ifelse(month(today())<10,paste0("0",month(today())),month(today())) ,
                                     ifelse(day(today())<10,paste0("0",day(today())),day(today())),".xls"),
                              sheet = "FacturacionMetronic",
                              startRow = 6,
                              startCol = 1)



# retirando las columnas que eran merge de las otras
data<-data %>% select(-Col6,-Col12)

# seleccionando data para CIERRE DE MES ANTERIOR
# data<-data %>% filter(Periodo==paste0(year(today()),
#                                       ifelse(month(today())<10,paste0("0",month(today())-1),month(today()))))
# seleccionando data del periodo ACTUAL
data<-data %>% filter(Periodo==paste0(year(today()),
                                      ifelse(month(today())<10,paste0("0",month(today())),month(today()))))

# borrando los valores de articulo iguales a productos covid
data<-data %>% filter(!(Artículo %in%
                          c("VESOGVT001","VESOGVT002","VESOTR001","VESOTR002","VESOTR003","VESOTR004","VEDMLN001")))

# borrando de columna Vendedor = OFICINA
data<-data %>% filter(!(Vendedor %in% c("OFICINA")))

# creando columna fuente que diga METRONIC
data<-data %>% mutate(FUENTE="METRONIC")

# creando columna periodo con el primer dia del mes a actualizar
data<-data %>% mutate(periodo=paste0("01/",
                                     ifelse(month(today())<10,paste0("0",month(today())),month(today())),
                                     "/",year(today())))

# insertando columna ELIMINAR en vacio
data<-data %>% mutate(ELIMINAR="")

# creando columna DSCZONA 
data<-data %>% mutate(DSCZONA="")

# creando ppuni ppsol flag dpto dist prov que estaran vacias
data<-data %>% mutate(ppuni="") %>% mutate(ppsol="") %>% mutate(flag="") %>% mutate(dpto="") %>% mutate(dist="") %>% mutate(prov="")

# seleccionando solo las columnas que nos interesan
# DATA2 TIENE EL FORMATO QUE SE CARGARIA AL SQL
data2<-data %>%
  select(FUENTE,periodo,Nro.Doc,Fecha,Ruc,ELIMINAR,Cliente,Condición,Artículo,Cant,Subtotal,DSCZONA,Zona,Vendedor,ppuni,ppsol,flag,dpto,dist,prov)
# con esto leo el maestro lansier con el cual cruzare mi data
maestrolansier <- read_xlsx("maestrolansier.xlsx")
# aqui selecciono lo que voy a cruzar
# df1<-data2 %>% select(Articulo)
df2<-maestrolansier %>% select(METRONIC,`artdsc VALID`,TIPO,equipo)
# con esto quito los espacios adelante y detrÃ¡s del artdesvalid Y LOS ARTICULOS
# df1$ArtÃ­culo<-trimws(df1$ArtÃ­culo,"b")
# df2$ArtÃ­culo<-trimws(df2$ArtÃ­culo,"b")
# df2$artdesvalidvalid<-trimws(df2$artdesvalidvalid,"b")
# cambio el nombre a df2 para que coincida el nombre de la columna articulo para poder hacer el merge
colnames(df2)<-c("Artículo","artdesvalid","tipo","equipo")
# # probando el mismo proceso pero directamente para data 2 y ya no para df1
data2$Artículo<-trimws(data2$Artículo,"b")
data2$Artículo<-trimws(data2$Artículo,"b")
df2$artdesvalid<-trimws(df2$artdesvalid,"b")

# cruzando para obtener los validados, tipo y equipo
# probando si hay productos diferentes
productosnuevosmetronic<-data2[!data2$Artículo %in% df2$Artículo,]
write_xlsx(productosnuevosmetronic,"productosnuevosmetronic.xlsx")
#
ArtdesValid2<-merge(x = data2, y = df2, by.x = "Artículo", all.x = TRUE)

data3<-ArtdesValid2 %>%
  select(FUENTE,periodo,Nro.Doc,Fecha,Ruc,ELIMINAR,Cliente,Condición,Artículo,artdesvalid,Cant,Subtotal,DSCZONA,Zona,Vendedor,tipo,equipo,ppuni,ppsol,flag,dpto,dist,prov)

# creando el excel con la data ya formateada
# es fundamental utilizar la funcion write_xlsx ya que esta nos permite sobre escribir el excel sin tener que borrarlo previamente
write_xlsx(data3,"metronic.xlsx")
# LISTO TERMINADO
#------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------#
# ------------ con trimws puedo quitar los espacios iniciales y finales de un texto --------- #
#---------------------------------------------------------------------------------------------#
# x<- "  texto con espacios "
# trimws(x,"b")
# x<-c(" asds ", " asdasdas","sdasdas ","    asdasd  asd   asd    ","  asdsa  2  ")
# trimws(x,"b")
rm(list = ls())


# 
# data3<-data3 %>% mutate(categorización="")
# # conectando a ventalansier
# sqluis<-odbcConnect("SQLuis",uid = "sa",pwd = "Comercial.2020")
# # borrando el mes actual para que no se repita la data
# sqlQuery(sqluis,paste0("delete from Venta_Lansier where periodo='01/",
#                        ifelse(month(today())<10,paste0(0,month(today())),month(today())),
#                        "/",year(today()),"'","and fuente ='METRONIC'") )
# # agregando la data de METRONIC de este periodo al sql
# sqlSave(sqluis,data3,tablename = "Venta_Lansier",colnames = FALSE,rownames = FALSE,verbose = TRUE,append = TRUE,fast =TRUE, varTypes=columnTypes)
# 
# colnames(data3)<-c("fuente","periodo","idfactura","fecha","ruc","eliminar","clienom","tipocondi","artdes","artdesValid","cant","subtotal","dsczonadet","dsczona",
#                    "dscven","tipoart","colorequi","ppuni","ppsol","flag","dpto","distrito","provincia","categorización")
# 
# columnTypes <- list(fuente = "VARCHAR(50)", periodo = "date", idfactura = "VARCHAR(50)", fecha = "date", ruc = "varchar(11)",
#                     eliminar ="char(1)",clienom="varchar(150)",tipocondi="varchar(10)",artdes="varchar(150)",artdesValid="varchar(150)",cant="int",
#                     subtotal="float",dsczonadet="varchar(8)", dsczona="varchar(30)",dscven="varchar(60)", tipoart="varchar(5)",
#                     colorequi="varchar(15)",ppuni="int",ppsol="float",flag="char(1)",dpto="varchar(50)", distrito="varchar(50)",provincia="varchar(50)",
#                     categorización="varchar(20)")
# 
# sqlSave(myconn2, MainClmDF2, tablename = "##R_Claims_Data", verbose=TRUE, rownames= FALSE, varTypes=columnTypes)
# 
# 

#-----------------------------------------------------------------------------#
# ya esta automatizado todo para metronic desde la descarga hasta el formateo #
#-----------------------------------------------------------------------------#

# #--------------------
# # solucion 2
# ga<-merge(x=df1,y=df2,by = "ArtÃ­culo")
# rm(ga)
# # solucion 3
# ga<-inner_join(mutate(df1, k = 1), mutate(df2, k = 1), by = "k")
# 
# ga<-merge(x = df1, y = df2, all = TRUE)
# rm(ga)
# # solucion 4
# ga<-dplyr::left_join(df1, distinct(df2), by = "ArtÃ­culo")
# 
# # solucion 5
# 
# rm(df1)
# # using lookup
# df2<-maestrolansier %>% select(METRONIC,`artdsc VALID`)
# colnames(df2)<-c("ArtÃ­culo","artdesvalid")
# 
# df1$articulovalidado<-lookup(df1$ArtÃ­culo,df2$ArtÃ­culo,df2$artdesvalid)
# 
# 
# 
# 
# 
# 
# # practicando
# hous <- data.frame(HouseType=c("Semi","Single","Row","Single","Apartment","Apartment","Row"),
#                    HouseTypeNo=c(1,2,3,2,4,4,3))
# 
# largetable <- data.frame(HouseType = sample(unique(hous$HouseType), 1000, replace = TRUE))
# 
# largetable$num1 <- lookup(largetable$HouseType, hous$HouseType, hous$HouseTypeNo)
# 
# ##----------------------------------------------------
# firstLookup <- function(data, lookup, by, select = setdiff(colnames(lookup), by)) {
#   # Merges data to lookup using first row per unique combination in by.
#   unique.lookup <- lookup[!duplicated(lookup[, by]), ]
#   res <- merge(data, unique.lookup[, c(by, select)], by = by, all.x = T)
#   return (res)
# }
# 
# baseFirst <- firstLookup(df1, df2, by = "ArtÃ­culo")
# ##---------------------------------------------------------------------
# validado<-df2 %>%
#   distinct() %>%
#   right_join(df1, by = 'ArtÃ­culo')
# 
# left_join(df1,df2,by="ArtÃ­culo",keep=TRUE)
# 
# merge(df1,df2,by = "ArtÃ­culo")
# 
# plyr1<-join(df1,df2,by="ArtÃ­culo")
# 
# df1[, 1]%1% df2
# 
# match(df1$ArtÃ­culo,df2$ArtÃ­culo)
# 
# semi_join(df1,df2,by="ArtÃ­culo")
# tropi<-df1[1,1]
# df1 %>% filter(ArtÃ­culo==df1[,]) %>% left_join(df2)
# df2 %>% filter(ArtÃ­culo==tropi)
# # tal parece que el problema es que en algunos productos hay espacios al final o al inicio, por eso no reconoce
# 
# 
# avalidar<-gsub(" ","",df1$ArtÃ­culo)
# df2$ArtÃ­culo<-gsub(" ","",df2$ArtÃ­culo)
