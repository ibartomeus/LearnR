#Data exploration

#Read this dataset and explore it.

#read data
dat <- read.csv("Roptimization/data/extinction.csv", h = TRUE)

head(dat)
str(dat)
summary(dat)
hist(dat$body_size)
hist(dat$extinction_risck)
cor.test(dat$extinction_risck, dat$body_size)
m <- lm(dat$extinction_risck ~ dat$body_size)
summary(m)
plot(dat$extinction_risck ~ dat$body_size)
abline(m)
plot(m)
scatter.smooth(dat$extinction_risck ~ dat$body_size)

#take home message. ALways plot your data

#example ascombe quartet?
