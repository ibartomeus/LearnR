

Hands-on: examining the `iris` dataset
========================================================
  type: prompt
incremental: false

Hands-on work in RStudio.
* Built-in datasets
* Using `summary`, `names`, `head`, `tail`
* Looking at particular rows and columns
* Subsetting the data
* Basic plots of the data


Computing on columns
========================================================
  
  This can be simple...

```{r}
d <- data.frame(x = 1:3)
d$y <- d$x * 2
d$z <- cumsum(d$y) # cumulative sum
d$four <- ifelse(d$y == 4, "four", "not four") 
d
```


Computing on columns
========================================================
  
  ...or more complex. For example, for Picarro data comes with multiplexer valve numbers (i.e., in an experiment, the multiplexer automatically switches between valves). Whenever the valve number changes, we want to assign a new sample number.

```{r}
# Toy data set
# Analyzer is switching between valves 1, 2, and 3
vn <- c(1, 1, 2, 3, 3, 3, 1, 2, 2, 3)
```

There are 6 samples here, and we want to produce `1, 1, 2, 3, 3, 3, 4, 5, 5, 6`.


Exercise: Computing on columns
========================================================
  
  ```{r}
# Works, but slow
samplenums <- rep(NA, length(vn))
samplenums[1] <- 1
s <- 1
for(i in 2:length(vn)) {
  if(vn[i] != vn[i-1])
    s <- s + 1
  samplenums[i] <- s
}
samplenums
```


Exercise: Computing on columns
========================================================
  
  ```{r}
# Vectorised: fast and elegant
newvalve <- vn[-length(vn)] != vn[-1]
newvalve <- c(TRUE, newvalve)
newvalve
cumsum(newvalve)
```


Exercise: Computing on columns - time
========================================================
  
  ```{r, echo=FALSE}
vnums <- rep(c(1, 2, 2, 3, 3, 3, 1, 1, 2, 3, 3), 100000)
```

This has big consequences!
  
  For a data frame with `r prettyNum(length(vnums), big.mark=",")` rows:
  
  **The larger lesson to take away here** is that in R, `for` loops are rarely the fastest way to do something (although they may be the clearest).

***
  
  ```{r, cache=TRUE, echo=FALSE}
slowtime <- system.time({
  samplenums <- rep(1, length(vnums))
  s <- 1
  for(i in seq_along(vnums)[-1]) {
    if(vnums[i] != vnums[i-1])
      s <- s + 1
    samplenums[i] <- s
  }
})

fasttime <- system.time(cumsum(c(TRUE, vnums[-length(vnums)] != vnums[-1])))
d <- data.frame(Algorithm=c("for loop", "cumsum"), Time_s=c(slowtime[3], fasttime[3]))
library(ggplot2)
theme_set(theme_bw())
ggplot(d, aes(Algorithm, Time_s)) + geom_bar(stat='identity') + ylab("Time (seconds)")
```







Dealing with dates
========================================================
  
  R has a `Date` class representing calendar dates, and an `as.Date` function for converting to Dates. The `lubridate` package is often useful (and easier) for these cases:
  
  ```{r}
library(lubridate)
x <- c("09-01-01", "09-01-02") # character!
ymd(x)   # there's also dmy, ymd_hms, etc.
```

Once data are in `Date` format, the time interval between them can be computed simply by subtraction. See `?difftime`


Merging datasets
========================================================
  
  Often, as we clean and reshape data, we want to merge different datasets together. The built-in `merge` command does this well.

Let's say we have a data frame containing information on how pretty each of the `iris` species is:

```{r, echo=FALSE}
howpretty <- data.frame(Species = unique(iris$Species), 
pretty = c("ugly", "ok", "lovely"))
howpretty
```


Merging datasets
========================================================

`merge` looks for names in common between two data frames, and uses these to merge.

```{r, eval=FALSE}
merge(iris, howpretty)
```

```{r, echo=FALSE}
head(merge(iris, howpretty)[c(1, 2, 6)])
```

(NB - viewing only a few columns and rows.) The `dplyr` package has more varied, faster database-style join operations.


Summarizing and manipulating data
========================================================
type: section


History lesson
========================================================

<img src="images/history.png" width="850" />


Summarizing and manipulating data
========================================================

Thinking back to the typical data pipeline, we often want to summarize data by groups as an intermediate or final step. For example, for each subgroup we might want to:

* Compute mean, max, min, etc. (`n`->1)
* Compute rolling mean and other window functions (`n`->`n`)
* Fit models and extract their parameters, goodness of fit, etc.

Specific examples:

* `cars`: for each speed, what's the farthest distance traveled?
* `iris`: how many samples were taken from each species?
* `babynames`: what's the most common name over time?


Split-apply-combine
========================================================

These are generally known as *split-apply-combine* problems.

<img src="images/split_apply_combine.png" width="600" />

From https://github.com/ramnathv/rblocks/issues/8


aggregate
========================================================

Base R has an `aggregate` function. It's not particularly fast or flexible, and confusingly it has different forms (syntax).

It can however be useful for simple operations:
  
  ```{r}
# What's the farthest distance at each speed?
aggregate(dist ~ speed, 
          data = cars, FUN = max)
```


dplyr
========================================================
  
  The newer `dplyr` package specializes in data frames, recognizing that most people use them most of the time.

`dplyr` also allows you to work with remote, out-of-memory databases, using exactly the same tools, because it abstracts away *how* your data is stored.

`dplyr` is **extremely fast**.


Operation pipelines in R
========================================================
  
  `dplyr` *imports*, and its examples make heavy use of, the [magrittr](https://github.com/smbache/magrittr) package, which introduces a **pipeline** operator `%>%` to R.

Not everyone is a fan of piping, and there are situations where it's not appropriate; but we'll stick to `dplyr` convention and use it frequently.


Operation pipelines in R
========================================================
  
  Standard R notation:
  
  ```{r, eval=FALSE}
x <- read_my_data(f)
y <- merge_data(clean_data(x), otherdata)
z <- summarize_data(y)
```

Notation using a `magrittr` pipeline:
  
  ```{r, eval=FALSE}
read_my_data(f) %>%
  clean_data %>%
  merge_data(otherdata) %>%
  summarize_data ->
  z
```


Verbs
========================================================
  
  `dplyr` provides functions for each basic *verb* of data manipulation. These tend to have analogues in base R, but use a consistent, compact syntax, and are very high performance.

* `filter()` - subset rows; like `base::subset()`
* `arrange()` - reorder rows; like `order()`
* `select()` - select columns
* `mutate()` - add new columns
* `summarise()` - like `aggregate`


Grouping
========================================================
  
  `dplyr` verbs become particularly powerful when used in conjunction with *groups* we define in the dataset. The `group_by` function converts an existing data frame into a grouped `tbl`.


```{r}
library(dplyr)
library(babynames)
babynames %>% group_by(year, sex)
```


Summarizing cars
========================================================
  
  We previously did this using `aggregate`. Now, `dplyr`:
  
  ```{r}
cars %>% 
  group_by(speed) %>% 
  summarise(max(dist))
```


Summarizing iris
========================================================
  
  ```{r}
iris %>% 
  group_by(Species) %>% 
  summarise(msl = mean(Sepal.Length))
```


Summarizing iris
========================================================
  
  We can apply (multiple) functions across (multiple) columns.

```{r}
iris %>% 
  group_by(Species) %>% 
  summarise_each(funs(mean, median, sd), 
                 Sepal.Length)
```


Summarizing babynames
========================================================
  
  What does this calculate?

```{r}
babynames %>%
  group_by(year, sex) %>% 
  summarise(prop = max(prop), 
            name = name[which.max(prop)])
```


Summarizing babynames
========================================================
  
  <img src="images/popular_babynames.png" width="800" />
  
  https://en.wikipedia.org/wiki/Linda_(1946_song)


Why use dplyr?
========================================================
  
  In general `dplyr` is ~10x faster than the older `plyr` package.

And `plyr` was ~10x faster than base R.

Base R also tends to require more lines of code.


Hands-on: manipulating the `babynames` dataset
========================================================
  type: prompt
incremental: false

Load the dataset using `library(babynames)`. Read its help page. Look at its structure (rows, columns, summary).

Use `dplyr` to calculate the total number of names in the SSA database for each year. 

Calculate the 5th most popular name for girls in each year. Hint: `nth()`.


Processing Picarro data
========================================================
  type: section


Picarro data
========================================================
  
  The Picarro outputs text files with names like 

>CFADS2283-20150831-171845Z-DataLog_User.dat 

>(1.2 MB)

They're bulky and I will often store them gzip'd or zip'd (R will transparently decompress on reading).

>CFADS2283-20150831-171845Z-DataLog_User.dat.gz

>0.1 MB


Picarro data
========================================================

These files are straightfoward text files.

<img src="images/datafile.png" width="800" />


Picarro data
========================================================

Data in the Picarro output stream include:

* **`DATE`: yyyy-mm-dd format**
* **`TIME`: hh:mm:ss.sss**
* Time in other forms: `FRAC_DAYS_SINCE_JAN1`, `FRAC_HRS_SINCE_JAN1`, `JULIAN_DAYS`, `EPOCH_TIME`
* `ALARM_STATUS` and `INST_STATUS`
* `species`
* **`MPVPosition` and `solenoid_valves`**
* **Gas data: `CH4`, `CH4_dry`, `CO2`, `CO2_dry`, `H2O`, `h2o_reported`**


Picarro data cautions
========================================================
type: alert
incremental: true

**Fractional `MPVPosition` valve numbers**

The analyzer records fractional valve numbers when switching between multiplexer valves. You'll want to discard these.

**Date and time stamps**
  
  Know what time the analyzer is set to. If local time, does your experiment cross a daylight savings transition? Does it cross into a new year (which would screw up e.g. `FRAC_HRS_SINCE_JAN1`)?

I recommend setting it to UTC and LEAVE IT THERE. Then it's easy to convert the `DATE` and `TIME` fields into a true R date field and adjust to local time zone if necessary.


Getting data into R
========================================================

The most common way to bring data into R is via `read.table`:
```{r, eval=FALSE}
d <- read.table("mydata.csv", header = TRUE)
```

The `readr` package provides read_table, which is faster and easier to use.
```{r, eval=FALSE}
library(readr)
d <- read_table("mydata.csv")
```


Hands-on: Picarro data
========================================================
type: prompt

Let's open the `picarro.R` file, which I started but didn't finish.

At this point, we have the tools to complete the job. Can you help?


Picarro pipeline solution
========================================================

```{r, eval=FALSE}
rawdata %>%
filter(MPVPosition == floor(MPVPosition)) %>%
select(samplenum, DATETIME, MPVPosition, 
CH4_dry, CO2_dry) %>%
left_join(valvedata, by = "MPVPosition") %>%
group_by(samplenum) %>%
mutate(secs = difftime(DATETIME, 
min(DATETIME), 
units = "secs"),
secs = as.numeric(secs)) %>%
filter(soilcore != "J") ->
cleandata
```


Things we didn't talk about
========================================================
  
  General:
  
  - reshaping data
- writing/saving data
- graphing data

Specifically for Picarro data:
  
  - gas concentration profile characteristics
- how to compute fluxes


Last thoughts
========================================================
  
  >The best thing about R is that it was written by statisticians. The worst thing about R is that it was written by statisticians.
>
  >-- Bow Cowgill

All the source code for this presentation is available at https://github.com/bpbond/R-data-picarro


Resources
========================================================
  type: section


Resources
========================================================
  
  * [CRAN](http://cran.r-project.org) - The Comprehensive R Archive Network. Ground zero for R.
* [GitHub](https://github.com/JGCRI) - The JGCRI organization page on GitHub.
* [RStudio](http://www.rstudio.com) - the integrated development environment for R. Makes many things hugely easier.
* [Advanced R](http://adv-r.had.co.nz) - the companion website for “Advanced R”, a book in Chapman & Hall’s R Series. Detailed, in depth look at many of the issues covered here.


Resources
========================================================
  
  R has many contributed *packages* across a wide variety of scientific fields. Almost anything you want to do will have packages to support it.

[CRAN](http://cran.r-project.org) also provides "Task Views". For example:
  
  ***
  
  - Bayesian
- Clinical Trials
- Differential Equations
- Finance
- Genetics
- HPC
- Meta-analysis
- Optimization
- [**Reproducible Research**](http://cran.r-project.org/web/views/ReproducibleResearch.html)
- Spatial Statistics
- Time Series