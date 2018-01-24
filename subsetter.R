

# data <- read.csv("C:/Users/CM3/Desktop/119837.csv", header = F, stringsAsFactors = F)

subsetter <- function(data) {
  
  # Rule for desired rows
  expr <- expression(!length(grep("[A-z]", row)))
  
  # Row selection vector
  rows <- apply(x[, -1], 1, function(row) {
    
    if (expr)
      return(TRUE)
    else
      return(FALSE)
    
  })
  
  new.data <- subset(x, subset = rows)
}

# write.csv(new.data, "119837.csv")
