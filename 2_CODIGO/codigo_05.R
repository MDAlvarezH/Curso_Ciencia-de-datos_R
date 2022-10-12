###
### Sesión 05 - Gráficas con R base | Intro a ggplot2

### Paquetes ----
library(pacman)
p_load(dplyr, ggplot2, janitor, readr, readxl, tidyr)


### Bases de datos ----

### IESP
iesp <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv", 
                 locale = locale(asciify = TRUE))


### CEMABE CDMX 
# Usando URL
cemabe_df <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/cemabe_cdmx.csv",
                      col_types = cols(ID_INM = col_character()), 
                      locale = locale(asciify = TRUE))


# OJO: Filtrar municipios del EdoMex
cemabe_df <- cemabe_df %>%                    
  filter(NOM_MUN != "Tlalnepantla de Baz" |
           NOM_MUN != "Naucalpan de Juárez")



### Gráficas en R base ----

# plot() - Diagrama de dispersión, líneas y varias más  
plot(
  x = iesp$s2[iesp$yr==2009],
  y = iesp$m1[iesp$yr==2009],
  col = "#00336640",
  pch = 16,
  main = "Soy un scatter plot...",
  xlab = "\n Subsidio federal ordinario",
  ylab = "\n Matrícula total",
  cex.main = 1.8
)

# hist() - Histograma
hist(
  x = iesp$s2[iesp$yr==2009],
  xlim = c(0, 30000),
  col = "#00336680",
  border = "#00336680",
  main = "Soy un histograma...",
  xlab = "Subsidio federal ordinario",
  ylab = "Frecuencia",
  cex.main = 1.8
)

# dotchart() - Dot plot
iesp <- iesp[order(iesp$s2),] # Reordenar los datos
dotchart(
  x = iesp$s2[iesp$yr==2009 & iesp$tipo == "Estatal"],
  labels = iesp$acronimo[iesp$yr==2009 & iesp$tipo == "Estatal"],
  xlim = c(0, 3000),
  pch = 16,
  col = "#003366",
  lcolor = "#666666",
  main = "Soy un dot plot...",
  xlab = "Subsidio federal ordinario",
  cex = 0.8,
  cex.main = 1.8
)

# barplot() - Gráfica de barras
iesp <- iesp[order(iesp$s2),] # Reordenar los datos

# Versión 1
barplot(
  height = iesp$s2[iesp$yr==2009],
  names.arg = iesp$acronimo[iesp$yr==2009],
  col = "#00336680",
  border = "#00336680",
  main = "Soy una gráfica de barras... \n",
  ylab = "Subsidio federal ordinario \n ",
  ylim = c(0,30000),
  cex.main = 1.8
)

# Versión 2
barplot(
  height = iesp$s2[iesp$yr==2009],
  names.arg = iesp$acronimo[iesp$yr==2009],
  col = "#00336680",
  border = "#00336680",
  main = "Soy una gráfica de barras... \n",
  ylab = "Subsidio federal ordinario \n ",
  ylim = c(0,30000),
  cex.main = 1.8,
  las = 2     # Cambia orientación de las etiquetas en AMBOS ejes
)

# Versión 3

par(mar=c(8.1, 5.1, 3, 2.1)) # Cambiar márgenes: c(abajo, izq., arriba, der.)

barras <- barplot(
  iesp$s2[iesp$yr==2009], col = "#00336680", border = "#00336680",
  main = "Soy una gráfica de barras... \n", ylab = "Subsidio federal ordinario \n ",
  ylim = c(0,30000), cex.main = 1.8,
  
  xaxt = "n",          # No graficar el eje
  yaxt = "n")          # No graficar el eje y

axis(1,                # Incluir eje: 1 = x, 2 = y
     cex.axis = 0.7,   # Definir tamaño de letra
     labels = iesp$acronimo[iesp$yr==2009],      # Definir de dónde tomar las etiquetas
     at = barras,                                # Posición de las etiquetas
     las = 2)                                    # Orientación de etiquetas: 1 o 2

axis(2, cex.axis = 1, las = 1)                # Incluir eje y
par(mar=c(5.1, 4.1, 4.1, 2.1))                # Regresar márgenes al default





### ggplot2 ----

# Cualquier gráfica hecha con ggplot2 puede incluir hasta siete parámetros

# ggplot(data = <DATOS>) +      # 1) Nombre del data frame del cual obtener los datos
#   <GEOM_FUNCIÓN>(             # 2) Objeto geométrico que representará variable(s)
#     mapping = aes(<MAPEO>),   # 3) Instrucciones para asignar variables a canales
#     stat = <STAT>,            # 4) Transformación estadística a realizar en variables
#     position = <POSICIÓN>) +  # 5) Ajuste de posición de los elementos en el geom
#   <COORDENADAS> +     # 6) Tipo de sistema de coordenadas a utilizar
#   <FACET>             # 7) Función para generar facetas


# geom_histogram()
cemabe_df %>%
  ggplot() +
  geom_histogram(mapping = aes(x = P166))

# geom_density()
cemabe_df %>%
  ggplot() +
  geom_density(mapping = aes(x = P166))


# geom_point()

# Versión 1
cemabe_df %>%
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166))

# Versión 2
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>% # Filtrar datos
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166),
             alpha = 0.3) # Cambio en la opacidad de los puntos

# Versión 3
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, color = as.factor(NIVEL) # Color por nivel educativo
  ), alpha = 0.3)

# Versión 4
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166,
                           color = nivel_texto), 
             alpha = 0.3)

# Versión 5
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", 
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria", 
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, 
                           y = P166, 
                           color = nivel_texto,
                           size = P313), # Tamaño por # maestros
             alpha = 0.3)

# Versión 6
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166), alpha = 0.3) +
  geom_smooth(mapping = aes(x = P167, y = P166))    # Añadir geom

# Versión 7 
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166), alpha = 0.3) +
  geom_smooth(mapping = aes(x = P167,  y = P166),
              method = "lm")            # Especificar método de regresión lineal


# Ahora, todas las versiones modificando el objeto gráfica

# Versión 2
g <- cemabe_df %>%                
  filter(P166 < 4000, P167 < 4000) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166), alpha = 0.3) 

# Versión 3
g_1 <- g + 
  geom_point(mapping = aes(x = P167, y = P166, color = as.factor(NIVEL) ), alpha = 0.3)

# Versión 4
g_1 +
  geom_point(mapping = aes(x = P167, y = P166, color = as.factor(NIVEL), size = P313),  alpha = 0.3)

# Versión 5
g + 
  geom_smooth(mapping = aes(x = P167, y = P166))

# Versión 6
g + 
  geom_smooth(mapping = aes(x = P167,  y = P166),
            method = "lm")  

