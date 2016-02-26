#para empezar------
#esto es un comentario
#los comentarios explican "por que" haces algo, no lo que haces.

#vamos a usar R como una calculadora. suma dos numeros
3 + 3

#guarda el valor (<- "alt-")
x <- 3 + 3
x = 3 + 3

#porque?
##Borra y (si existe)
rm(y)
mean(y=1:10) #[1] 5.5
y #Error: object 'x' not found
#vs.
mean(y <- 1:10)# [1] 5.5
y # [1] 1 2 3 4 5 6 7 8 9 10

# usa x (mira en environment)
x + 2
(x <- x + 2)

# R tiene muchas funciones de serie (e.g. logaritmo)
log(x) #nombre de funcion(argumentos); #usa el tab para ver argumentos!

# Pedir ayuda
?log

# tipos de datos----

x <- 3.14     # numeric
y <- "hello"  # character
z <- TRUE     # logical

# Y si dudamos que estructura tienen nuestros datos?
str(z)

# tipos de objetos de datos: vectores

myvector <- c(1, 2, 3, 4, 5)
myvector <- c(1:5)
myvector <- 1:5
myvector #teclea my y tab para autocompletar

# crear vectores
myvector <- seq(1, 5)
myvector <- rep(1, 5)
myvector

# operar con vectores
myvector * 2
myvector + 2
myvector * myvector
c(myvector, myvector)
log(myvector)
sum(myvector)

# ojo, R recicla valores
1:5 * 1:15 #util, pero peligroso
1:5 + 1:4

# no available
myvector <- c(1, , 3, 4, 5) #fails
myvector <- c(1, NA, 3, 4, 5)
# R reconoce los NA's!
is.na(myvector)
any(is.na(myvector))

# pero las funcionen suelen fallar
x <- c(1, 2, 3, NA)
sum(x) # NA
sum(x, na.rm = TRUE)

#Otros: NAN, NULL Inf

# preguntando a R
which(is.na(myvector)) # == TRUE
which(myvector == 3)


# subsetting / indexing []
myvector[2]
myvector[2:3]
myvector[-2]
myvector[-c(2:3)] #por que? R tiene sus rarezas.
myvector[!is.na(myvector)]

# matrices

(m <- matrix(myvector, nrow = 5, ncol = 2, byrow = FALSE))

#index
m[2,1]
m[,1]

#lists

l <- list(m, myvector)
l[[1]][1,2]

# arrays (n-dimensional matrices..)

#data.frames? mañana...

#distribuciones?

#r y cbind?

