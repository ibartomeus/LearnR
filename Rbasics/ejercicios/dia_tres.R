#get data for day 2

library(devtools)
install_github("ibartomeus/omdbapi")
library(omdbapi)
library(dplyr)
library(pbapply)
#library(httr)

batman <- data.frame()
x = 0
i = 1
while(x < 1){
  temp <- as.data.frame(search_by_title("Batman", page = i))
  if(length(temp) == 0){x = 1}
  batman <- rbind(batman, temp)
  i = i + 1
  print(i)
}
search_by_title("Batman", page = 1)
search_by_title("Batman", page = 2)
search_by_title("Batman", page = 28)
search_by_title("Batman", page = 29)

#filter
batman2 <- subset(batman, Type == "movie" ,select = -Poster)
head(batman2)
batman2
max(batman2$Year)
min(batman2$Year)

#?bind_rows
allbatman <- bind_rows(lapply(batman2$imdbID, function(x) {
  find_by_id(x, include_tomatoes = TRUE)
}))

head(allbatman)

#x <-  find_by_id(batman$imdbID[1], include_tomatoes = TRUE)
#str(x)

boxplot(allbatman$tomatoUserMeter, horizontal=TRUE, main="Tomato User Meter", ylim=c(0, 100))
boxplot(allbatman$imdbRating, horizontal=TRUE, main="IMDB Rating", ylim=c(0, 10))
boxplot(allbatman$tomatoUserRating, horizontal=TRUE, main="Tomato User Rating", ylim=c(0, 5))

plot(allbatman$Year, allbatman$tomatoUserMeter)


#James bond
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
  all <- bind_rows(lapply(ids2$imdbID, function(x) {
    find_by_id(x, include_tomatoes = TRUE)
  }))
}

jb <- get_all("James Bond")

head(jb)

as.data.frame(jb[,c(1,2,5,6,13,16)])

boxplot(jb$tomatoUserMeter, horizontal=TRUE, main="Tomato User Meter", ylim=c(0, 100))
boxplot(jb$imdbRating, horizontal=TRUE, main="IMDB Rating", ylim=c(0, 10))
boxplot(jb$tomatoUserRating, horizontal=TRUE, main="Tomato User Rating", ylim=c(0, 5))

jb$Year <- as.numeric(jb$Year)
plot(jb$Year, jb$imdbRating)
abline(lm(jb$imdbRating ~ jb$Year))
summary(lm(jb$imdbRating ~ jb$Year))



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

#qlist <- titles #to debug
get_list <- function(qlist){
ids <- data.frame()
for(i in 1:length(qlist)){
  temp <- as.data.frame(search_by_title(qlist[i]))
  ids <- rbind(ids, temp[1,])
}
#filter
ids2 <- subset(ids, Type == "movie" ,select = -Poster)
#get all
all <- bind_rows(lapply(ids2$imdbID, function(x) {
  find_by_id(x, include_tomatoes = TRUE)
}))
}

jb <- get_list(titles)
as.data.frame(jb)
jb$Year <- as.numeric(jb$Year)
plot(jb$Year, jb$imdbRating)
plot(jb$Year, jb$tomatoMeter)
plot(jb$Year, jb$tomatoUserRating)
plot(jb$Year, jb$tomatoRotten)
#https://en.wikipedia.org/wiki/Rotten_Tomatoes
plot(jb$imdbRating,jb$tomatoMeter)
abline(lm(jb$imdbRating ~ jb$Year))
summary(lm(jb$imdbRating ~ jb$Year))
scatter.smooth(jb$Year, jb$imdbRating)


Things you should know: control flow
========================================================
  
  - Basic  *control flow* statements

```{r}
if(sum(1:4) == 10) {
  print("right!")
} else {
  print("wrong!")
}
```

```{r}
for(i in 1:4) { cat(i) }
```


Things you should know: packages
========================================================
  
  - *Packages* are pieces of software that can be loaded into R. There are thousands, for all kinds of tasks and needs.

```{r, eval=FALSE}
# The single most popular package is `ggplot2`
library(ggplot2)

# qplot = quick plot
qplot(speed, 
      dist, 
      data = cars)
```

***
  
  ```{r, echo=FALSE}
library(ggplot2)
theme_set(theme_bw())
qplot(speed, dist, data=cars)
```
