#Es bueno describir que contiene tu script. 
#Este sera una introducción al lenguaje de programación R

#para empezar------

#las almohadillas son comentarios
#los comentarios explican "por que" haces algo, no lo que haces.

#vamos a usar R como una calculadora. suma dos numeros:


#guarda el valor (<- atajo de teclado: "alt-"):


# usa x (mira en environment)

#entre parasentesis, te muestra el resultado en la consola


# R tiene muchas funciones de serie (e.g. logaritmo)
#nombre de función(argumentos); #usa el tab para ver argumentos!

# Pedir ayuda
?log

# tipos de datos----

x <- 3.14     # numeric
y <- "hello"  # character
z <- TRUE     # logical

# Y si dudamos que estructura tienen nuestros datos?
str(z)

# tipos de objetos de datos: vectores

#4 formas de escribir el mismo vector

#teclea my y tab para autocompletar

# crear vectores: seq y rep

# operar con vectores (c, log y sum)

# ojo, R recicla valores
1:5 * 1:15 #util, pero peligroso
1:5 + 1:4

#data no available
myvector <- c(1, , 3, 4, 5) #fails
myvector <- c(1, NA, 3, 4, 5)
# R reconoce los NA's! (is.na)


# pero las funcionen pueden fallar cuando hay NA's (sum)


#Otros: NAN, NULL Inf...NA puede ser evaluado por funciones NULL no.

# preguntando a R (which)
which(is.na(myvector)) # == TRUE
which(myvector == 3)

# subsetting / indexing []

# matrices
#fijate que aquí reciclamos el vector!

#index

#lists
l <- list(m, myvector)
#indexar listas

# arrays (n-dimensional matrices..)
# data.frames? mañana...

#distribuciones-----

#R te permite crear distribuciones (runif i rnorm)


#hist mean y sd


