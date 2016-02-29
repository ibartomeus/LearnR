#Este script usa datos de pelis de James Bond para explorarlos y hacer algún gráfico.

#leer datos en R----
#lee datos de peliculas de James Bond en la carpeta datos con 
  #la función read.table o read.csv

#No explico attach(), por que mejor no lo usamos, ya que presta a errores.

#explorar los datos (str, head)
# nueva estructura de datos: data.frame!

#facors (levels)


#limpiar datos (colnames)

#eliminar la ultima columna: indexar y subset

#subset vs indexar: selecciona las pelis desde el año 2000


#rescatar actor principal grep (regexpr) y substr
#Selecionar el Actor principal (Actor_p)

#hacer lo mismo con Runtime

#guardar datos (write.table, write.csv & save)

rm(bond) #elimina un objeto
load("Rbasics/ejercicios/data/bond.R")
  
# Crear funciones-----

# Funciones que necesitaremos SE
#hello world

# Ahora programa el error estandard

#Plots----
#boxplot de imdbRating


# y lo ponemos bonito (las y main)

# añadimos tomatoUserRating (ojo escala 1-5): abline, lty

#boxplots esconden cosas
boxplot(bond$imdbRating, las = 1, main = "IMDB rating", cex = 0)
#añadimos media (points)

#y datos reales (usa la función jitter)

# Que opina la gente de imdbRating? plot y scatter.smooth

# Y que opina la citica tomatoRotten #https://en.wikipedia.org/wiki/Rotten_Tomatoes

#más intuitivo si 100 fuera 0?

# R puede hacer pie charts, pero no los useis
#pie()

#barplots (tampoco los useis mucho, pero a veces son útiles)
?barplot
#definir mean (tapply) y ordenarlo decreciente (sort)


#barplot (guarda el output)
bp <- barplot(mean_ratings, las = 1, ylim = c(0,10))
#añadimos SE (tapply otra vez)

#ordenar igual (indexing basado en los names de las madias)

#añadir barras (arrows)
arrows(x0 = bp,
       x1 = bp,
       y0 = ????,
       y1 = ????,
       las = 1, angle = 90, code = 3)


# resumen de una variable (summary y table): e.g. Año y Actor_p









