#A simple null model

abundance <- c(1,3,4,7,8,13)
body_size <- c(9,6,3,3,1,1)
plot(abundance ~ body_size)
corr <- cor(abundance,body_size)
cor_dis <- c()
for (k in 1:1000){
  cor_dis[k] <- cor(sample(body_size, size = length(x), replace = FALSE), abundance)
}
hist(cor_dis)
lines(c(corr, corr), c(0,200), col = "red")
(p <- pnorm(corr, mean = mean(cor_dis), sd = sd(cor_dis)))

#Another example
abundance <- c(1,3,4,7,8,13)
p <- abundance/sum(abundance)
S <- sum(-p * log(p))
J <- S/log(length(abundance))
#is this eveness higher than expected?
#calculate evenness of a random assembly
rand <- sample(c(1:6), 36, replace = TRUE)
abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
p2 <- x2/sum(abundance2)
S2 <- sum(-p2 * log(p2+0.001))
J2 <- S2/log(length(abundance2))
#loop
out <- c()
for(i in 1:100){
  rand <- sample(c(1:6), 36, replace = TRUE)
  abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
  p2 <- abundance2/sum(abundance2)
  S2 <- sum(-p2 * log(p2+0.001))
  J2 <- S2/log(length(abundance2))
  out <- c(out, J2)
}

hist(out)
lines(c(J, J), c(0,20), col = "red")
(p <- pnorm(J, mean = mean(out, na.rm = TRUE), sd = sd(out, na.rm = TRUE)))

#null model 2. Body_size
abundance <- c(1,3,4,7,8,13)
body_size <- c(9,6,5,3,2,1)

out_bs <- c()
for(i in 1:1000){
  rand <- sample(c(1:6), 36, replace = TRUE, prob = y)
  abundance2 <- hist(rand, breaks = seq(0,6,1))$counts
  p2 <- abundance2/sum(abundance2)
  S2 <- sum(-p2 * log(p2+0.001))
  J2 <- S2/log(length(abundance2))
  out <- c(out, J2)
  out_bs <- c(out_bs, J2)
}

hist(out_bs)
lines(c(J, J), c(0,250), col = "red")
(p <- pnorm(J, mean = mean(out_bs), sd = sd(out_bs)))
(p <- 1- pnorm(J, mean = mean(out_bs), sd = sd(out_bs)))

library(vegan)
library(bipartite)

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

#vegan example
## Use quantitative null models to compare
## mean Bray-Curtis dissimilarities
data(dune)
meandist <- function(x) mean(vegdist(x, "bray"))
mbc1 <- oecosimu(dune, meandist, "r2dtable")
mbc1

#further reading:

#neutral model Hubell: http://artax.karlin.mff.cuni.cz/r-help/library/untb/html/expected.abundance.html
#EcoSIm: http://www.uvm.edu/~ngotelli/EcoSim/Niche%20Overlap%20Tutorial.html
#vegan: http://cc.oulu.fi/~jarioksa/softhelp/vegan/html/oecosimu.html