###
### Sesión 07 - ggplot2: la última y nos vamos
###

### Paquetes ----

library(pacman)
p_load(cowplot, forcats, ggrepel, ggthemes, gridExtra, knitr, magick, RColorBrewer, readr, scales, tidyverse)

theme_set(theme_grey()) # Esta línea es necesaria porque el paquete cowplot modifica el tema default de ggplot2. Ver: https://stackoverflow.com/questions/41096293/cowplot-made-ggplot2-theme-disappear-how-to-see-current-ggplot2-theme-and-res


### Importar base(s) de datos ----

# Datos de ExECUM
bd_iesp <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/bd_iesp_07_10.csv")

# Renombrar variables
bd_iesp <- bd_iesp %>% 
  rename(sfo = s2, mat_tot = m1, doc_tot = d1) 

### Setup ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") # Cambiar locale para prevenir problemas con caracteres especiales
options(scipen=999)      # Prevenir notación científica

### ggplot2 ----

## Crear y guardar temas ----

# Primero, modificamos uno de los temas disponibles y lo guardamos como un nuevo objeto

mi_tema <- theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(linetype = "dashed"),
        axis.title = element_text(size = 12, hjust = 1, color = "#a50f15", face = "bold"),
        axis.title.x = element_text(margin = margin(15, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 15, 0, 0)))

# Segundo, creamos una gráfica sin modificar el tema
bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(sfo, mat_tot)) +
  labs(x = "Subsidio federal ordinario",
       y = "Matrícula total")

# Tercero, asignamos el tema a la gráfica
bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(sfo, mat_tot)) +
  labs(x = "Subsidio federal ordinario",
       y = "Matrícula total") +
  mi_tema


## Juntar dos o más gráficas en una imagen ----

# Primero, generemos dos gráficas

g1 <- bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(sfo, mat_tot)) +
  labs(x = "Subsidio federal ordinario",
       y = "Matrícula total") +
  mi_tema

g2 <- bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_col(aes(reorder(acronimo, sfo), sfo)) +
  labs(x = "",
       y = "Subsidio federal ordinario") +
  mi_tema +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 7))


# Segundo, unimos las gráfcias con el paquete cowplot

# Especificación mínima...
plot_grid(g1, g2)

# Alineando las gráficas verticalmente
plot_grid(g1, g2, 
          align = 'h')

# Alineando las gráficas en dos renglones
plot_grid(g1, g2, 
          nrow = 2)

# Agregar el logo del mejor equipo del mundo 
pumas <- ggdraw() +
  draw_image("C:/Users/migue/Mi unidad/CURSOS/Curso_UAM_Ciencia de datos R_MDAH/2_CODIGO/Datos/puma.png", scale = 0.8)

plot_grid(g1, pumas, NULL, g2, 
          nrow = 2, 
          ncol = 2, 
          align = 'v')

# Tercero, unimos las gráfcias con el paquete patchwork

# Especificación mínima...
g1 + g2

# Definir orden de las gráficas y peso relativo de cada una
g1 + g2 +
  plot_layout(ncol = 1,           # Definir columnas/renglones
              heights = c(1, 3))  # Definir altura relativa de cada gráfica



## Escalas ----

# Las escalas nos permiten ajustar diversos aspectos relacionados con los elementos estéticos (aes()) de una gráfica.
# 
# Todas las escalas se construyen igual:
#   
#   scale_[aes]_[nombre escala]()

# El [aes] en scale_[aes]_[nombre escala]() puede referise a:
#   
# - Canales de posición: x | y
# - Canales de color: colour | fill | alpha
# - Canales de tamaño: size | radius
# - Canales variaditos: shape| linetype
#
# Por ejemplo: scale_x_ | scale_fill_ | scale_size_

# El [nombre escala] en scale_[aes]_[nombre escala]() dependerá del [aes]:
#   
# Por ejemplo, para scale_x/y_ pueden ser:
#   
#   continuous | discrete | log10 | sqrt | date | …
#
# Para scale_color/fill/alpha pueden ser
# 
# continuous | discrete | manual | …


## Transformaciones logarírtmicas 
#
# scale_x/y_log10()

# Versión inicial de la gráfica
g1 <- bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(sfo, mat_tot)) +
  labs(x = "Subsidio federal ordinario",
       y = "Matrícula total")

g1

# Versión transformando las variables 
bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(log(sfo),
                 log(mat_tot))) +
  labs(x = "Subsidio federal ordinario (log)",
       y = "Matrícula total (log)")

# Versión transformando escala de los ejes
bd_iesp %>% 
  filter(yr == 2009) %>% 
  ggplot() + 
  geom_point(aes(sfo, mat_tot)) +
  scale_x_log10() +
  scale_y_log10() +
  labs(x = "Subsidio federal ordinario (log base 10)",
       y = "Matrícula total (log base 10)")


## Cambiar etiquetas en los ejes
#
#  scale_x/y_continuous() | scale_x/y_discrete()

# scale_x/y_continuous() y scale_x/y_discrete() nos permiten modificar diferentes elementos de los ejes:
#   
# - breaks = posición donde aparecen las etiquetas del eje
# - labels = etiquetas que apareceran en los breaks
# - limits = límites del eje
# - position = posición del eje: "top", "right", "bottom" o "left" 


# Cambiar marcas en eje x

# Versión 1  
g1 + scale_x_continuous(breaks = seq(0, 25000, 2500), 
                        labels = comma)

# Versión 2
g1 + scale_x_continuous(breaks = c(seq(0, 10000, 2500), 
                                   seq(15000, 25000, 5000)), 
                        labels = comma)

# Versión 3
g1 + scale_x_continuous(breaks = c(seq(0, 10000, 2500), seq(15000, 25000, 5000)), labels = 1:8)

# Versión 4
g1 + scale_x_continuous(breaks = c(seq(0, 10000, 2500), seq(15000, 25000, 5000)), labels = c("Poquito", "", "", "", "", "", "", "Muchito"))


## Cambiar colores

# scale_colour_manual()

# Nos permiten modificar:
#   
# values = el color asignado a cada valor de una variable discreta
# labels = las etiquetas que aparecen en la leyenda de colores
# 

# Versión 1 de g2 : g1 + color = tipo
g2 <- g1 + 
  geom_point(aes(sfo, mat_tot,
                 color = tipo)) # Asignamos color a tipo
  
# Versión 2: cambiar colores
g2 + scale_colour_manual(values = c("steelblue", "salmon"))

# Versión 2: cambiar colores y etiquetas
g2 + scale_colour_manual(values = c("steelblue", "salmon"), labels = c("Estataaaaales", "Federaaaaaales"))


# scale_color_brewer()

# Es otra opción para camboar colores. Requiere que el paquete RColorBrewer esté instalado y cargado.
# 
# RColorBrewer ofrece varias paletas de colores precargadas.

# Versión 1: paleta Set2
g2 + scale_colour_brewer(palette = "Set2")

# Versión 2: paleta Set2 y etiquetas
g2 + scale_colour_brewer(palette = "Set2",
                         labels = c("Estataaaaales", "Federaaaaaales"))


# scale_colour_gradient()

# Si el canal color (o fill) está asignado a una variable continua, debemos usar scale_colour_gradient() para modificarlo.


# Versión 1 de g3
g3 <- bd_iesp %>%
  filter(yr == 2009) %>%
  ggplot() +
  geom_point(aes(sfo, mat_tot,
                 color = sfo,
                 size = sfo)) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +   
  labs(x = "Subsidio federal ordinario",
       y = "Matrícula total")

# Versión 2
g3 + scale_color_gradient(low = "white", high = "steelblue")


## Leyendas ----

# Para reubicar la leyenda debemos ir a theme y usar alguna de las siguientes opciones:

g3 + theme(legend.position = "left")
g3 + theme(legend.position = "top")
g3 + theme(legend.position = "bottom")
g3 + theme(legend.position = "right")
g3 + theme(legend.position = c(0.5, 0.5))

# Para suprimir alguna de las leyendas, debemos especificarlo en el scale_ correspondiente.

# Por ejemplo, para borrar la leyenda de tamaño en g3:
g3 + scale_size_continuous(guide = FALSE)

## Zoom ----

# Hay dos opciones para hacer zoom a una parte de la gráfica: 
  
# - scale_x/y_continuous(limits = c(min, max)) | scale_x/y_discrete(limits = c(min, max))
# 
# - coord_cartesian(xlim = c(min, max), ylim = c(min, max))

# Cada opción genera resultados diferentes.
# 
# Para verlo, agreguemos una línea regresión lineal a la gráfica g3 y guardémosla como g4
# 
g4 <- g3 +
  geom_smooth(aes(sfo, mat_tot), method = "lm")

# Zoom usando scale_x/y_:
g4 +
  scale_x_continuous(limits = c(0, 11000), 
                     labels = comma) +
  scale_y_continuous(limits = c(0, 100000), 
                     labels = comma)

# Zoom usando coord_cartesian():
g4 + 
  coord_cartesian(xlim = c(0, 11000), 
                  ylim = c(0, 100000))





## Etiquetas ----

# Existen varias formas de agregar etiquetas en ggplot2

# Primero, hagamos una gráfica de barras
g <- bd_iesp %>% 
  filter(yr == 2009, tipo == "Federal") %>% # Filtrar datos
  ggplot() +
  geom_col(aes(reorder(acronimo, sfo), sfo), fill = "steelblue") +
  scale_y_continuous(labels = comma) +
  labs(x = "", y = "") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# Segundo, enchulemos la gráfica anterior (i) redondeandp valores y agregando la coma de miles a la etiqueta de cada barra; (ii) cambiando el color de la etiqueta; (iii) alineando la etiqueta; (iv) cambiando el tamaño de la etiqueta; y (v) aumentando los límites del eje y
g + 
  geom_text(aes(x = reorder(acronimo, sfo), 
                y = sfo, 
                label = comma(round(sfo, 1))), 
            col = "#666666",  # Color de la etiqueta
            vjust = -1,       # Alineación vertical
            size = 3) +        # Tamaño de la etiqueta
  scale_y_continuous(limits = c(0,26000),          # Cambiar límites
                     breaks = seq(0, 25000, 5000), # Posición de etiquetas en el eje
                     labels = comma) 


# Ahora agreguemos etiquetas a un diagrama de dispersión

# Primero, la gráfica
g <- bd_iesp %>% 
  filter(yr == 2009) %>% # Filtro datos
  ggplot() +
  geom_point(aes(sfo, mat_tot), col = "steelblue", alpha = 0.5) +
  labs(x = "Subsidio federal ordinario", 
       y = "Matrícula total") +
  theme_minimal()

# Ahora agreguemos las etiquetas con geom_text()
g +
  geom_text(aes(x = sfo, 
                y = mat_tot, 
                label = acronimo),
            size = 2.5)

# No guta. Instalemos/cargemos/usemos ggrepel, en particular la función geom_text_repel()
g +
  geom_text_repel(aes(x = sfo,
                      y = mat_tot, 
                      label = acronimo),
                  size = 2.5)

# Mejoremos más la cosa creando una nueva variable que incluya sólo parte de las etiquetas
bd_iesp %>% 
  filter(yr == 2009) %>% # Filtro datos
  mutate(etiqueta = ifelse(mat_tot > 25000, acronimo, "")) %>% # Nueva variable
  ggplot() +
  geom_point(aes(sfo, mat_tot), col = "steelblue", alpha = 0.5) +
  geom_text_repel(aes(x = sfo,
                      y = mat_tot, 
                      label = etiqueta), # Noten que ahora uso "etiqueta", no "acronimo""
                  size = 2.5) +
  labs(x = "Subsidio federal ordinario", 
       y = "Matrícula total") +
  theme_minimal()


# Ahora agreguemos texto a la gráfica

# Primero, la gráfica
g <- bd_iesp %>% 
  filter(yr == 2009) %>% # Filtro datos
  ggplot() +
  geom_point(aes(sfo, mat_tot), col = "steelblue", alpha = 0.5) +
  labs(x = "Subsidio federal ordinario", 
       y = "Matrícula total") +
  theme_minimal()

# Después, agregamos el texto
g + 
  annotate("text", 
           label = "Soy un hermoso texto", 
           x = 10000, 
           y = 150000, 
           size = 8, 
           colour = "salmon") 


## Guardar gráficas ----

# Por default, ggsave() guarda:
#   
# - La última gráfica generada con `ggplot2`
# - Usando las dimensiones del panel de gráficas en RStudio
# - Lo hace en el directorio de trabajo de la sesión

# ¿Cómo modificar esto?
#   
  
# ggsave("nombre_del_archivo",        # Nombre con que queremos guardar la gráfica
#        plot = nombre_de_grafica,    # En su caso, nombre de objeto que contiene gráfica
#        device = NULL,               # Formato de imagen: .png, .pdf, etc
#        path = NULL,                 # Ruta al folder donde queremos guardarla
#        scale = 1,                   # Escala de la gráfica
#        width = NA,                  # Ancho de la gráfica
#        height = NA,                 # Alto de la gráfica
#        units = c("in", "cm", "mm")) # Unidades ancho/alto

ggsave("esta_es_mi_grafica.png",
       plot = g4)





