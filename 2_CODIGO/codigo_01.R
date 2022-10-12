###
### Notebook 1 - ¿Qué puede hacer R por nosotros? + Tipos de datos
###

####### ...... Introduccion al lenguaje de R ......


#### TIPO DE DATOS: numericos, caracteres, logicos, categoricos, fechas ####
numerico <- 3.1415
numerico
a <- "curso de R"
colores<-c("rojo","verde","amarillo","azul","rojo","amarillo","verde") #vector con caracteres
b <- 5 < 3
#
Sys.Date()
Sys.time()

class(colores)

colores<-as.factor(colores)
class(colores)

# NOTA:
### The following are all basic vector classes.
### They can appear as class names in method signatures,
### in calls to as(), is(), and new().
"character"
"complex"
"double"
"expression"
"integer"
"list"
"logical"
"numeric"
"single"
"raw"


#Buscar ayuda para typeof y mode, ¿que hace cada uno?
?typeof
?mode
typeof(numerico) 
mode(numerico)

is.numeric(numerico)
is.character(a)
is.logical(b)

#OPERADORES MATEMATICOS Y LOGICOS
# Operaciones aritmeticas

suma <- 2+6
diferencia<- 6-2 
producto <- 3*4
division <- 25/5
potencia <- 2^5

#Operadores logicos
t <- 15
v <- 4

#Devuelven un TRUE o FALSE
t > 5   #mayor que
v >= 3  #mayor o igual que 
t < v   #menor que 
t <= 10 #menor o igual que
t == 5  #igual a 
v != t  #distinto de 


#ORDEN DE PRECEDENCIA DE LOS OPERADORES
#Las operaciones se llevan a cabo de manera automatica de acuerdo al orden de precedencia
#La suma y resta tienen menor precedencia que el producto y division y estos tienen uno menor 
# a la exponenciacion

3^2*4-5 
9*4-5 #equivalente a la primera expresion
9*(-1) # diferente a la primera expresion

5+3*6  #Primero realiza la multiplicacion y al resultado le agrega cinco
(5+3)*6 #Realiza lo que esta dentro del parentesis y luego la multiplicacion

#Realiza las siguientes operaciones. Nota como el parentesis cambia el orden de precedencia
5+36/6
(5+36)/6

2+225^(1/2)*4
(2+225^(1/2))*4

6*5^2/2
6*(5^2/2)

#Funciones (built in)

pi
2i+3i
sqrt(225)
abs(-6)
exp(4)
log(2)
sin(4+pi)
tan(5*pi)

r <- 3
sin(r)
cos(r)
log(r)
factorial(r)


# LISTAS y ARREGLOS (VECTORES Y MATRICES)

#Listas 
lista1<-list(col1 ="rojo", col2= "verde", col3= "amarillo", col4="azul")

lista2<-list("rojo","verde","amarillo","azul")
#Llamar un elemento 
lista1[c(1,3,4)]
lista1[2:4]# por numero de entrada
lista1$col2 # por nombre del elemento

#Arreglos
#array(data = NA, dim = length(data), dimnames = NULL)

arreglo_prueba<- array(seq(1,20,2), c(2, 5))
print(arreglo_prueba)

arreglo_prueba[1,2]

arreglo1<- array(rep("amarillo", 10), c(2, 5)) # c(5,2) indica que el arreglo es de 2 filas x 5 columnas

arreglo_prueba
arreglo1

#Matrices
#Son arreglos bidimensionales 
#matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE, dimnames = NULL)

arreglo2<-matrix(1:10, 2) # indica que la matriz tendra 2 filas 
print(arreglo2)

identical(arreglo1,arreglo2 )


#Algunas operaciones
t <- c(11,23,15,45,78,34,12,3,2)
A <- matrix(t, nrow=3, byrow=3) #ncol
A
A[3,1] #Regresa a los elementos de la fila tres. [3,] significa fila 3 y el espacio en blanco indica "todas las columnas"
A[2,2] #Elemento en fila dos, columna dos

z <- c(sum(A[,2]), prod(A[,2]))

23+78+3
23*78*3

z #Devuelve un vector donde la primera entrada es la suma de los elementos de la segunda columna de A
# y la segunda entrada es el producto de los elementos de la segunda columna
t(A) #matriz transpuesta
solve(A) #inversa de A
A %*% solve(A) #verificando que el producto de ambas matrices resulte en la matriz identidad


#Vectores

vector<-c(1,5,7,9,13)
vector
vector[4] # obtiene elemento 4 
vector[1:4] #obtiene del primer al cuarto elemento

#Se puede convertir una lista de numeros en un vector asignando dimension con la instruccion dim
vector1<-1:36
dim(vector1)<-c(6,6)
vector1


# Acciones con vectores

# Unir por columna cbind())
a<-c(1,2,3)
b<-c(4,5,6)
c<-c(7,8,9)
a
b
c
cbind(a,b,c)

# Unir por filas rbind()
z3<-rbind(a,b,c)
z3

#Agregar elementos a un vector
append(1:5, 0:1, after = 3) #En el vector 1:5, agrega los elementos 0 y 1 despues del elemento "3" del primer vector
append(a,b,after=1)

#Algunas operaciones
y <- c(10, 7, 2.4, 9, 23)

length(y) #longitud
max(y)
min(y)
sum(y)
median(y) #mediana
var(y)    #varianza
sd(y)     #desviacion estandar
sort(y)  #ordena por default de menor a mayor
sort(y, decreasing = TRUE) # ordena de mayor a menor;
# puede utilizarse decreasing=T o decreasing=TRUE; aplica para FALSE

w <- c(1,1,1,1,1,1,1,5,5,5,5,6,6,6,6,7,7,8,9,5,4,3,5,6,7,9,4,2,1)
as.factor(w)
unique(w) #Despliega una lista de elementos unicos cuando hay elementos repetidos
length(unique(w)) # Devuelve la longitud del vector de elementos unicos



#Otras instrucciones

print(A)
#Resolver sistema de ecuaciones Ax=b
b <- c(2,5,8)
solve(A,b)

# Sistema que resuelve
# 11x+23y+15z=2
# 45x+78y+34z=5
# 12x+3y+2z=8


# Sucesiones numericas 
# seq(from=valor inicial,to=valor final,by=amplitud)
?seq
e <- seq(2,20,0.5) #secuencia del dos al veinte en intervalos de 0.5
e
#Extraer quinto elemento
e[5]

#Extraer del quinto al octavo elemento
e[c(5:8,3:7)]


#Repetir un numero o vector (objeto)
i=c(1,0,0)

rep(i,4)

rep(3:7,4)


##### Funciones apply, sapply, lapply,tapply  ####

## APPLY
#Escribimos datos en forma matricial;
#Se tiene los datos de puntuaciones en una competencia de gimnasia.

datos <- c(7,7.5,7.8,4.6,6.8,7,9.8,8.7,10)

puntuacion <- matrix(datos, nrow=3, byrow=T)

puntuacion

#Etiquetamos los casos y las columnas
participante<-c("A", "B", "C")

competencia<-c("Comp_1", "Comp_2", "Comp_3")

dimnames(puntuacion) <- list(participante, competencia)

puntuacion


#Promedios por participante (fila=1)
apply(puntuacion, 1, mean)

#Promedios  por competencia (columna=2)
apply(puntuacion, 2, mean)

#Total de puntos por participante (fila)
apply(puntuacion, 1, sum)

#Total de puntos por competencia (columna)
apply(puntuacion, 2, sum)

#Aplicar el operador raiz cuadrada con la opcion 1. Lo que hace es calcular la raiz cuadrada
# de la matriz puntuacion poniendo las raices de los participantes (A, B y C) en forma de
#columnas
apply(puntuacion, 1, sqrt)


#Aplicar el operador raiz cuadrada con la opcion 2. Lo que hace es calcular la raiz cuadrada
# de la matriz puntuacion poniendo las raices de los casos (A, B y C) en forma de
#filas,es decir, tal y como viene la matriz

apply(puntuacion, 2, sqrt)


# Obtiene una muestra sin remplazo de cada renglon y las pone en forma de columnas ( 
# reordenan los valores de cada fila de forma aleatoria y los pone como columna)
apply(puntuacion, 1, sample)

?sample

#Aqui se obtiene la muestra de cada columna y se obtiene en forma de columnas
apply(puntuacion, 2, sample)


######

#Pueden usarse varias funciones
apply(puntuacion, 1, min)
apply(puntuacion, 1, max)
apply(puntuacion, 1, mean)
apply(puntuacion, 1,median)

#Ahora...
#SAPPLY, LAPPLY

sapply(1:5, function(x) x^2) #Aplica la funcion y regresa un vector 

sapply(1:5, function(x) x^2, simplify=FALSE) #Con el nuevo parametro regresa una lista 

lapply(1:3, function(x) x^2) #Aplica la funcion y regresa una lista

unlist(lapply(1:3, function(x) x^2)) #Con la nueva instruccion regresa un vector 


#TAPPLY,MAPPLY,VAPPLY 

x <- 1:20 #genera numeros del uno al veinte
y <- factor(rep(letters[1:5], each = 4)) # repite las primeras cinco letras cuatro veces cada una y declara como dato categorico
x
y

tapply(x, y, sum) # Realiza la suma de los elementos de x de acuerdo a y 
#De esta manera, suma los primeros cuatro elementos de x que corresponden a "a" en el vector y
#Suma 1+2+3+4 y lo asigna a "a"; suma 5+6+7+8 y lo asigna a "b"...

mapply(sum, 1:5, 1:5, 1:5) #suma los primeros elementos, luego los segundos elementos, luego los terceros...

mapply(rep, 1:4, 2) #repite los elementos del primer vector el numero de veces que lo indique el segundo vector


x <- list(A = 1, B = 1:3, C = 1:7)

x

vapply(x, FUN = length, FUN.VALUE = 0L) #devuelve la longitud de las listas introducidas como primer parametro


##Estas instrucciones son muy parecidas asi que se recomienda usar la instruccion que regrese el tipo de dato 
# que reduzca el uso de memoria y se adapte mejor al tipo de datos que se tienen y se quieren.



#### ESTRUCTURAS DE CONTROL CONDICIONANTE Y CICLOS ####

## IF; dos formas de instruccion
# ifelse(test, yes, no)
# if(cond) cons.expr  else  alt.exp

z <- 3 

ifelse(z < 4, TRUE, FALSE) 

if (z<4) 
  TRUE else
    FALSE


##FOR
vector <- seq(1, 100 ,2)
vector
length(vector)

vector2 <- NULL

length(vector2)


for (i in 1:length(vector)) #es un ciclo que va desde i=1 hasta la longitud de "vector" (50)
{
  vector2[i] = vector[i]^2 #Asigna a la entrada i(que va de 1 a 50) de "vector2" 
}                          # el cuadrado de la entrada i de "vector"
# asigna 1^2 a la entrada 1 ,3^2 a la entrada 2, y asi sucesivamente
vector2


## Condicion de "stop"
n <- c(1:10) #vector con entradas del uno al cinco 
r <- NULL #vector nulo

for (i in n) # Es un ciclo que va desde uno hasta diez
{
  if (n[i] < 6)  #Si la entrada i del vector n es menor a seis cumple con la condicion de abajo
  {r <- c(r, n[i])  #concatena en r el valor de r y la entrada i-esima de n
  }
  else #Si no es menor que seis pasa al stop
  {
    stop ("Los valores deben ser < 6") #Muestra mensaje
  }
}
r


## While #mientras se cumpla la condicion el ciclo se llevara a cabo
x <- 0

while (x < 10)  #mientras x sea menor a diez 
{
  x <- (x+1)^2    #asigna a x el cuadrado del valor de x mas uno
  print(x)     # imprime el nuevo valor de x 
}


##Condicion de "break"

x <- 6

while (x < 10)
{
  x <- x + 2
  print (x)
  if (x == 6)
  {
    break     #Obliga a la salida del ciclo
  }
}



## IMPLEMENTACION DE FUNCIONES 

funcion1 <- function(x, y) {  #Realiza las operaciones 'si'; x,y son los parametros de la funcion
  s1 <- 2*x*y
  s2 <- x^(2*y)
  s3 <- 21*x +y
  s4 <- x/y
  return(c(s1, s2, s3, s4))
}


funcion1(2,3) #Haciendo uso de la funcion; nombredelafuncion(parametros)


funcion2 <- function(x) {   #Regresa la mantisa (parte decimal)
  sign(x) * (x - floor(x)) } 


funcion2(8.79)




### Paquetes  ----

#remove.packages()    # Desintalar paquetes
#detach("", unload = TRUE) # Remover paquete del espacio de trabajo
#installed.packages() # Enlistar paquetes instalados
#old.packages()       # Enlistar paquetes que requieren actualización
#update.packages()    # Actualizar TODOS los paquetes ya instalados
#install.packages()   # Actualizar solo UN paquete
#install.packages("pacman") # Solo hace falta instalarlo una vez

library(pacman)

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

View(bd_iesp)


### Calcular ----

View(mtcars)

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
tibble(col_1 = c(1, 3, 4), col_2 = c(2, 8, 10)) # Data frame con datos numéricos

tibble(col_1 = c(1, 3, 4), col_2 = c("lentes", "botella", "tarjeta")) # Data frame con datos numéricos y de texto




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