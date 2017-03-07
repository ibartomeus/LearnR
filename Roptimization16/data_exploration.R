#Este script carga diversos datasets como base para ver diferentes funciones en R.

#Ejercició 1: Carga el dataset "extinction" en la carpeta "data" y haz un analysis explorativo----

#read data

#explore data

#preliminar analysis


#Manipulación de datos----

#load 2 datasets, check them, make summary statistics of one and merge

#sites data:
sites <- read.csv("data/bumblebee_sites.csv", h=T)
#Force 1 row per site by doing mean of landscape.


#occurrence data:
occ <- read.csv("data/bumblebees.csv", h=T)

#fix species

#remove unresolved species

#Get plant genus! #grep y substr


#merge


# Ejercicio dplyr----
# usar pipes (this is not a %>% )

#vamos jugar a las peliculas y crear 50 sobras de grey.
?grey
grey(c(0.1,0.3,0.4))

#crea una función llamada sombras que te de n numeros sequenciales entre 0 y 1
sombras <- function(){
}

#calcula 50 sobras de grey: grey, sombras

#Ahora vamos a ver como se escribiria siguiendo la sintaxis dpyr
#install.packages("dplyr")
library(dplyr)
#shift cmd M

#otros ejemplos:
#calcular sobre los abejorros:
#max temperatura por especie

#familia apply()
?tapply
#Calcula maxima temperatura a la que has capturado una especie.

# aggregate es lento y poco flexible

#dplyr

# dplyr como sintaxis
# Verbos
#* `filter()` - subset rows; like `base::subset()`
#* `arrange()` - reorder rows; like `order()`
#* `select()` - select columns
#* `mutate()` - add new columns
#* `summarise()` - like `aggregate`

#otros ejemplos:
install.packages("babynames")
library(babynames)

head(babynames)
babynames

#familia apply()
?tapply

# aggregate es lento y poco flexible

#dplyr


#Exercise 2: #debug this function-----
#learn how to debug, split in pieces the problem, seacrh in stack overflow,
  #learn that diferent fixes are always available

source(file = "misc/function.R")
#the function count_numbers will count how many times a given number appears
#has the following arguments:
#number: the number to search for
#vector: the vector where to search the number
#match: TRUE: return the number of matched numbers, FALSE return the number not matched numbres
x <- c(1, NA, 3, 2, 4, 2)

count_numbers(number = 2, vector = x, match = TRUE) 
count_numbers(number = 5, vector = x, match = TRUE) 
count_numbers(number = 2, vector = x, match = FALSE) 
count_numbers(number = 5, vector = x, match = FALSE) 

fixed_count_numbers <- function(){
}

fixed_count_numbers(number = 2, vector = x, match = TRUE) #right!
fixed_count_numbers(number = 5, vector = x, match = TRUE) #right!
fixed_count_numbers(number = 2, vector = x, match = FALSE) #right?
fixed_count_numbers(number = 5, vector = x, match = FALSE) #wrong!!

