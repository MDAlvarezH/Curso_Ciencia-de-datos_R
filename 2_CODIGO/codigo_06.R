###
### Sesión 6 - Puro ggplot2

### Paquetes ----
library(pacman)
p_load(forcats, ggthemes, scales, tidyverse)


### Bases de datos ----

### CEMABE CDMX 
# Usando URL
cemabe_df <- read_csv("http://segasi.com.mx/clases/cide/vis_man/datos/cemabe_cdmx.csv",
                      col_types = cols(ID_INM = col_character()), 
                      locale = locale(asciify = TRUE))


# OJO: Filtrar municipios del EdoMex
cemabe_df <- cemabe_df %>%                    
  filter(NOM_MUN != "Tlalnepantla de Baz" |
           NOM_MUN != "Naucalpan de Juárez")

### ggplot2 ----

# Recordatorio: Cualquier gráfica hecha con ggplot2 puede incluir hasta siete parámetros:

# ggplot(data = <DATOS>) +      # 1) Nombre del data frame del cual obtener los datos
#   <GEOM_FUNCIÓN>(             # 2) Objeto geométrico que representará variable(s)
#     mapping = aes(<MAPEO>),   # 3) Instrucciones para asignar variables a canales
#     stat = <STAT>,            # 4) Transformación estadística a realizar en variables
#     position = <POSICIÓN>) +  # 5) Ajuste de posición de los elementos en el geom
#   <COORDENADAS> +     # 6) Tipo de sistema de coordenadas a utilizar
#   <FACET>             # 7) Función para generar facetas


## geom_bar() ----

# Versión 1: Odisea burbujas vamos a despegar...
cemabe_df %>% 
  ggplot() + 
  geom_bar(mapping = aes(x = NOM_MUN))

# Versión 2: Corrección de etiquetas en eje x. 
cemabe_df %>% 
  ggplot() + 
  geom_bar(mapping = aes(x = NOM_MUN)) +
  theme(axis.text.x = element_text(angle = 90))

# Versión 3: Corrección de etiquetas en eje x bis
cemabe_df %>% 
  ggplot() + 
  geom_bar(mapping = aes(x = NOM_MUN)) +
  theme(axis.text.x = element_text(angle = 90, 
                                   hjust = 1,    # justificación "horizontal" de texto 
                                   vjust = 0.4), # justificación "vertical" de texto
        axis.title.x = element_blank())  


# Versión 4: Reordenar barras
# Necesitan tener el paquete forcats instalado y cargado
cemabe_df %>% 
  ggplot() + 
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank()) 

# Explicación:
# 1) fct_infreq() = Reordena factores por frecuencia
# 2) fct_rev() = Revierte el orden de los factores


## stat ----

# stat define la transformación estadística que ggplot2 utilizará para generar la gráfica.

# geom_bar() + stat = identity
cemabe_df %>%
  group_by(NOM_MUN) %>% 
  summarise(num_alu = sum(P166, na.rm = TRUE)) %>% 
  ggplot() + 
  geom_bar(mapping = aes(x = NOM_MUN, y = num_alu),
           stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


# geom_bar() + stat = identity + reorder

# reorder(vector_a_ser_reordenado,
#         [vector_cuyos_valores_determinan_el_orden])

cemabe_df %>%
  group_by(NOM_MUN) %>%
  summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = reorder(NOM_MUN, num_alu),  
                         y = num_alu),
           stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


# geom_col() - Una alternativa más sencilla al código de arriba

cemabe_df %>%
  group_by(NOM_MUN) %>% 
  summarise(num_alu = sum(P166, na.rm = TRUE)) %>% # Primero calculamos variable
  ungroup() %>% 
  ggplot() + 
  geom_col(mapping = aes(x = reorder(NOM_MUN, num_alu), y = num_alu)) + # Noten que cambié el geom_
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


# geom_bar() + ..prop.. + reorder
cemabe_df %>%
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)), 
                         y = ..prop.., 
                         group = 1)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


## position ----

# geom_bar() + position = NA (el default)
cemabe_df %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)),
                         fill = nivel_texto)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


# geom_bar() + position = "identity" 
cemabe_df %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)),
                         fill = nivel_texto), 
           position = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())

# geom_bar() + position = "identity" + alpha = 0.3
cemabe_df %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)),
                         fill = nivel_texto), 
           alpha = 0.3,
           position = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())

# geom_bar() + position = "fill"
cemabe_df %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)),
                         fill = nivel_texto), 
           position = "fill")  +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())

# geom_bar() + position = "dodge"
cemabe_df %>%
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar",
                                 NIVEL == 3 ~ "Primaria",
                                 NIVEL == 4 ~ "Secundaria",
                                 NIVEL == 7 ~ "CAM",
                                 NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = fct_rev(fct_infreq(NOM_MUN)),
                         fill = nivel_texto), 
           position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4), 
        axis.title.x = element_blank())


# geom_point() + position = "identity" 
cemabe_df %>%
  filter(P166 < 7500) %>% # Número de alumnos por centro de trabajo (P166) 
  ggplot() +
  geom_point(mapping = aes(x = P166, y = NOM_MUN),
             position = "identity")

# geom_point() + position = "jitter" 
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_point(mapping = aes(x = P166, y = NOM_MUN),
             position = "jitter")


# geom_point() + position = "jitter" + alpha = 0.3
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_point(mapping = aes(x = P166, y = NOM_MUN, alpha = 0.3),
             position = "jitter")

# geom_jitter() + alpha = 0.3
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_jitter(mapping = aes(x = P166, y = NOM_MUN),
              alpha = 0.3)

# geom_jitter() + alpha = 0.3 + width = 0.2
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_jitter(mapping = aes(x = P166, y = NOM_MUN),
              alpha = 0.3,
              width = 0.2)

# geom_jitter() + alpha = 0.3 + width = 0.2 + height = 0.1
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_jitter(mapping = aes(x = P166, y = NOM_MUN),
              alpha = 0.3,
              width = 0.2,
              height = 0.1)

# geom_jitter() + alpha = 0.3 + width = 0.2 + height = 0.1 + color
cemabe_df %>%
  filter(P166 < 7500) %>%
  ggplot() +
  geom_jitter(mapping = aes(x = P166, y = NOM_MUN, col = as.factor(NOM_MUN)),
              alpha = 0.3,
              width = 0.2,
              height = 0.1)


## coord_ ----

# coord_flip() - Invertir ejes

# Versión 1
cemabe_df %>%
  group_by(NOM_MUN) %>%
  summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = reorder(NOM_MUN, num_alu), y = num_alu),
           stat = "identity") +
  theme(axis.title = element_blank()) 

# Versión 2: Invertir ejes
cemabe_df %>%
  group_by(NOM_MUN) %>%
  summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = reorder(NOM_MUN, num_alu), y = num_alu),
           stat = "identity") +
  theme(axis.title = element_blank()) +
  coord_flip() # Invertir ejes
  

# coord_polar() - Pays y donas

# Versión 1
cemabe_df %>% group_by(NOM_MUN) %>% summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = reorder(NOM_MUN, num_alu),
                         y = num_alu),
           stat = "identity")

# Versión 2: Código modificado
cemabe_df %>% group_by(NOM_MUN) %>% summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = "",    # 1) Eliminar variable mapeada al eje x
                         y = num_alu,
                         fill = factor(NOM_MUN)),  # 2) Mapear NOM_MUN a fill
           width = 1, # 3) Especificar ancho de la "dona". Min = 0 | Max = 1
           stat = "identity") +
  coord_polar(theta ="y")   # 4) Definir coord. y variable a la cual mapear ángulo


# Versión 3: enchulemos la gráfica
cemabe_df %>% group_by(NOM_MUN) %>% summarise(num_alu = sum(P166, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = "",  
                         y = num_alu,
                         fill = factor(NOM_MUN)),  
           width = 1,
           stat = "identity") +
  coord_polar(theta ="y") +
  theme(panel.background = element_blank(), # Eliminar el fondo de la gráfica
        axis.title = element_blank(),       # Eliminar títulos en ejes
        axis.ticks = element_blank(),       # Eliminar ticks en ejes
        axis.text = element_blank())        # Eliminar texto en ejes



## facet_ ----

# facet_ nos permite generar gráficas para subconjuntos de nuestros datos. Hay dos tipos:

# facet_wrap(): útil para generar facetas usando una sola variable discreta.
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  ggplot(mapping = aes(x = P167, y = P166)) +
  geom_point(alpha = 0.3) +
  geom_smooth() +
  facet_wrap( ~ NOM_MUN)  # Desagregar gráfica por delegación

# facet_grid(): permite generar facetas usando dos variables discretas
cemabe_df %>%
  filter(P166 < 4000, P167 < 4000) %>%
  ggplot(mapping = aes(x = P167, y = P166)) +
  geom_point(alpha = 0.3) +
  geom_smooth() +
  facet_grid(TURNO ~ NOM_MUN)  # Desagregar gráfica por delegación y turno

## labs(): títulos y notas ----

# labs(title = "Aquí va el título",
#      subtitle = "Aquí va el subtítulo",
#      x = "Aquí va el título del eje x",
#      y = "Aquí va el título del eje y",
#      colour = "Aquí va el título de la leyenda de color",
#      fill = "Aquí va el título de la leyenda de color de relleno",
#      size = "Aquí va el título de la leyenda de tamaño",
#      alpha = "Aquí va el título de la leyenda de opacidad",
#      caption = "Aquí va el texto de la nota al pie")

# Versión 1
cemabe_df %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, # P167 = Alumnos que podrían atenderse en el Centro de trabajo
                           y = P166, # P166 = Alumnos inscritos en el Centro de trabajo
                           colour = nivel_texto,
                           size = P313), # P313 = Maestros frente al grupo
             alpha = 0.3)

# Versión 2: con títulos y nota al pie
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",  # Título de la gráfica
       subtitle = "Esta gráfica muestra...",           # Subítulo de la gráfica
       x = "Alumnos que podrían atenderse en el centro de trabajo", # Título eje x
       y = "Alumnos inscritos en el centro de trabajo", # Título eje y
       colour = "Nivel escolar", # Título leyenda de colores
       size = "Núm. maestros",    # Título leyenda de tamaño
       caption = "Fuente: elaboración propia con datos del CEMABE.")

## theme_ y theme(): enchulando la máquina ----

# Para cambiar casi cualquier elemento de la gráfica, tenemos que modificar todo o parte del tema con theme().

# Dos tipos de cambios:
# Generales, eligiendo un tema específico: theme_[nombre]()
# Particulares, eligiendo un elemento específico en un tema: theme(plot.title = element_text)

# Versión 1
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.")

# Versión 2: Usar theme_bw() 
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.") +
  theme_bw()

# Versión 3: Usar theme_classic() 
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.") +
  theme_classic()


# Ahora con algunos de los temas de ggtheme

# theme_tufte()
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.") +
  theme_tufte()     

# theme_excel()
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.") +
  theme_excel()


# theme_stata()
cemabe_df %>% 
  filter(P166 < 4000 & P167 < 4000) %>% 
  mutate(nivel_texto = case_when(NIVEL == 2 ~ "Preescolar", NIVEL == 3 ~ "Primaria", NIVEL == 4 ~ "Secundaria", NIVEL == 7 ~ "CAM", NIVEL == 8 ~ "Otro")) %>% 
  ggplot() +
  geom_point(mapping = aes(x = P167, y = P166, colour = nivel_texto, size = P313), alpha = 0.3) +
  labs(title = "Capacidad instalada y atención real",
       subtitle = "Esta gráfica muestra...",
       x = "Alumnos que podrían atenderse en el centro de trabajo",
       y = "Alumnos inscritos en el centro de trabajo",
       colour = "Nivel escolar",
       size = "Núm. maestros",
       caption = "Fuente: elaboración propia con datos del CEMABE.") +
  theme_stata()