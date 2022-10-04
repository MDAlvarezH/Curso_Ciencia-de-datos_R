###
### Notebook 1 - ¿Qué puede hacer R por nosotros? + Tipos de datos
###


### Paquetes  ----
#install.packages("pacman") # Solo hace falta instalarlo una vez
#library(pacman)

# Esto:
p_load(ineq, haven, readr, readxl, ggplot2, tidyverse)

# es equivalente a esto:
p_load(ggplot2, # Gran paquete para hacer gráficas 
       haven,  # Cargar bd en formatos .dta, .sav, entre otros
       ineq,    # Útil para cálculo de índice de Gini
       readr,   # Cargar archivos de texto plano, principalmente .csv
       readxl,  # Cargar archivos de .xls y .xlsx
       tidyverse) # Carga de forma simultánea readr, ggplot2, dplyr, tidyr, purrr y tibble


### Setup ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") # Cambiar locale para prevenir problemas con caracteres especiales
options(scipen=999) # Prevenir notación científica


### Base de datos ----
bd_iesp <- read.csv(url("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv"))

bd_iesp_1 <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv",
                      locale = locale(asciify = TRUE))


### Calcular ----
2 + 2 
4 * (6/3)
74/3 + (10)^3
summary(mtcars) # Resumen estadístico de toda las variables en la base de datos
mean(mtcars$mpg) # Promedio de una variable
median(mtcars$mpg) # Mediana
sd(mtcars$mpg) # Desviación estándard
min(mtcars$mpg) # Mínimo
max(mtcars$mpg) # Máximo
IQR(mtcars$mpg) # Rango intercuarntil
ineq(mtcars$wt, type="Gini") # Cálculo del índice de Gini - requiere que ineq esté cargado
lm(mpg ~ wt, data = mtcars)  # Modelo de regresión lineal


### Generar bases de datos----

# Vectores
c(11, 43, 7, 23.45) # Númerico o numeric
c("manzana", "pera", "carnitas", "crema") # Texto o character

# Matrices 
matrix(c(1, 3, 4, 2, 8, 10), nrow = 2)  # Matriz de datos numéricos
matrix(c("vaso", "llaves", "anillo", "lentes", "botella", "tarjeta"), ncol = 2) # Matriz de datos tipo texto o character

# Data frames
data_frame(col_1 = c(1, 3, 4), col_2 = c(2, 8, 10)) # Data frame con datos numéricos
data_frame(col_1 = c(1, 3, 4), col_2 = c("lentes", "botella", "tarjeta")) # Data frame con datos numéricos y de texto


### Visualizar datos ----

# Con R base
plot(diamonds$carat, diamonds$price,
     main = "Relación entre el número de carats de un diamante y su precio", 
     xlab = "Número de carats",
     ylab = "Precio")

# Con ggplot2 - requiere que ggplot2 esté cargado
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  coord_cartesian(ylim = c(0, 20000)) +
  labs(title = "Relación entre el número de carats de un diamante y su precio",
       x = "Número de carats",
       y = "Precio")

### Guardar "cosas" en la memoria temporal ----

# Resultados de operaciones
suma <- 7 + 4  

# Variables (o vectores)
x <- c(41, 5, 76)
chico_che <- c("Quen", "pon", "po")

# Matrices
soy_una_matriz <- matrix(c(1, 3, 4, 2, 8, 10), nrow = 2) 

# Data frames
soy_un_df <- data_frame(col_1 = c(1, 3, 4), col_2 = c(2, 8, 10)) 

# Gráficas generadas con ggpot2
g <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()

# Resultados de un modelo estadístico
modelo_1 <- lm(mpg ~ wt, data = mtcars)

# Bases de datos
bd_iesp <- read.csv(url("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv"))

### Paquetes ----
#install.packages("tidyverse") # Instalar paquete
#install.packages(c("ggplot", "dplyr")) # Instalar paquetes
library(tidyverse) # Cargar paquete

remove.packages()    # Desintalar paquetes
detach("", unload = TRUE) # Remover paquete del espacio de trabajo
installed.packages() # Enlistar paquetes instalados
old.packages()       # Enlistar paquetes que requieren actualización
#update.packages()    # Actualizar TODOS los paquetes ya instalados
#install.packages()   # Actualizar solo UN paquete


### Tipos de objeto ----


class()    # Consultar la clase de un objeto y/o tipo de dato
nlevels()  # Calcular el número de niveles en una variable de tipo factor
levels()  # Enlistar los niveles de una variable de tipo factor

# Código para averieguar si una variable es de tipo...
is.numeric() 
is.integer() 
is.character()
is.factor()

# Código para averieguar si una variable contiene una o más celdas con valores faltantes (NAs)
is.na()

# Código para cambiar el tipo de una variable
as.numeric() # Guardar variable como numeric
as.integer() # Guardar variable como integer
as.character() # Guardar variable como character
as.factor() # Guardar variable como factor




plot("")