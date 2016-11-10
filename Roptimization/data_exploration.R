#Data exploration

#Read this dataset and explore it.-----

#read data
dat <- read.csv("Roptimization/data/extinction.csv", h = TRUE)

head(dat)
str(dat)
summary(dat)
hist(dat$body_size)
hist(dat$extinction_risck)
cor.test(dat$extinction_risck, dat$body_size)
m <- lm(dat$extinction_risck ~ dat$body_size)
summary(m)
plot(dat$extinction_risck ~ dat$body_size)
abline(m)
plot(m)
scatter.smooth(dat$extinction_risck ~ dat$body_size)

#take home message. Always plot your data

#Add example ascombe quartet?

#Optimizando el uso de R: 
#Rstudio, subsetting, loops, if, funciones, 
#vectorización (familia apply), tidyr y dplyr, joins, reshape, merge

#rescatar actor principal #grep y substr
position <- regexpr(pattern = ",", bond$Actor)
bond$Actor_p <- substr(bond$Actor, 1, position-1)
#hacer lo mismo con Runtime

#Este script juega con ggplot2, reshape2 y dplyr

# Ejercicio dplyr----
# usar pipes (this is not a %>% )

#vamos a cambiar de pelicula y crear 50 sobras de grey.
?grey
#crea una función llamada sombras que te de n numeros sequenciales entre 0 y 1
sombras <- function(n){
  seq(0,1, length.out = n)  
}

#calcula 50 sobras de grey: grey, sombras
grey(sombras(50))

#Ahora vamos a ver como se escribiria siguiendo la sintaxis dpyr
#install.packages("dplyr")
library(dplyr)
50 %>%  sombras %>% grey #shift cmd M

tapply(bond$tomatoRotten, bond$Actor_p, max)

# aggregate es lento y poco flexible
aggregate(tomatoRotten ~ Actor_p, 
          data = bond, FUN = max)

# dplyr como sintaxis
# Verbos
#* `filter()` - subset rows; like `base::subset()`
#* `arrange()` - reorder rows; like `order()`
#* `select()` - select columns
#* `mutate()` - add new columns
#* `summarise()` - like `aggregate`

#Grouping
bond %>% 
  group_by(Actor_p) %>% 
  summarise(max(tomatoRotten))

#por si quereis practicar con otro dataset interesante
install.packages("babynames")
library(babynames)
babynames %>% group_by(year, sex)


#debug this function----
#learn how to debug, split in pieces the problem, seacrh in stack overflow, learn diferent fixes are always available

#make one of those cases when drop = FALSE is needed.

x <- c(1, NA, 3, 2, 4, 2)

count_numbers <- function(number, vector = x, match = TRUE){
  if(match) y <- x[x == number]
  if(!match) y <- x[x != number]
  length(y)
}
  
count_numbers(number = 2, vector = x, match = TRUE) #wrong
count_numbers(number = 5, vector = x, match = TRUE) #wrong
count_numbers(number = 2, vector = x, match = FALSE) #right?
count_numbers(number = 5, vector = x, match = FALSE) #right?

fixed_count_numbers <- function(number, vector = x, match = TRUE){
  if(match) y <- x[which(x == number)]
  if(!match) y <- x[-which(x == number)]
  length(y)
}

fixed_count_numbers(number = 2, vector = x, match = TRUE) #right!
fixed_count_numbers(number = 5, vector = x, match = TRUE) #right!
fixed_count_numbers(number = 2, vector = x, match = FALSE) #right?
fixed_count_numbers(number = 5, vector = x, match = FALSE) #wrong!!

fixed_count_numbers2 <- function(number, vector = x, match = TRUE){
  if(match) y <- x[which(x == number)]
  if(!match) y <- x[!(x %in% number)]
  length(y)
}

fixed_count_numbers2(number = 2, vector = x, match = TRUE) #right!
fixed_count_numbers2(number = 5, vector = x, match = TRUE) #right!
fixed_count_numbers2(number = 2, vector = x, match = FALSE) #right?
fixed_count_numbers2(number = 5, vector = x, match = FALSE) #right?
