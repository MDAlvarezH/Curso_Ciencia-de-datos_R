###
### Notebook 3 - Rebanar y manejar bases de datos
###

### Cargar paquetes mencionados en la láminas ----
library(pacman)
p_load(readr, readxl, dplyr, stringr)

### Definir lenguaje del locale ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") 


### Base de datos ----

# Gastos de precampaña
url <- "http://segasi.com.mx/clases/cide/vis_man/datos/Gastos_por_Rubro_Precampana_FEDERAL_2018_02_28.xlsx"
destfile <- "Gastos_por_Rubro_Precampana_FEDERAL_2018_02_28.xlsx"
curl::curl_download(url, destfile)
gastos <- read_excel(destfile)

View(gastos)

#tibble

# Datos de IESP
b.d <- read.csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv")

# Censo educativo
cemabe_df <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/cemabe_cdmx.csv", 
                      locale = locale(asciify = TRUE))
#write.csv(cemabe_df, "cemabe_cdmx.csv", row.names=FALSE, quote=FALSE) 



#PIB
pib_mex <- data.frame(yr = 1993:2017,
                      pib = c(8026886, 8433429, 7908654, 
                              8453960, 9033554, 9460382,
                              9737696, 10243612, 10156005, 
                              10185527, 10385857, 10832004,
                              11160493, 11718672, 12087602, 
                              12256863, 11680749, 12277659,
                              12774243, 13287534, 13468255, 
                              13773994, 14138965, 14462162,
                              14469247))

plot(pib_mex$pib ~ pib_mex$yr, 
     pch=16)



### Generar subconjuntos de estructuras de datos ----


##  Vectores
vector <- c(4, 89, 76, 95, 6, 54, 29, 10)

# Primera opción: usando íntegros positivos
vector[4]              # Subconjunto de un solo elemento
vector[c(4, 8, 2)]     # Subconjunto de tres elementos. OJO: posiciones no están en orden
vector[c(2:4)]         # Subconjunto de tres elementos


# Segunda opción: usando íntegros negativos
vector[-4]             # Subconjunto eliminando un solo elemento
vector[-c(4, 8, 2)]    # Subconjunto eliminando tres elementos. 
vector[-c(2:4)]        # Subconjunto eliminando tres elementos consecutivos

# Tercera opción: usando operadores lógicos
# Subconjunto generado con condición de falso/verdadero
vector[c(FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE)]  # Subconjunto generado con base en una condición matemática
vector[vector > 30]  


## Matrices -----

# matriz[index_1, index_2] donde:

# index_1  = renglón(es)
# index_2 = columna(s)
# index_1 e index_2  pueden especificar el número de renglón o columna, o su nombre

col_1 <- 1:3
col_2 <- seq(1, 20, 7)
col_3 <- c(76, 1, 23)
matriz <- cbind(col_1, col_2, col_3)
matriz



matriz[ , 1]       # Subconjunto con todos los elementos en la primer columna
matriz[, "col_1"] # Subconjunto con todos los elementos en la primer columna
matriz[1, 1]      # Subconjunto con elemento en primer renglón y primer columna
matriz[2:3, ]     # Subconjunto con los elementos de los últimos dos renglones
matriz[, 1:2]     # Subconjunto con los elementos de las primeras dos columnas
matriz[, -2]      # Subconjunto con todos los elementos excepto los de la segunda columna
matriz[-1, ]      # Subconjunto con todos los elementos excepto los del primer renglón


## Data frame ----

# Selección de columnas 

# Primera opción: df$nom_col, donde:
# df = nombre del data frame
# $ = operador para acceder a una columna
# nom_col = nombre de la columna que queremos accesar

xx <- b.d$m1 # Seleccionar la columna de matrícula total


# Segunda opción: df["nom_col"], donde:
# df = nombre del data frame
# nom_col = nombre de la columna que queremos accesar

b.d["m1"]

aa <- b.d[c("yr","acronimo","s2")]

#aa2 <- b.d %>% 
#  select("yr","acronimo","s2")



# Selección de columnas y/o renglones con índices
# df[index_1, index_2], donde:
# index_1 = renglón(es)
# index_2 = columna(s)

b.d[, "yr"]    # Selección de todos los renglones de columna de año

b.d[1:4, "yr"] # Selección de primeros cuatro renglones y columna de año

aa <- b.d[b.d$yr==2007, ] # Selección de observaciones para las cuales yr == 2007

b.d[, c("yr", "acronimo", "s2")] # Selección de tres columnas

aa <- b.d[b.d$yr==2007, c("yr", "acronimo", "s2")] # Selección tres columnas para yr == 2007


# Selección de columnas y/o renglones con subset
# subset(x,          # Nombre del data frame que quieren rebanar
#       subset = [], # Vector lógico qué determina que renglones mantener
#      select = []  # Vector que especifica qué columnas mantener
# ) 

subset(b.d,                # Nombre del data frame
       subset = yr == 2007) # Mantener observaciones yr == 2007
 
subset(b.d,                # Nombre del data frame
       select = c("yr", "acronimo", "s2"))  # Tres columnas a mantener


subset(b.d,                # Nombre del data frame
       subset = yr == 2007, # Incluir observaciones para los cuales yr == 2007
       select = c("yr", "acronimo", "s2"))  # Tres columnas a mantener



### dplyr - El mágico mundo de... ----


## Los cinco verbos de la felicidad 

# dplyr incluye cinco verbos o funciones, más varios parientes cercanos, que permiten realizar diversas transformaciones a una base de datos.

# Los cinco verbos y parientes funcionan de la misma forma:

# verbo(nombre_data_frame,
#      instrucciones para transformar data frame)

# - El primer argumento corresponde al nombre del data frame

# - El segundo argumento establece qué hacer con el data frame

# - El resultado siempre será un nuevo data frame

# - El data frame original no es modificado

# Estos son los cinco verbos:

# --- # --- # --- # --- # --- #

## filter():  generar subconjunto filtrando la bd con base en el valor de una o más variables

# filter(nombre_data_frame,
#       condición_lógica_1, 
#       condición_lógica_2, 
#       ..., 
#       condición_lógica_n)


cemabe_df2 <- filter(cemabe_df,
       NOM_MUN != "Tlalnepantla de Baz",  # Primer criterio
       NOM_MUN != "Naucalpan de Juárez",  # Segundo criterio
       P166 < 9999)                       # Tercer criterio


# Noten que esto es equivalente a:

filter(cemabe_df, NOM_MUN != "Tlalnepantla de Baz", NOM_MUN != "Naucalpan de Juárez", P166 < 9999)


# OJO: si quieren seleccionar todos los renglones en los que una variable es igual a dos o más posibles valores, entonces deben usar nom_variable %in% c(valor_1, valor_2, valor_3)

cemabe_df2 <- filter(cemabe_df, MUN %in% c(2, 7, 10)) # Mpos. con estas claves

# --- # --- # --- # --- # --- #


## select(): generar subconjunto seleccionando una o más columnas 

# select(nombre_data_frame,
#       condición_de_selección_1, 
#       condición_de_selección_2, 
#       ...,
#       condición_de_selección_n)

dim(cemabe_df)

cemabe_df2 <- select(cemabe_df,
       NOM_MUN, # Primera variable selccionada
       P166,    # Segunda variable selccionada
       P167,    # Tercera variable selccionada
       P313)    # Cuarta variable selccionada

# Noten que esto es equivalente a:

foo <- select(cemabe_df,
              starts_with("P"))

# y a:

foo_1 <- select(cemabe_df, c(NOM_MUN, P166, P167, P313))


# Extisten diferentes formas de seleccionar columnas:

select(nombre_data_frame,
       [nombre(s) de variable(s)],      # Incluir variables especificadas
       c([nombre(s) de variable(s)]),  # Incluir variables especificadas
       -c([nombre(s) de variable(s)]),  # Excluir variables especificadas
       starts_with("cadena_de_texto"),  # Incluir variables que EMPIECEN con cadena de texto
       ends_with("cadena_de_texto"),    # Incluir variables que TERMINEN con cadena de texto
       contains("cadena_de_texto"),     # Incluir variables que CONTENGAN con cadena de texto
       num_range("x", 1:3))     # Incluir variables que EMPIECEN con letra y ciertos núm.


# Noten que pueden combinar diversas formas de selección:

cemabe_df2 <- select(cemabe_df,
       starts_with("NOM_"),
       ends_with("64"),
       contains("ENT"),
       num_range("P", 214:220))   


# --- # --- # --- # --- # --- #


# arrange(): ordenar la bd a partir de los valores de una o más variables

# arrange(nombre_data_frame,
#         nom_variable_1, 
#         nom_variable_2,
#         ...,
#         nom_variable_n)


# arrange(nombre_data_frame,
#         des(nom_variable_1),       # Orden descendente
#         nom_variable_2,
#         ...,
#         nom_variable_n)

arrange(foo,
        P166, # Primer criterio para ordenar renglones
        P313) # Segundo criterio para ordenar renglones (desempate)

arrange(foo,
        desc(P166), # Orden descendente
        P313)


# --- # --- # --- # --- # --- #


# mutate(): i) crea nuevas variables a partir de las existentes y ii) y permite reemplazar variables existentes después de transformarlas

# mutate(nombre_data_frame,
#        fórmula para construir nueva(s) variable(s))

# Ejemplo: 

# Primer paso: generar un subconjunto con cinco variables y guardarlo en un nuevo objeto llamado bd
bd <- select(cemabe_df,
             NOM_MUN,
             P166,  # Alumnos inscritos
             P167,  # Alumnos que podrían atenderse
             P221,  # Núm. de muebles para sentarse que necesitan reparación
             P313)  # Maestros frente al grupo


# Segundo paso: eliminar valores = 9999 (sin información)
bd_limpia <- filter(bd,
                    P166 < 9999,
                    P167 < 9999,
                    P221 < 9999)

# Tercer paso: comparar dimensiones de cemabe_df, bd y bd_limpia
dim(cemabe_df)
dim(bd)
dim(bd_limpia)

# Cuarto paso: generar nuevas variables
bd_limpia_1 <- mutate(bd_limpia,
                      axm = P166/P313,  # Alumnos por maestro
                      sobrecupo = P166-P167, # Dif. entre alumnos potenciales e inscritos
                      sobrecupo_1 = sobrecupo/100) # OJO: pueden utilizar variables recién creadas


# Funciones que se pueden usar dentro de mutate()

# Artiméticas:

# Suma (+)
# Resta (-)
# Multiplicación (*)
# División (/)
# Potencia (^)


# Comparaciones lógicas: 

# Igual a (==)
# Diferente de (!=)
# Mayor o igual que (>=)
# Mayor que (>)
# Menor o igual que (<=)
# Menor que (<)

# Rankings:

# Ranking absoluto: `min_rank()` o `min_rank(desc())` 
# Ranking porcentual: `percent_rank()`

# Ejemplo:

# Primer paso: filtrar año para solo utilizar datos de 2007
bd_iesp_07 <- filter(bd_iesp, 
                     yr == 2007)

# Segundo paso: seleccionar tres columnas
bd_iesp_07 <- select(bd_iesp_07, 
                     acronimo, s2, m1)

# Tercer paso: calcular rankings
mutate(bd_iesp_07,
       rank_presupuesto = min_rank(s2),  # Raking presupuesto
       rank_matrícula = min_rank(m1))    # Raking matrícula

# Cuarto paso: calcular rankings de forma descendiente
mutate(bd_iesp,
       rank_presupuesto = min_rank(desc(s2)),  # Raking presupuesto
       rank_matrícula = min_rank(desc(m1)))    # Raking matrícula

# Logaritmos:

# log()   - Logaritmo natural 
# log10() - Logaritmo base 10
# log2()  - Logaritmo base 2 o binario


# Variables desfasadas: 

# Permiten calcular cambios absolutos en el tiempo. Por ejemplo, valor[t1] - valor[t0]

# lead(): valor siguiente
# lag():  valor rezagado/anterior

mutate(pib_mex, 
       pib_lag = lag(pib), 
       c_abs = pib - pib_lag,
       c_por = c_abs/pib_lag * 100)

# Podemos especificar el número de períodos que quieren rezagar o adelantar una variable

mutate(pib_mex, 
       lag_1 = lag(pib),
       lag_2 =  lag(pib, n = 2),
       lag_3 =  lag(pib, n = 3),
       lag_4 =  lag(pib, n = 4),
       lag_5 =  lag(pib, n = 5))

mutate(pib_mex, 
       lead_1 = lead(pib),
       lead_2 =  lead(pib, n = 2),
       lead_3 =  lead(pib, n = 3),
       lead_4 =  lead(pib, n = 4),
       lead_5 =  lead(pib, n = 5))



# summarise(): calcular diversas estadísticas (OJO: la bd se colapsa)

# summarize(nombre_data_frame,
#           fórmula_1, 
#           fórmula_2,
#           ...,
#           fórmula_n)

# La lista de estadísticas que pueden calcular con summarize() es enorme, e incluye:

# n()           - Núm. de observaciones          
# n_distinct(x) - Núm. de obs. únicas/distintas
# mean()        - Promedio  
# median()      - Mediana                       
# sum()         - Suma                        
# sd()          - Desv. Estándar
# IQR()         - Rango Intercuartil
# mad()         - Desviación media absoluta:     
# min()                    - Mínimo
# max()                    - Máximo
# quantile(x, 0.25)        - Cuantil
# first()                  - Primero
# last()                   - Último
# sum([condición lógica])  - Suma de casos que cumplen condición.  Por ejemplo, `sum(x > 10).
# mean([condición lógica]) - Promedio de casos que cumplen condición. Por ejemplo, `mean(x > 10).


#############################################
#############################################


# group_by(): permite calcular estadísticas descritivas por grupo de observaciones

# Cálculo sin group_by()
summarize(cemabe_df,
          prom_alumnos = mean(P166, na.rm = TRUE),  # Promedio
          min_alumnos = min(P166, na.rm = TRUE),    # Mínimo
          max_alumnos = max(P166, na.rm = TRUE),    # Máximo
          desv_alumnos = sd(P166, na.rm = TRUE))    # Desviación estándar

# Cálculo con group_by()

# Primero agrupamos los datos por delegación y los guardo en un NUEVO data frame
cemabe_delegacion <- group_by(cemabe_df, NOM_MUN)


# Después, calculamos los mismo cuatro valores pero ahora por grupo
summarize(cemabe_delegacion,       
          prom_alumnos = mean(P166, na.rm = TRUE),  # Promedio
          min_alumnos = min(P166, na.rm = TRUE),    # Mínimo
          max_alumnos = max(P166, na.rm = TRUE),    # Máximo
          desv_alumnos = sd(P166, na.rm = TRUE))    # Desviación estándar


#############################################
#############################################


# transmute(): Igual que mutate(), pero genera nuevo data frame que sólo incluye variable "mutadas".
nueva_bd <- transmute(cemabe_df,
                      axm = P166/P313,
                      sobrecupo = P166-P167,
                      sobrecupo_1 = sobrecupo/100)


#############################################
#############################################


# rename(): renombrar variables
rename(nombre_data_frame,
       nuevo_nombre_variable = antiguo_nombre_variable)


#############################################
#############################################


# everything( ): Combinado con select(), permite seleccionar todas las columnas de forma simultánea.

# Útil para reacomodar ciertas columnas al comienzo del data frame.

select(cemabe_df, 
       ENT,             # Primera columna del data frame
       NOM_ENT,         # Segunda columna del data frame 
       everything())    # Todo lo demás




### La magia de la pipa: %>% ----

# La pipa (%>%) nos permite concatenar funciones de forma sencilla, clara e intuitiva.

# Shorcut para usarla en Windows: CTRL + SHIFT + M
# Shorcut para usarla en Mac: CMD + SHIFT + M

cemabe_df %>%                                        # 1) Utilizar data frame cemabe_df
  group_by(NOM_MUN) %>%                              # 2) Agrupar datos por delegación
  summarize(prom_alumnos = mean(P166, na.rm = TRUE), # 3) Calcular el promedio, min, max 
            min_alumnos = min(P166, na.rm = TRUE),   #    y desv. est de P166
            max_alumnos = max(P166, na.rm = TRUE),
            desv_alumnos = sd(P166, na.rm = TRUE))
