# paquetes utilizados
library(RODBC)
library(dplyr)
library(lubridate)
library(writexl)
library(readxl)
# conexion al sql
sqlcomercial<-odbcConnect("SQLansier",uid = "lv",pwd = "lv.2014c") 
# trayendo la data de los dos ultimos años de lansier
lansier<-sqlQuery(sqlcomercial,"[dbo].[STARSOFT_LISTA_VENTAS]")
# str(lansier)
# summary(lansier)
# unique(lansier$Periodo)
# unique(lansier$TipoCl)
# unique(lansier$artdes)
# unique(lansier$clienom)
# unique(lansier$DscZona)
# unique(lansier$dscven)
# unique(lansier$ColorEqui)
# unique(lansier$Fecha)
# nos quedamos solo con el periodo actual
lansier<-lansier %>% filter(Periodo==max(lansier$Periodo))
# para cerrar el periodo del mes anterior hacer el siguiente código, escogemos el [2], porque ese será el periodo anterior al actual
# lansier<-lansier %>% filter(Periodo== unique(lansier$Periodo)[2])

# quitamos espacios delante y detras al artdes
lansier$artdes<-trimws(lansier$artdes,which = "both")
# quitamos los dobles espacios que hay entre palabras
lansier$artdes<-gsub("\\s+"," ",lansier$artdes)
# quitamos los simbolos feos producidos por las tildes y las convertimos a tildes nuevamente
lansier$artdes<-iconv(lansier$artdes,from = "UTF-8",to = "latin1")
lansier$clienom<-iconv(lansier$clienom,from = "UTF-8",to = "latin1")
lansier$dscven<-iconv(lansier$dscven,from = "UTF-8",to = "latin1")

# cambiamos el formato de la fecha para que no aparezcan las horas
lansier$Fecha<-paste0(ifelse(day(lansier$Fecha)<10,paste0(0,day(lansier$Fecha)),day(lansier$Fecha)),
                   "/",
                   ifelse(month(lansier$Fecha)<10,paste0(0,month(lansier$Fecha)),month(lansier$Fecha))  ,
                   "/",
                   year(lansier$Fecha))

#----------------- PAUL VENTAS CARPETA COMPARTIDA ----------------#
# eliminamos del tipocl aquellas que son vacías
paulventas<-lansier %>% filter(TipoCl!=" ")


write_xlsx(paulventas,"paulventas.xlsx")

#------------------------ DASHBOARD-LANSIER ----------------------#
# para el dashboard solo nos interesa el canal privado
lansier<-lansier %>% filter(TipoCl=="DISTRIBUIDORES")

# eliminar productos covid "NOXAL 6 MG/ML X 10ML SOLUCIÃ“N ORAL GOTAS"
lansier<-lansier %>% filter(artdes!="NOXAL 6 MG/ML X 10ML SOLUCIÓN ORAL GOTAS")

# cruzando data
lansier<-lansier %>% mutate(FUENTE="LANSIER")

# CREANDO PERIODO PARA ESTE MES
lansier<-lansier %>% mutate(periodo=paste0("01/",
                                     ifelse(month(today())<10,paste0("0",month(today())),month(today())),
                                     "/",
                                     year(today())))
# CREANDO PERIODO PARA MES ANTERIOR
# lansier<-lansier %>% mutate(periodo=paste0("01/",
#                                            ifelse(month(today())<10,paste0("0",month(today())-1),month(today())-1),
#                                            "/",
#                                            year(today())))


# insertando columna ELIMINAR en vacio
lansier<-lansier %>% mutate(ELIMINAR="")

# creando columna DSCZONA 
lansier<-lansier %>% mutate(DSCVEND="")

# creando ppuni ppsol flag dpto dist prov que estaran vacias
lansier<-lansier %>% mutate(ppuni="") %>% mutate(ppsol="") %>% mutate(flag="")


lansier<-lansier %>%
  select(FUENTE,periodo,IdFactura,Fecha,codclie,ELIMINAR,
         clienom,tipoCondi,artdes,
         Cant,SubTotal,DscZona,dscven,ppuni,ppsol,flag)
# identificando donde marcar con E en ELIMINAR
castillo<-which(lansier$clienom== "REPRESENTACIONES CASTILLO S. A.", arr.ind=TRUE)
mym<-which(lansier$clienom== "M & M  PROD. MED. Y FARMACEUTICOS  E.I.R.L", arr.ind=TRUE)
difarlib<-which(lansier$clienom== "DISTRIB. FARMACEUTICA LA LIBERTAD S.R.L.", arr.ind=TRUE)
# marcando con E
lansier$ELIMINAR[castillo]="E"
lansier$ELIMINAR[mym]="E"
lansier$ELIMINAR[difarlib]="E"

# LEYENDO DATA NECESARIA PARA VALIDAR
maestrolansier <- read_xlsx("maestrolansier.xlsx")
# selecciono solo lo que voy a querer de maestro lansier que para este caso seria DIMEXA artdesvalid tipo y equipo
df2<-maestrolansier %>% select(LANSIER,`artdsc VALID`,TIPO,equipo)
# cambio el nombre a df2 para que coincida el nombre de la columna articulo para poder hacer el merge
colnames(df2)<-c("artdes","artdesvalid","tipo","equipo")

# QUITO ESPACIOS DELANTE Y DETRAS DEL MAESTROLANSIER
df2$artdes<-trimws(df2$artdes,"b")
df2$artdesvalid<-trimws(df2$artdesvalid,"b")

# antes de cruzar debemos validar que esten los mismo productos y cuales no reconoce
productosnuevoslansier<-lansier[!lansier$artdes %in% df2$artdes,]
write_xlsx(productosnuevoslansier,"productosnuevoslansier.xlsx")

# son productos de lansier
# EN UN INICIO data_maestro daba un numero diferente de filas a lansier y esto era porque en el maestrolansier habian nombres que se repetian
# no pueden repetirse nombre o al cruzar duplicará esas observaciones
data_maestro<-merge(x = lansier, y = df2, by.x = "artdes", all.x = TRUE)

# ahora cruzando con vendedores
vendedoresdimexa<-read_xlsx("vendedoresdimexa.xlsx")
vendedoresdimexa<-vendedoresdimexa %>% select(ruc,flag)
colnames(vendedoresdimexa)<-c("codclie","DSCVEND")
# quitando los espacios en blanco delante y detras
data_maestro$codclie<-trimws(data_maestro$codclie,"b")
vendedoresdimexa$codclie<-trimws(vendedoresdimexa$codclie,"b")

# combinando y validando con la data de vendedoresdimexa para traer el dscvend o flag como esta en vendedoresdimexa
data_maestro_vendedores<-merge(data_maestro,vendedoresdimexa,by.x = "codclie",all.x = TRUE)

# dandole orden a nuestro excel
data_maestro_vendedores<-data_maestro_vendedores %>%
  select(FUENTE,periodo,IdFactura,Fecha,codclie,ELIMINAR,
         clienom,tipoCondi,artdes,artdesvalid,
         Cant,SubTotal,DSCVEND,DscZona,dscven,tipo,equipo,ppuni,ppsol,flag)

# eliminamos las filas que tienen subtotal igual a cero
zerosubtotal<-which(data_maestro_vendedores$SubTotal== 0, arr.ind=TRUE)
data_maestro_vendedores<-data_maestro_vendedores[-zerosubtotal,]

write_xlsx(data_maestro_vendedores,"lansierdashboard.xlsx")
# limpiando nuestra ventana
rm(list=ls())

