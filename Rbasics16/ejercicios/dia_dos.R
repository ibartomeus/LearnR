#Este script usa datos de pelis de James Bond para explorarlos y hacer algún gráfico.

#leer datos en R----
#lee datos de peliculas de James Bond en la carpeta datos con 
  #la función read.table o read.csv
bond <- read.csv("Rbasics/ejercicios/data/007.csv")
bond <- read.table("Rbasics/ejercicios/data/007.csv", header = TRUE, sep = ",") #idem

#No explico attach(), por que mejor no lo usamos, ya que presta a errores.

#explorar los datos (str, head)
str(bond) # nueva estructura de datos: data.frame!
head(bond)
#facors (levels)
levels(bond$Actors)

#limpiar datos (colnames)
colnames(bond)
#eliminar la ultima columna: indexar y subset
bond2 <- bond[,-35]
bond2 <- bond[,-"Response"] #idem
bond2 <- subset(bond, select = -Response) #idem
#subset
bond[which(bond$Year > 2000),]
subset(bond, Year > 2000) #idem

#rescatar actor principal #grep y substr
position <- regexpr(pattern = ",", bond$Actor)
bond$Actor_p <- substr(bond$Actor, 1, position-1)
#hacer lo mismo con Runtime

#guardar datos (write.table, write.csv & save)
write.table(bond, "Rbasics/ejercicios/data/007_edited.csv")
write.csv(bond, "Rbasics/ejercicios/data/007_edited.csv") #idem depende de los parametros
save(bond, file = "Rbasics/ejercicios/data/bond.R") #Rdata
rm(bond) #elimina un objeto
load("Rbasics/ejercicios/data/bond.R")
  
# Crear funciones-----

# Funciones que necesitaremos SE
hello <- function(){print("hello world")}
hello()
# Ahora programa el error estandard
se <- function(x){sd(x)/sqrt(length(x))}
se(c(3,4,6,4))

#Plots----
#boxplot de imdbRating
boxplot(bond$imdbRating)

# y lo ponemos bonito
boxplot(bond$imdbRating, las = 1, main = "IMDB rating")
# añadimos tomatoUserRating (ojo escala 1-5)
boxplot(bond$imdbRating, bond$tomatoUserRating*2, las = 1, names = c("IMDB", "Tomatoes"),
        main = "Rating", ylim = c(0,10))
abline(h = 5, lty = 2)

#boxplots esconden cosas
boxplot(bond$imdbRating, las = 1, main = "IMDB rating", cex = 0)
#añadimos media (points)
points(mean(bond$imdbRating), pch = 19, col = "red")
#y datos reales (usa la función jitter)
points(jitter(rep(1, length(bond$imdbRating)), 4), bond$imdbRating)

# Que opina la gente de imdbRating? plot y scatter.smooth
plot(bond$Year, bond$imdbRating)
scatter.smooth(bond$Year, bond$imdbRating)
# Y que opina la citica tomatoRotten #https://en.wikipedia.org/wiki/Rotten_Tomatoes
plot(bond$Year, bond$tomatoRotten)
#más intuitivo si 100 fuera 0?
plot(bond$Year, 100 - bond$tomatoRotten)
scatter.smooth(bond$Year, 100 - bond$tomatoRotten)

# R puede hacer pie charts, pero no los useis
#pie()

#barplots (tampoco los useis mucho, pero a veces son útiles)
?barplot
#definir mean y ordenarlo decreciente (sort)
mean_ratings <- tapply(bond$imdbRating, bond$Actor_p, mean)
mean_ratings <- sort(mean_ratings, decreasing = TRUE)
bp <- barplot(mean_ratings, las = 1, ylim = c(0,10))
#añadimos SE
se_ratings <- tapply(bond$imdbRating, bond$Actor_p, se)
#ordenar igual (indexing)
se_ratings <- se_ratings[names(sort(mean_ratings, decreasing = TRUE))]
#añadir barras (arrows)
arrows(x0 = bp,
       x1 = bp,
       y0 = mean_ratings - se_ratings,
       y1 = mean_ratings + se_ratings,
       las = 1, angle = 90, code = 3)


# resumen de una variable (summary y table)
summary(bond$Year)

table(bond$Year, bond$Actor_p)









