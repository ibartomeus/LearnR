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

install.packages("glmmADMB") 
install.packages("R2admb") 
library(nlme)
library(lme4)
library("glmmADMB")
library("R2admb")

fit_zipoiss <- glmmadmb(NCalls~(FoodTreatment+ArrivalTime)*SexParent+ 
                          offset(logBroodSize)+(1|Nest), 
                        data=Owls, 
                        zeroInflation=TRUE, 
                        family="poisson")

Estuaries <- read.csv("data/Estuaries.csv", header = T)
head(Estuaries)

ft.estu <- lmer(Total ~ Modification + (1|Estuary),data = Estuaries, REML=T)
#assumptions:
qqnorm(residuals(ft.estu))
scatter.smooth(residuals(ft.estu)~fitted(ft.estu))

ft.estu <- lmer(Total ~ Modification + (1|Estuary), data=Estuaries, REML=F)
ft.estu.0 <- lmer(Total ~ (1|Estuary), data=Estuaries, REML=F)

summary(ft.estu)

anova(ft.estu.0,ft.estu)
confint(ft.estu)

ModEst <- unique(Estuaries[c("Estuary", "Modification")]) #find which Estuaries are modified
cols <- as.numeric(ModEst[order(ModEst[,1]),2])+3 #Assign colour by modification
boxplot(Total~ Estuary,data=Estuaries,col=cols,xlab="Estuary",ylab="Total invertebrates")
legend("bottomleft", inset=.02,
       c(" Modified "," Pristine "), fill=unique(cols), horiz=TRUE, cex=0.8)
is.mod <- as.numeric(ModEst[order(ModEst[,1]),2])-1 #0 if Modified, 1 if Pristine
Est.means <- coef(ft.estu)$Estuary[,1]+coef(ft.estu)$Estuary[,2]*is.mod #Model means
stripchart(Est.means~ sort(unique(Estuary)),data=Estuaries,pch=18,col="red",vertical = TRUE,add=TRUE)

#Detailed explanation at: http://environmentalcomputing.net/mixed-models-1/

#when data has many zeros:
#binary data:
Estuaries$HydroidPres <- Estuaries$Hydroid > 0
fit.bin <- glmer(HydroidPres ~ Modification + (1|Estuary), family=binomial, data=Estuaries)

par(mfrow=c(1,2))
plot(residuals(fit.bin)~fitted(fit.bin),main="residuals v.s. Fitted")
qqnorm(residuals(fit.bin))

#pval??

fit.pois <- glmer(Hydroid ~ Modification + (1|Estuary) ,family=poisson, data=Estuaries)
par(mfrow=c(1,2))
plot(residuals(fit.pois)~fitted(fit.pois),main="Residuals vs. Fitted")
qqnorm(residuals(fit.pois))

fit.pois2 <- glmer(Schizoporella.errata ~ Modification + (1|Estuary), family=poisson,  data=Estuaries)
par(mfrow=c(1,2))
plot(residuals(fit.pois)~fitted(fit.pois),main="residuals vs. Fitted")
qqnorm(residuals(fit.pois))

#negbin!

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