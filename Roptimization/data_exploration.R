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


#debug this function
#learn how to debug, split in pieces the problem, seacrh in stack overflow, learn diferent fixes are always available

#make one of those cases when drop = FALSE is needed.

dataset <- data.frame(groups = c(rep("a",4), "b", rep("c",5)),
                      var = rnorm(10))

col_means <- function(df) {
  data.frame(lapply(df, mean))
}


colMeans(mtcars[, "mpg"])
col_means(mtcars)
col_means(mtcars[, 0])
col_means(mtcars[0, ])
col_means(mtcars[, "mpg"])
#needed
col_means(mtcars[, "mpg", drop = FALSE])

