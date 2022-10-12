###
### Notebook 2 - Estructuras de datos e importación de bases datos
###

### Paquetes  ----
#install.packages("pacman") # Solo hace falta instalarlo una vez
library(pacman)
p_load(datapasta, haven, readxl, tidyverse)

### Setup ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") # Cambiar locale para prevenir problemas con caracteres especiales
options(scipen=999) # Prevenir notación científica



###
### Bases de datos ----
###


# Datos de Instituciones de Educación Superior, versión importada con read.csv()
b.d <- read.csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv")

# Datos de Instituciones de Educación Superior, versión importada con read_csv()
b_d <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv")

# Datos de jugadores de Rusia 2018
mundial <- read_csv("http://segasi.com.mx/clases/cide/datos/wc2018_player_stats.csv")

# Resultados de la elección presidencial de 2018, por distrito
presidente <- read_csv("http://segasi.com.mx/clases/cide/datos/cp_2018_dtto.csv")




###
### Estructuras de bases de datos ----
###

## Vectores

# c() - Combinar datos numéricos o caracteres
c(4, 137, 68)
c("Quen", "Pon", "Po")

# seq() - Secuencia de valores numéricos
seq(8,      # Valor inicial 
    436,    # Valor (máximo) final
    16)     # Magnitud de los "brincos"

# rep() - Secuencia de valores numéricos repetidos
rep(8,     # Dato(s) a repetir
    30)    # Núm. de veces que se debe(n) repetir

# a:b - Secuencia consecutiva de valores numéricos
a:b   
print(1:100)

## Matrices

# cbind() - Combinar columnas
a <- c(34, 26, 89) # Soy un vector
b <- c(1, 22, 18) # Soy otro vector
matriz <-  cbind(a, b)

a <- c("bajo", "medio", "alto") 
b <- c("azul", "rojo", "blanco")
matriz <-  cbind(a, b)

# rbind() - Combinar renglones
a <- c(34, 26, 89) # Soy un vector
b <- c(1, 22, 18) # Soy otro vector
matriz <-  rbind(a, b)

# matrix() - Construir matrices
matriz <- matrix(c(34, 67, 89, 1, 45, 90, 10, 34), 
                   nrow = 2, # Número de renglones
                   ncol = 4) # Número de columnas


## Data frames

# data.frame() - Construir un data frame usando el paquete base 

# Ej. 1 - Defniendo primero los vectores y luego integrándolos al df
edad <- c(34, 26, 89) 
color <- c("azul", "rojo", "blanco")
d.f <-  data.frame(edad, color)

# Ej. 2 - Defniendo los vectores dentro del data frame
d.f <-  data.frame(edad = c(34, 26, 89), 
                  color = c("azul", "rojo", "blanco"))

# data_frame() - Construir un data frame usando el paquete base tibble

d_f <-  data_frame(edad = c(34, 26, 89), 
                   color = c("azul", "rojo", "blanco"))


###
# Funciones para analizar estructura de bd ----
###

head(x)    # Imprime los primeros renglones del objeto
tail(x)    # Imprime los últimos renglones del objeto
View(x)    # Abre el objeto entero en una nueva ventana
nrow()     # Número de renglones
ncol()     # Número de columnas
dim()      # Número de renglones y columnas
rownames() # Muestra los nombres de los renglones
colnames() # Muestra los nombres de las columnas
names()    # Muestra los nombres de las columnas
str()      # Muestra la estructura del data frame (dimensiones y tipos de cada variable)



colnames(d_f)
##





### Importar base de datos ----

# Funciones del paquete readr ----

# read_csv(): para archivos .csv

# Incluye diversos argumentos que se pueden especificar, incluyendo: 

# col_names: si es TRUE (el default), toma el primer renglón como los nombres de las columnas. También permite cambiar nombres a través de un vector: c("Columna_1", "Columna_2"...)
# col_types: permite especificar el tipo de cada columna
# skip: permite **no** importar los primeros *n* renglones
# n_max: permite limitar el número de renglones a importar

b_d <- read_csv("ruta/al/archivo/bd_iesp_07_10.csv")

# read_tsv(): para archivos con columnas separadas por sangrías (*t*ab *s*eparated *v*alues)

# read_delim(): función genérica, útil para cualquier archivo de texto plano, sin importar cómo estén separadas las columnas


# Funciones del paquete readxl ----

# excel_sheets(): permite explorar el número y nombre de las hojas en un archivo de Excel.

# read_excel(): importa el archivo.


# Funciones del paquete heaven ----

# read_sas(): importa archivos con formato .sas
# read_dta() y read_stata(): importa archivos con formato .dta
# read_spss(): importa archivos con formato .dta


## Archivos de texto plano ---- 

# Datos de jugadores del mundial
mundial <- read_csv("ruta/al/archivo/wc2018_player_stats.csv")

## Archivos de Excel ----

# Datos de aspirantes a una candidatura independiente, corte del 7 de diciembre de 2017
excel_sheets("ruta/al/archivo/Reporte-APP-7-12-MICROSITIO-2017-12-07.xls")
independientes <- read_excel("ruta/al/archivo/Reporte-APP-7-12-MICROSITIO-2017-12-07.xls")
independientes <- read_excel("ruta/al/archivo/Reporte-APP-7-12-MICROSITIO-2017-12-07.xls", 
                             ____ = "Presidencia")

