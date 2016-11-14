#This script introduce to mixed models, specially checking assumptions.

#The data:

#Mixed models assumptions:
#Assumptions. Mixed models make some important assumptions (we’ll check these later for our examples)

#The observed y are independent, conditional on some predictors x
#The response y are normally distributed conditional on some predictors x
#The response y has constant variance, conditional on some predictors x
#There is a straight line relationship between y and the predictors x and random effects z
#Random effects z are independent of y.
#Random effects z are normally distributed

library(nlme)
library(lme4)
library(MASS)

#The data
Estuaries <- read.csv("data/Estuaries.csv", header = T)
head(Estuaries)

ft.estu <- lme(Total ~ Modification, random = ~ 1 |Estuary, data = Estuaries, method = "REML")

ft.estu4 <- lmer(Total ~ Modification + (1|Estuary),data = Estuaries, REML=T)
#assumptions:
qqnorm(residuals(ft.estu))
scatter.smooth(residuals(ft.estu)~fitted(ft.estu))

qqnorm(residuals(ft.estu4))
scatter.smooth(residuals(ft.estu)~fitted(ft.estu4))

summary(ft.estu)
summary(ft.estu4)

intervals(ft.estu)
confint(ft.estu4)

boxplot(Estuaries$Total ~ Estuaries$Modification)

#Detailed explanation at: http://environmentalcomputing.net/mixed-models-1/

#when data do not hold the assumptions:

ft.Hydroid <- lme(Hydroid ~ Modification, random = ~ 1 |Estuary, data = Estuaries, method = "REML")
qqnorm(residuals(ft.Hydroid))
scatter.smooth(residuals(ft.Hydroid)~fitted(ft.Hydroid))
boxplot(Estuaries$Modification, residuals(ft.Hydroid, type = "norm"))

ft.Hydroid <- lme(Hydroid ~ Modification, random = ~ 1 |Estuary, data = Estuaries, method = "REML", weights=varIdent(form=~1|Modification))
qqnorm(residuals(ft.Hydroid, type = "normalized"))
scatter.smooth(residuals(ft.Hydroid, type = "normalized") ~ fitted(ft.Hydroid))

#Plan B:

#binary data:
Estuaries$HydroidPres <- Estuaries$Hydroid > 0

fit.bin <- glmer(HydroidPres ~ Modification + (1|Estuary), family=binomial, data=Estuaries)

#Check for overdispersion
#the ratio of residual deviance to degrees of freedom < 1
plot(residuals(fit.bin)~fitted(fit.bin),main="residuals v.s. Fitted")
qqnorm(residuals(fit.bin))

summary(fit.bin)
boxplot(Estuaries$HydroidPres ~ Estuaries$Modification)

#Poisson

fit.pois <- glmer(Hydroid ~ Modification + (1|Estuary) ,family=poisson, data=Estuaries)
plot(residuals(fit.pois)~fitted(fit.pois),main="Residuals vs. Fitted")
qqnorm(residuals(fit.pois))
#overdispersion!

#Plan C: negbin!

fit.nb <- glmer.nb(Hydroid ~ Modification + (1|Estuary), data=Estuaries)
plot(fit.nb, resid(.) ~ as.numeric(Estuary))# works, as long as data 'dd' is found
summary(fit.nb)

#detailed explnation here:  http://environmentalcomputing.net/mixed-models-3/
  

#This shows how to get the random slopes and CI's for each level in a hierarchical model----

#dataset used
head(iris)

#what we want to investigate
#Is there a general relationship? and how it differs by species
plot(iris$Sepal.Width ~ iris$Petal.Width, col = iris$Species, las =1)

#Our model with random slope and intercept
library(lmer)
m2 <- lmer(data = iris, Sepal.Width ~ Petal.Width + (1 + Petal.Width|Species))
summary(m2)

#extract fixed effects
a=fixef(m2)
a

#extract random effects
b=ranef(m2, condVar=TRUE)
b

# Extract the variances of the random effects
qq <- attr(b[[1]], "postVar") 
qq
e=(sqrt(qq)) 
e=e[2,2,] #here we want to access the Petal.Weigth, which is stored in column 2 in b[[1]].
e

#calculate CI's
liminf=(b[[1]][2]+a[2])-(e*2)
liminf

mean_=(b[[1]][2]+a[2])
mean_

limsup=(b[[1]][2]+a[2])+(e*2)
limsup

#Plot betas and its errors
dotchart(mean_$Petal.Width,
         labels = rownames(mean_), cex = 0.5,
         xlim = c(0.4,1.4),
         xlab = "betas")

#add CI's...
for (i in 1:nrow(mean_)){
  lines(x = c(liminf[i,1], 
              limsup[i,1]), y = c(i,i))    
}

#make final plot
plot(iris$Sepal.Width ~ iris$Petal.Width, col = iris$Species, las = 1)
#and plot each random slope
abline(a = b[[1]][1,1]+a[1], b= mean_$Petal.Width[1], col = "black")
abline(a = b[[1]][2,1]+a[1], b= mean_$Petal.Width[2], col = "red")
abline(a = b[[1]][3,1]+a[1], b= mean_$Petal.Width[3], col = "green")
#and general response
abline(a, lty = 2)



#checking residuals----
#https://cran.r-project.org/web/packages/DHARMa/vignettes/DHARMa.html

install.packages("DHARMa")
library("DHARMa")
simulationOutput <- simulateResiduals(fittedModel = fit.pois, n = 250)
plotSimulatedResiduals(simulationOutput = simulationOutput)
testUniformity(simulationOutput = simulationOutput)
testZeroInflation(simulationOutput)
#with pois2 works!

