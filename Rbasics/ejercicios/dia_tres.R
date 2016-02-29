#Este script explora modelos lineares, loops y funciones más complejas


# Primero cargamos los datos que cremos ayer (load)
load("Rbasics/ejercicios/data/bond.R")

# Y volvemos a visualizar las críticas en función del año
plot(bond$Year, bond$tomatoRotten)

#funciones base lm (formula)
m <- lm(bond$tomatoRotten ~ bond$Year * bond$Actor_p)
summary(m)
table(bond$Actor_p)
levels(bond$Actor_p)
bond$Actor_p2 <- as.factor(bond$Actor_p)
levels(bond$Actor_p2)[2] <- "other"
levels(bond$Actor_p2)[6] <- "other"

m <- lm(bond$tomatoRotten ~ bond$Year * bond$Actor_p2) #pensar en ello!
summary(m)
anova(m)
plot(m)
plot(bond$Year, bond$tomatoRotten, col = bond$Actor_p2)

#paquetes en CRAN
#install.packages("car")
library(car)
#tipo I (por defecto, factores entran secuanciales)
m <- lm(bond$tomatoRotten ~ bond$Actor_p2 * bond$Year)
anova(m)
Anova(m, type = "II") #tipo 2, los factores se evaluan a la vez
Anova(m, type = "III") #tipo tres, recomendado cuando hay interacciones.

#en este caso, podemos simplificar el modelo
m <- lm(bond$tomatoRotten ~ bond$Year)
summary(m)
anova(m)
plot(m)
plot(bond$Year, bond$tomatoRotten, col = bond$Actor_p2, las = 1, 
     ylab = "Rotten tomatoes", xlab = "Year of release", main = "007")
abline(m)



#Ahora vamos a ver como consegui los datos de James Bond
#paquetes in otros repositorios (e.g. github)
install.packages("devtools")
library(devtools)
install_github("ibartomeus/omdbapi")
# Asi es como construi los datos de James Bond
library(omdbapi)
library(dplyr)

#hacer función para bajar pelis 

#primero un poco de background (for's y if's)
if(sum(1:4) == 10) {
  print("right!")
} else {
  print("wrong!")
}

for(i in 1:4) { print(i) }

#funciones 

search_by_title("Batman", page = i)

#todas las pelis de James Bond:
titles <- c("Dr. No",
            "From Russia with Love",
            "Goldfinger",
            "Thunderball",
            "You Only Live Twice",
            "On Her Majesty's Secret Service",
            "Diamonds Are Forever",
            "Live and Let Die",
            "The Man with the Golden Gun",
            "The Spy Who Loved Me",
            "Moonraker",
            "For Your Eyes Only",
            "Octopussy",
            "A View to a Kill",
            "The Living Daylights",
            "Licence to Kill",
            "GoldenEye",
            "Tomorrow Never Dies",
            "The World Is Not Enough",
            "Die Another Day",
            "Casino Royale",
            "Quantum of Solace",
            "Skyfall",
            "Spectre")


#Primero vamos a buscar una

#search_by_title()
temp <- search_by_title(titles[1])
temp <- temp[1,]
#ID_download() baja toda la información para una serie de ID's.
source("Rbasics/utils/ID_download.R")
all <- ID_download(temp$imdbID)
all$Year <- as.numeric(all$Year)
all <- as.data.frame(all)

#ahora todas (for)
ids <- data.frame()
for(i in 1:length(titles)){
  temp <- as.data.frame(search_by_title(titles[i]))
  ids <- rbind(ids, temp[1,])
}
all <- ID_download(ids$imdbID)
all$Year <- as.numeric(all$Year)
all <- as.data.frame(all)


#Finalmente, lo funcionalizamos
get_list <- function(qlist){
ids <- data.frame()
for(i in 1:length(qlist)){
  temp <- as.data.frame(search_by_title(qlist[i]))
  ids <- rbind(ids, temp[1,])
}
#filter
ids2 <- subset(ids, Type == "movie" ,select = -Poster)
#get all
all <- ID_download(ids2$imdbID)
all$Year <- as.numeric(all$Year)
all <- as.data.frame(all)
all
}

jb <- get_list(titles)
head(jb)
#write.csv(jb, "Rbasics/ejercicios/data/007.csv", row.names = FALSE)

#Ahora ya puedes buscar las pelis que quieras por titulo!

#Apendice: otro ejemplo con batman----

#batman ( o hatty potter o alien) da muchas paginas de resultados. 
#Creamos una funcion para pillarlos todos.
get_all <- function(query, limit = 10){
  ids <- data.frame()
  x = 0
  i = 1
  while(x < 1){
    temp <- as.data.frame(search_by_title(query, page = i))
    if(length(temp) == 0){x = 1}
    ids <- rbind(ids, temp)
    i = i + 1
    if (i == limit) break
    print(i)
  }
  #filter
  ids2 <- subset(ids, Type == "movie" ,select = -Poster)
  #get all
  all <- ID_download(ids2$imdbID)
}

batman <- get_all("Batman")

