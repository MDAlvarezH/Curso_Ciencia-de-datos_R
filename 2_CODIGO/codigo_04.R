###
### Sesión 04 - Unir bases de datos + Reordenar bases de datos

### Paquetes ----
# install.packages("pacman") # En caso de que no lo tengan instalado aún
library(pacman)
p_load(readxl, tidyverse)

### Definir lenguaje del locale ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") 

### Bases de datos ----

# Gastos de precampaña
url <- "http://segasi.com.mx/clases/cide/vis_man/datos/Gastos_por_Rubro_Precampana_FEDERAL_2018_02_28.xlsx"
destfile <- "Gastos_por_Rubro_Precampana_FEDERAL_2018_02_28.xlsx"
curl::curl_download(url, destfile)
gastos <- read_excel(destfile)

getwd()

# CEMABE - Usando URLs

centros <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/cemabe_cdmx.csv", col_types = cols(ID_INM = col_character()), 
                    locale = locale(asciify = TRUE))

inmuebles <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/TR_inmuebles_09.csv", col_types = cols(ID_INM = col_character()), 
                      locale = locale(asciify = TRUE))

# ExECUM - Usando URLs
doc_tot <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/docentes_total.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))

sfo <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/subsidio_federal_ordinario.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))

mat_tot <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/mat_tot.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))


### dplyr - Unión de bases de datos ----

# Unión con datos dummy ----

x <- data_frame(llave = c(1, 2, 3),
                valor = c("x1", "x2", "x3"))

y <- data_frame(llave = c(1, 2, 4),
                valor = c("y1", "y2", "y3"))


## Unión interna

# nombre_bd_1 %>% 
#   inner_join(nombre_bd_2, 
#              by = "nom_llave")

# Con datos dummy
x %>% 
  inner_join(y, by = "llave")


### Unión externa IZQUIERDA
# nombre_bd_1 %>% 
#   left_join(nombre_bd_2, 
#              by = "nom_llave")

# Con datos dummy
x %>% 
  left_join(y, by = "llave")

# Con datos de CEMABE
union_izq <- inmuebles %>% 
  left_join(centros, by = "ID_INM")

### Unión externa DERECHA
# nombre_bd_1 %>% 
#   right_join(nombre_bd_2, 
#              by = "nom_llave")

# Con datos dummy
x %>% 
  right_join(y, by = "llave")

# Con datos de CEMABE
union_der <- inmuebles %>% 
  right_join(centros, by = "ID_INM")

### Unión externa TOTAL
# nombre_bd_1 %>% 
#  full_join(nombre_bd_2, 
#              by = "nom_llave")

# Con datos dummy
x %>% 
  full_join(y, by = "llave")


# Ahora con datos del CEMABE ----

## Analizar características de la variable usada como llave 

# Verificación de llave para inmuebles (para centros es lo mismo)

# Opción 1
inmuebles %>%          
  count(ID_INM) %>%
  arrange(-n)

# Opción 2
inmuebles %>%          
  count(ID_INM) %>%
  filter(n > 1)

# Opción 3
inmuebles %>%          
  count(ID_INM) %>%
  ggplot() +           
  geom_histogram(aes(n))

### Unión externa IZQUIERDA
union_izq <- inmuebles %>% 
  left_join(centros, by = "ID_INM")

dim(union_izq)

### Unión externa DERECHA
union_der <- inmuebles %>% 
  left_join(centros, by = "ID_INM")

dim(union_der)


### Unión externa TOTAL
union_tot <- inmuebles %>% 
  full_join(centros, by = "ID_INM")

dim(union_tot)


### tidyr - Reordenamiento de bases de datos ----

# Data frames ----
# Tomados de http://garrettgman.github.io/tidying/ 

table1 <- data_frame(country = c("Afghanistan", "Afghanistan", "Brazil", 
                                  "Brazil", "China", "China"),
                      year = rep(c(1999, 2000), 3), 
                      cases = c(745, 2666, 37737, 80488, 212258, 213766), 
                      population = c(19987071, 20595360, 172006362, 174504898,
                                     1272915272, 1280428583))

table2 <- data_frame(country = c(rep("Afghanistan", 4), 
                                  rep("Brazil", 4), 
                                  rep("China", 4)),
                     year = rep(c(1999, 1999, 2000, 2000), 3),
                     type = rep(c("cases", "population"), 6),
                     count = c(745, 19987071, 2666, 20595360, 37737, 
                                172006362, 80488, 174504898, 212258, 
                                1272915272, 213766, 1280428583))

table3 <- data_frame(country = c("Afghanistan", "Afghanistan", "Brazil", 
                                  "Brazil", "China", "China"),
                      year = rep(c(1999, 2000), 3), 
                      rate = c("745/19987071", "2666/20595360", "37737/172006362",
                               "80488/174504898", "212258/1272915272", "213766/1280428583"))

table4a <- data_frame(country = c("Afghanistan", "Brazil", "China"),  
                      `1999` = c(745, 37737, 212258),
                      `2000` = c(2666, 80488, 213766))


table4b <- data_frame(country = c("Afghanistan", "Brazil", "China"),  
                      `1999` = c(19987071, 172006362, 1272915272),
                      `2000` = c(20595360, 174504898, 1280428583))


# gather(): reunir varias columnas en una sola----

# nombre_data_frame %>% 
#   gather(nombre_col_1, 
#          nombre_col_2,
#          
#          ...
#          
#          nombre_col_n,
#          key = ["nombre de la variable que contendrá los valores de arriba"], 
#          value = ["nombre de la variable que contendrá los valores de la variable"])

# Datos dummy

table4a %>% 
  gather(`1999`,            # nombre de la columna 1
         `2000`,            # nombre de la columna 2 
         key = "year",      # nombre de la variable que contendrá los valores de arriba
         value = "cases")   # nombre de la variable que contendrá los valores de la variable



# Paso 1: Importar datos de personal docente total
doc_tot <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/docentes_total.csv", 
                    skip = 2,              # No incluir los primerois dos renglones
                    col_types =  cols(
                      '...1' = col_skip(),     # No incluir esta columna
                      Abs. = col_skip(),   # No incluir esta columna
                      `%` = col_skip() )   # No incluir esta columna
)

# Paso 2: Limpiar un poco los datos
doc_tot <- doc_tot %>% 
  rename(inst = '...2') %>% # Renombar la primera columna
  filter(inst != "Total Nacional *") # Eliminar el renglón que reporta tot. nal.

# Paso 3: tidyear, opción 1
doc_tot %>% 
  gather(`2007`, 
         `2008`, 
         `2009`, 
         `2010`, 
         `2011`, 
         `2012`, 
         `2013`, 
         `2014`, 
         `2015`, 
         key = "yr", 
         value = "doc_tot")

# Paso 3: tidyear, opción 2
doc_tot %>% 
  gather(colnames(doc_tot)[-1], # Crear y limpiar vector dentro de gather()  
         key = "yr", 
         value = "doc_tot")

# Paso 3: tidyear, opción 3
doc_tot %>% 
  gather(key = "yr", 
         value = "doc_tot",
         -inst) 


# spread(): separar variables que están en varios renglones a varias columnas ----

# nombre_data_frame %>%
#   spread(key = ["nombre de la variable que incluirá el nombre de las variables"],
#          value = ["nombre de la variable que contendrá los valores de cada columna"])

table2 %>% 
  spread(key = type, 
         value = count)

# separate(): separar en dos columnas dos valores que están en una misma celda ----

# nombre_data_frame %>%
#   separate(["nombre de la variable a separar"],
#          value = ["nombre de la variable que contendrá los valores de cada columna"])

table3 %>% 
  separate(rate, 
           into = c("cases", "population"),
           sep = "/")


### dplyr + tidyr <3 ----

# Importar nuevamente datos ----
doc_tot <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/docentes_total.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))

sfo <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/subsidio_federal_ordinario.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))

mat_tot <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/mat_tot.csv", skip = 2, col_types =  cols('...1' = col_skip(), Abs. = col_skip(), `%` = col_skip()))

# Limpiar dataframes ----

# Docentes
doc_tot <- doc_tot %>%
  rename(inst = '...2') %>% # Renombar la primera columna
  filter(inst != "Total Nacional *") # Eliminar el renglón que reporta tot. nal.

doc_tot

# Subsidio federal ordinario
sfo <- sfo %>%
  rename(inst = '...2') %>% # Renombar la primera columna
  filter(inst != "Total Nacional *") # Eliminar el renglón que reporta tot. nal.

sfo

# Matrícula total
mat_tot <- mat_tot %>%
  rename(inst = '...2') %>% # Renombar la primera columna
  filter(inst != "Total Nacional *") # Eliminar el renglón que reporta tot. nal.

mat_tot


# Tidyar bases de datos ----

# Docentes
doc_tot <- doc_tot %>%
  gather(colnames(doc_tot)[-1],
         key = "yr",
         value = "doc_tot")

doc_tot

# Subsidio federal ordinario
sfo <- sfo %>%
  gather(colnames(sfo)[-1],
         key = "yr",
         value = "sfo")

sfo

# Matrícula total
mat_tot <- mat_tot %>%
  gather(colnames(mat_tot)[-1],
         key = "yr",
         value = "mat_tot")

mat_tot


# Unión de bases de datos ----

# Primero, unión de mat_tot y sfo para generar iesp
iesp <- mat_tot %>%
  left_join(sfo, by = c("inst", "yr"))

iesp

# Segundo, unión de iesp y doc_tot, reemplazando iesp
iesp <- iesp %>%
  left_join(doc_tot, by = c("inst", "yr"))

iesp

# Se los dije: dplyr + tidyr = <3

