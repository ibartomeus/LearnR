#this script will use simulations to learn loops and other tricks

#Simulate data----

#a random variable
x <- rnorm(100, mean = 5, sd = 2)
hist(x)
x <- rpois(100, lambda = 2)
hist(x)

#a uniform variable
x <- runif(100, min = 2, max = 5)
hist(x)

#Elements of a simulation:
#1) an object to store the outputs
#2) outputs

#dynai¡mics of a simulation.
#1) create an object to store the outputs
#2) create 1 set of values
#3) store them
#4) repeat 2) and 3) as needed.

#species abundances
#starting point: a lognormal distribution 
x <- rlnorm(10, 5, 1)
hist(x)
x <- round(x)
#create a dataframe to store data
out <- data.frame(species = 1:10,
                  abundance_t = x)
#simulate 1 years of data assuming t+1 = t + error (normally distributed)
abundance_t1 <- out[,2] + rnorm(1, 2, 1) 
out <- cbind(out, abundance_t1)
#simulate 100 years now
for(i in 1:100){
 abundance <- out[,i+1] + rnorm(1, 2, 1) 
 out <- cbind(out, abundance)
}
#plot one species trajectory
plot(as.numeric(out[1,-1]) ~ c(1:101), t = "l", ylim = c(min(out), max(out)))
for(i in 2:nrow(out)){
  lines(as.numeric(out[i,-1]) ~ c(1:101), col = i)
}

#make a function out of it
sim <- function(mean, sd){
  x <- rlnorm(10, 5, 1)
  out <- data.frame(species = 1:10,
                    abundance_t = x)
  for(i in 1:100){
    abundance <- out[,i+1] + rnorm(1, mean, sd) 
    out <- cbind(out, abundance)
  }
  plot(as.numeric(out[1,-1]) ~ c(1:101), t = "l", ylim = c(min(out), max(out)))
  for(i in 2:nrow(out)){
    lines(as.numeric(out[i,-1]) ~ c(1:101), col = i)
  }
}

sim(mean = 0, sd = 10)

#simulate independent errors for each species now
sim <- function(mean, sd){
  x <- rlnorm(10, 5, 1)
  out <- data.frame(species = 1:10,
                    abundance_t = x)
  for(i in 1:100){
    abundance <- out[,i+1] + rnorm(10, mean, sd) 
    out <- cbind(out, abundance)
  }
  plot(as.numeric(out[1,-1]) ~ c(1:101), t = "l", ylim = c(min(out), max(out)))
  abline(h = 0)
  for(i in 2:nrow(out)){
    lines(as.numeric(out[i,-1]) ~ c(1:101), col = i)
  }
}

sim(mean = 0, sd = 10)

#Allow extinctions
sim <- function(mean, sd){
  x <- rlnorm(10, 5, 1)
  out <- data.frame(species = 1:10,
                    abundance_t = x)
  for(i in 1:100){
    abundance <- out[,i+1] + rnorm(10, mean, sd) 
    if(any(abundance < 0)){
      print("species went extinct")
      abundance <- ifelse(abundance < 0, 0, abundance)
    } 
    out <- cbind(out, abundance)
  }
  plot(as.numeric(out[1,-1]) ~ c(1:101), t = "l", ylim = c(min(out), max(out)))
  abline(h = 0)
  for(i in 2:nrow(out)){
    lines(as.numeric(out[i,-1]) ~ c(1:101), col = i)
  }
  out
}

sim(mean = 0, sd = 10)

#A word of caution, never do significant tests in simulations!