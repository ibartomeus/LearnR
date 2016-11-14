#Este script carga diversos datasets como base para ver diferentes funciones en R.

#Ejercició 1: Carga el dataset "extinction" en la carpeta "data" y haz un analysis explorativo----

#read data
dat <- read.csv("data/extinction.csv", h = TRUE)

#explore data
head(dat)
str(dat)
summary(dat)
hist(dat$body_size)
hist(dat$extinction_risck)

#preliminar analysis
cor.test(dat$extinction_risck, dat$body_size)
m <- lm(dat$extinction_risck ~ dat$body_size)
summary(m)
plot(dat$extinction_risck ~ dat$body_size)
abline(m)
plot(m)
scatter.smooth(dat$extinction_risck ~ dat$body_size)

#take home message. Always plot your data

#Manipulación de datos----

#load 2 datasets, check them, make summary statistics of one and merge

#sites data:
sites <- read.csv("data/bumblebee_sites.csv", h=T)
str(sites)
head(sites)
#we need unique sites
unique(sites$Site)
#reshape package
#install.packages("reshape2")
library(reshape2)
sites2 <- dcast(data = sites, formula = Site + Corridor ~ . , fun.aggregate = mean, value.var = "landscape")
sites2
colnames(sites2)[3] <- "landscpae"
sites2

#occurrence data:
occ <- read.csv("data/bumblebees.csv", h=T)
head(occ)
#fix species
table(occ$Gen_sp)
levels(occ$Gen_sp)[20] <- "Bombus_terrestris"
levels(occ$Gen_sp)[which(occ$Gen_sp == "Bombus_terrestre")] <- "Bombus_terrestris"
#remove species
occ2 <- subset(occ, !Gen_sp %in% c("Bombus_spp", "Bombus_spp."))

head(occ)
#Get plant genus! #grep y substr
position <- regexpr(pattern = "_", occ2$Flower_species)
occ2$plant_genus <- substr(occ2$Flower_species, 1, position-1)
#joins, reshape, merge

dat <- merge(occ2, sites2, by = "Site", all = TRUE)
str(occ2)
str(sites2)
str(dat)
head(dat)

# Ejercicio dplyr----
# usar pipes (this is not a %>% )

#vamos jugar a las peliculas y crear 50 sobras de grey.
?grey
grey(c(0.1,0.3,0.4))

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

#otros ejemplos:
#calcular sobre los abejorros:
#max temperatura por especie

#familia apply()
?tapply
tapply(dat$Highest_temp, dat$Gen_sp, max)
dat <- droplevels(dat)
tapply(dat$Highest_temp, dat$Gen_sp, max)

# aggregate es lento y poco flexible
aggregate(Highest_temp ~ Gen_sp, 
          data = dat, FUN = max)

#dplyr
dat %>% group_by(Gen_sp) %>% summarize(a = mean(Highest_temp))

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

babynamesdf <- as.data.frame(babynames)
head(babynamesdf)

#familia apply()
?tapply
tapply(babynamesdf$n, babynamesdf$year, max)

# aggregate es lento y poco flexible
aggregate(n ~ year, 
          data = babynamesdf, FUN = max)

#dplyr
babynames %>% group_by(year, sex)

babynames %>% 
  group_by(year, sex) %>% 
  filter(name == "Mary") %>% 
  select(-prop)


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
