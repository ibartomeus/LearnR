#This script plays with null models as a way to practice more loops.

#A simple null model used to test correlations----

#The data
abundance <- c(1,3,4,7,8,13)
body_size <- c(9,6,3,3,1,1)
plot(abundance ~ body_size)
corr <- cor(abundance,body_size)
cor.test(abundance,body_size)

#The null model: 
#idea: Brake all procesess except for the proces of interest and compare the 
#observed with the expected data.

#In this case we want to test if this correlation may be due to randomness.
#We brake then the "body_size" process and left only randomness. use `sample()`

cor(sample(body_size, size = length(body_size), replace = FALSE), abundance)

#we do it 1000 times
cor_dis <- c()
for (k in 1:1000){
  cor_dis[k] <- cor(sample(body_size, size = length(body_size), replace = FALSE), abundance)
}

#plot
hist(cor_dis)
lines(c(corr, corr), c(0,200), col = "red")

#test p-value
(p <- pnorm(corr, mean = mean(cor_dis), sd = sd(cor_dis)))


#Another example----
#We observe a pattern: How uneven are abundance distributions?
abundance <- c(1,3,4,7,8,13)
#calculate pielou's evenees (shannon/logarithm of number of species)
#Shannon The proportion of species i relative to the total number of species 
#(pi) is calculated, and then multiplied by the natural logarithm of 
#this proportion (lnpi). The resulting product is summed across species, 
#and multiplied by -1:
p <- abundance/sum(abundance)
S <- -sum(p * log(p))
J <- S/log(length(abundance))
#is this eveness higher than expected?
#calculate evenness of a random assembly
#tip: we need to sample 36 individuals and assign them a species randomly
#then, we can group per species.
rand <- sample(c(1:6), sum(abundance), replace = TRUE)
abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
#Calculate J of the simulated community
p2 <- abundance2/sum(abundance2)
S2 <- sum(-p2 * log(p2+0.001))
J2 <- S2/log(length(abundance2))
# now make it 1000 times
out <- c()
for(i in 1:100){
  rand <- sample(c(1:6), 36, replace = TRUE)
  abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
  p2 <- abundance2/sum(abundance2)
  S2 <- sum(-p2 * log(p2+0.001))
  J2 <- S2/log(length(abundance2))
  out <- c(out, J2)
}
#calculate p-value
hist(out)
lines(c(J, J), c(0,20), col = "red")
(p <- pnorm(J, mean = mean(out, na.rm = TRUE), sd = sd(out, na.rm = TRUE)))

#null model 2. 
#We want to test now if body size is driving the eveness patterns.
#we create a null model where body_size is the only responsible of the 
#observed pattern
abundance <- c(1,3,4,7,8,13)
body_size <- c(9,6,5,3,2,1)
#Do one iteration
sample(c(1:6), 36, replace = TRUE, prob = body_size)
# make a loop
out_bs <- c()
for(i in 1:1000){
  rand <- sample(c(1:6), 36, replace = TRUE, prob = body_size)
  abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
  p2 <- abundance2/sum(abundance2)
  S2 <- sum(-p2 * log(p2+0.001))
  J2 <- S2/log(length(abundance2))
  out <- c(out, J2)
  out_bs <- c(out_bs, J2)
}
#And test significance
hist(out_bs)
lines(c(J, J), c(0,400), col = "red")
(p <- pnorm(J, mean = mean(out_bs), sd = sd(out_bs)))
(p <- 1- pnorm(J, mean = mean(out_bs), sd = sd(out_bs)))


#Other implmented null models in R
library(vegan)
library(bipartite)

#vegan example
## Use quantitative null models to compare
## mean Bray-Curtis dissimilarities
data(dune)
meandist <- function(x) mean(vegdist(x, "bray"))
mbc1 <- oecosimu(dune, meandist, "r2dtable")
mbc1


#bipartite example
data(Safariland)
head(Safariland)
nullmodel(Safariland, N=2, method=1)
nullmodel(Safariland>0, N=2, method=4)
# analysis example:
obs <- unlist(networklevel(Safariland, index="weighted nestedness"))
nulls <- nullmodel(Safariland, N=100, method=1)
null <- unlist(sapply(nulls, networklevel, index="weighted nestedness")) #takes a while ...

plot(density(null), xlim=c(min(obs, min(null)), max(obs, max(null))), 
     main="comparison of observed with null model Patefield")
abline(v=obs, col="red", lwd=2)    

praw <- sum(null>obs) / length(null)
ifelse(praw > 0.5, 1-praw, praw)    # P-value



#further reading:

#neutral model Hubell: http://artax.karlin.mff.cuni.cz/r-help/library/untb/html/expected.abundance.html
#EcoSIm: http://www.uvm.edu/~ngotelli/EcoSim/Niche%20Overlap%20Tutorial.html
#vegan: http://cc.oulu.fi/~jarioksa/softhelp/vegan/html/oecosimu.html