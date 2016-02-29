#Este script juega con ggplot2, reshape2 y dplyr

# Ejercicio dplyr----
# usar pipes (this is not a %>% )

#vamos a cambiar de pelicula y crear 50 sobras de grey.
?grey
#crea una función llamada sombras que te de n numeros sequenciales entre 0 y 1


#calcula 50 sobras de grey: grey, sombras


#Ahora vamos a ver como se escribiria siguiendo la sintaxis dpyr
#install.packages("dplyr")
library(dplyr)

# %>% apretando shift cmd M

# volvemos a james bond
load("Rbasics/guia/data/bond.R")

# dplyr tambien nos sirve para agregar datos
# e.g. La peor puntuación de cada actor?

# ya hemos visto la familia de tapply

# aggregate es lento y poco flexible

# dplyr como sintaxis
# Verbos
#* `filter()` - subset rows; like `base::subset()`
#* `arrange()` - reorder rows; like `order()`
#* `select()` - select columns
#* `mutate()` - add new columns
#* `summarise()` - like `aggregate`

#Grouping (group_by + summarise)


#por si quereis practicar con otro dataset interesante
install.packages("babynames")
library(babynames)
babynames %>% group_by(year, sex)


#Merging datasets--------

#tenemos una segunda tabla evaluando cuan guapo es cada actor.
howpretty <- data.frame(Actor_p = unique(bond$Actor_p), 
                        pretty = c("feo", "resulton", "guaperas",
                                   "feo", "resulton", "guaperas"))
howpretty

#merge (funcione base)


#Nota: `dplyr` tiene otras funciones más rápidas y flexibles de merge "join"

#Reshape!-----

# Hay veces que queremos transformar datos y table() se queda corto.
install.packages("reshape2")
library(reshape2)

#Basically, you "melt" data so that each row is a unique id-variable combination. 
#Then you "dcast" the melted data into any shape you would like. 

#Un ejemplo simple donde calculamos el maximo valor de tomatoRotten 
  #para cada combinación de Actor_p y pretty

#melt() crea datos "tidy". Todos vuestros datos habrian de ser tidy.
#ejercicio: hacer bond "tidy" para los rankings
#uno: subset las columnas que nos interesan

#dos: melt


# ggplot2------

#Instalo y cargo el paquete ggplot2
#install.packages("ggplot2")
library(ggplot2)

#Nueva sintaxis
p = ggplot(data=bond, aes(x=Year, y=tomatoRotten)) +  #que quiero representar
      geom_point()                                    #como lo quiero representar
p
summary(p)

# añadir color por variable

# color general


#tamaño y forma 

#podemos añadir estadistica directamente (geom_smooth)

#El sombreado representa el error estandar.
#o con modelo linear (method = "lm")

#y por color!

#Prueba quitar los puntos, o cambiar el tipo de linea...

#Tambien es fácil dividir por paneles (facet_wrap(~ var))


help(facet_wrap)


#para las anotaciones añadimos capas: ggtitle, xlab


#y si no te gusta el tema? theme_bw
ggplot(data=bond, aes(x=Year, y=tomatoRotten)) +  
  geom_point() +
  theme_bw() # Tema predefinido. Cambia algunos valores por defecto (color de fondo, de las fuentes..).

help(theme)

#Y tiene mil geom's
#e.g. histograma
ggplot(data=bond, aes(x=tomatoRotten)) +  
  geom_histogram()

#density
ggplot(data=bond, aes(x=tomatoRotten, color = Actor_p)) +  
  geom_density() + 
  ylim(c(0, 0.10))

#boxplots
ggplot(data=bond, aes(Actor_p,tomatoRotten)) +  
  geom_boxplot()

ggplot(data=bond, aes(Actor_p,tomatoRotten)) +  
  geom_violin()

#guardar graficos

jpeg(filename="007.jpeg",   # Nombre del archivo y extension
     height = 11,
     width = 18,
     res= 200,       # Resolucion
     units = "cm")   # Unidades.
     p           # Grafico
dev.off()            # Cierre del archivo




