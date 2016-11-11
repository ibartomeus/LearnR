#This script introduce to null models, specially checking assumptions.

#The data:


#Mixed models assumptions:
#Assumptions. Mixed models make some important assumptions (we’ll check these later for our examples)

#The observed y are independent, conditional on some predictors x
#The response y are normally distributed conditional on some predictors x
#The response y has constant variance, conditional on some predictors x
#There is a straight line relationship between y and the predictors x and random effects z
#Random effects z are independent of y.
#Random effects z are normally distributed

library(lme4)

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
  
  
#Quick and dirty notes on General Linear Mix Models-----
Posted on February 24, 2014
My datasets tend to have random factors. I try to stick to general models whenever I can to avoid dealing with both random factors and complex error distributions (not always possible). I am compiling some notes here to avoid visiting the same R-forums every time I work in a new project. Those are some notes to self, but may be they are useful to someone else. Note that those are oversimplified notes, they assume you know your stats and your R and only want a cheat sheet. Also, they may contain errors/discrepancies with your philosophy (please notify me if you find errors, so I can update it!)

Only piece of advice. Plot everything and understand your data.

I’ll designate:
  Response variable –this is what we want to model as y.
Predictors –This is what we think is affecting the response variable as x, z when continuos, and A, B when discrete with levels denoted by A1, A2, etc… 

Models abbreviated as m.

Let’s start assuming normal error distributions:
  
  1) Easy linear model with one predictor:
  
  m <- lm(y ~ x)
  
  then check residuals. You want to see no pattern in the following plot:
    
    scatter.smooth(residuals(m)~fitted(m))
  
  and a straight line here 
  
  qqPlot(residuals(m))
  
  qqline(residuals(m))
  
  more diagnostics here: http://www.statmethods.net/stats/rdiagnostics.html
  
  2) Let’s say you have also a Covariate z

m <- lm(y ~ z + x)

summary(m)

coef(m)

confint(m)

If you want the anova table

anova(m)

But the covariable should be added first because order matters. The result will be the variance explained by x after accounting for the variance due to A (that’s call a Type 1 error)

3) Otherwise what you actually have is not a covariable, but two predictors:
  
  m <- lm(y ~ z + x)
  
  summary(m) #same here
  
  library(car)
  
  Anova(m, Type = "II")
  
  If there is indeed no interaction, then type II is statistically more powerful than type III
  
  If the interaction is significant type III is more appropriate
  
  m <- lm(y ~ z * x)
  
  summary(m)
  
  library(car)
  
  Anova(m, Type = "III")
  
  note: when your design is classic balanced ANOVA design, it doesn’t matter as all types gives you the same answer. More info here: http://mcfromnz.wordpress.com/2011/03/02/anova-type-iiiiii-ss-explained/
    
    To plot interactions:
    
    interaction.plot(A, B, y)
  #only works with A and B factors, so it rarely works for me
  
  Or customize it by discretizing one of the variables (e.g. cut(z)) and fit lines for the two/three levels of z using the coefficients.
  
  UPDATE: use predict for this
  
  newdata <- data
  newdata$z <- 0 #chose a representative low value to fix
  model_pred_lowz <- predict(m, newdata, level = 0) #use level 0 to see         the population level (i.e. not interested in random factors)
  plot(y ~ x)
  lines(x, model_pred_lowz)
  newdata$z <- 1 #chose a high value now
  model_pred_highz <- predict(m, newdata, level = 0)
  lines(x, model_pred_highz)
  
  Also, if you have NA values, use na.exclude, not na.omit in the model, to add NA’s to the residuals.
  
  4) How? By understanding the output, tricky specially when covariate is a factor.

m <- lm(y ~ A * x)

summary(m)

(Intercept) Value is the intercept for A1 (v1)
A2 value (v2) is the difference in the intercept between A1 and A2 (the intercept for A2 is calculated as v1-v2)
x Value is the slope for x given A1 (v3)
x:A2 Value (v4) is the difference in the slope for x between A1 and A2 (the slope of x for A2 is calculated as v3-v4)
5) Select models (by AIC or compare two models anova I know confusing name)

AIC(m)

library(MuMIn)

AICc(m) #for small sample size

anova(m1,m2)

But see below with random factors

6) Until now we wanted to see if there were differences among levels of A.

A included as fixed factor -> “the expectation of the distribution of effects”

lm(x ~ A + z)

But if we want to see if there are general trends regardless of A, but we want to control for the variability due to A. –> “average effect in the population”, we use:
  
  a) random intercept model (we expect the trend to be equal, but some plants will differ on the intercept)
library(nlme)

lme(y ~ x, random = ~1 | A)

b) random slope model (we expect the trend to be dependent on species identity)
lme(y ~ x, random = ~1 + x | A)

In addition, now we can extract the random effects

m$coefficients

fixed and random factors, so we can see the random intercepts (and slopes) as well as

intervals(m)

7) To compare models in nlme

With different radom structures you should use method="REML" as an option. To compare models with different fix effects structure using anova use ML, but give final p-values with REML

8) With complex models you can drege them to find the best ones

library(MuMIn)

m_set = dredge(m_full)

(top_m = get.models(m_set, subset = delta<3))

and compute averages the regular way without shrinkage:
  
  model.avg(top_m)$avg.model

See also names and str(model.avg(top_m))

Or estimates with shrinkage (zero method) – this makes the most difference for the less important predictors since they will get averaged with a bunch of zeros, probably: model.avg(top_m)$coef.shrinkage

9) But what if residuals are bad?

Don’t panic yet. Some times is because variance is different across groups/values, you can investigate that by:
  
  boxplot(A, residuals(m, type = "norm"))

plot(A, residuals(m, type = "norm"))

and fix it by incuding a variance factor in the models weights=varIdent(form=~1|A) (for factors) or weights= varPower(form=~x) for continous variables (you can also try VarExp or varConstPower)

And to check if it worked:
  
  plot(residuals(m, type = "normalized") ~ fitted(m))

The ref is Cleasby IR, Nakagawa S. 2011. Neglected biological patterns in the residuals. Behavioral Ecology and Sociobiology, 65(12), 2361-2372.

note that lm can not use the weights option, but I think, but you can use gls, instead.

10) Is also recomended to center scale(x, scale = FALSE) or scale scale(x) predictors.

Reference: Schielzeth, H. (2010), Simple means to improve the interpretability of regression coefficients. Methods in Ecology and Evolution, 1: 103–113.

11) You should also worry about co-linearity

library(car)

vif(m)

Should be lower than 2.5, and you should be very concerned when is over 10

or for lme’s load this little function from here (https://github.com/aufrank/R-hacks/blob/master/mer-utils.R)

vif.mer <- function (fit) {
  ## adapted from rms::vif
  v <- vcov(fit)
  nam <- names(fixef(fit))
  ## exclude intercepts
  ns <- sum(1 * (nam == "Intercept" | nam == " (Intercept)"))
  if (ns > 0) {
    v <- v[-(1:ns), -(1:ns), drop = FALSE]
    nam <- nam[-(1:ns)] }
  d <- diag(v)^0.5
  v <- diag(solve(v/(d %o% d)))
  names(v) <- nam
  v }

vif.mer(m)

12) and you may want to get R2 for glm also…

Based in Nakagawa, S., Schielzeth, H. (2013), A general and simple method for obtaining R2 from generalized linear mixed-effects models. Methods in Ecology and Evolution, 4: 133–142.

library(MuMIn)

r.squaredGLMM(m)

——————————————————————————————————

More details and plotting here: https://www.zoology.ubc.ca/~schluter/R/fit-model/
  
  For GLMM’s (generalized) there is a whole new set of tricky things, maybe will be another gist.


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
https://cran.r-project.org/web/packages/DHARMa/vignettes/DHARMa.html