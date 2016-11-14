#this script will use null modles to learn loops.

#Simulation

sp <- c("a", "b", "c", "d")
abundance <-  c(23, 28, 13, 2)
efficiency <-  c(8, 13, 2, 17)
#death_prob <- c(0.1,0.3,0.4,0.6)

comp <- c("a", "b")
sp_sim <- sp[which(sp %in% comp)]
abundance_sim <-  abundance[which(sp %in% comp)]
efficiency_sim <-  efficiency[which(sp %in% comp)]
#death_prob_sim <- death_prob[which(sp %in% comp)]
func <- sum(abundance_sim * efficiency_sim)

sim <- function(comp){
  sp_sim <- sp[which(sp %in% comp)]
  abundance_sim <-  abundance[which(sp %in% comp)]
  efficiency_sim <-  efficiency[which(sp %in% comp)]
  #death_prob_sim <- death_prob[which(sp %in% comp)]
  func <- sum(abundance_sim * efficiency_sim)
  #func <- sum(abundance_sim * efficiency_sim) # more coplicated funct
  func
}

sim(comp)


simulation <- function(sp, abundance, efficiency, death_prob){
  func <- sum(abundance * efficiency)
  sp_i <- sp
  abundance_i <- abundance
  efficiency_i <- efficiency
  death_prob_i <- death_prob
  func_out <- func
  for(i in 1:length(sp)){
    to_delete <- sample(sp_i, 1, replace = FALSE, prob = death_prob_i)
    abundance_i <- abundance_i[-which(sp_i == to_delete)]
    efficiency_i <- efficiency_i[-which(sp_i == to_delete)]
    death_prob_i <- death_prob_i[-which(sp_i == to_delete)]
    sp_i <- sp_i[-which(sp_i == to_delete)]
    func_i <- sum(abundance_i * efficiency_i)
    func_out <- c(func_out, func_i)
  }
plot(func_out ~ c(0:length(sp)))
func_out
}

simulation(sp, abundance, efficiency, death_prob)


death_prob <- c(0.6, 0.4, 0.3, 0.1)

#null models
fu <- matrix(ncol = length(sp)+1, nrow = 100)
for(j in 1:100){
  fu[j,] <- simulation(sp, abundance, efficiency, death_prob)
}
fu

plot(colMeans(fu) ~ c(0:length(sp)))




#The data

x <- c(22,19,13,9,5,3,1,1)

out <- c()
for(i in 1:length(x)){
  y <- rep(i,x[i])
  out <- c(out,y)
}
out

