count_numbers <- function(number, vector = x, match = TRUE){
  if(match) y <- x[x == number]
  if(!match) y <- x[x != number]
  length(y)
}
