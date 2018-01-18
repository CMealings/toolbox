sumMedia <- function(path, yearRange = 1980:2016, metaRange = c(11, 4), writeFile = c(FALSE, "sheet", "wb")) {
  
  ## Sum per country adex totals by medium, based on WARC.com download (export to .csv first)
  
  version <- 1.2
  
  if (missing(writeFile))
    writeFile <- FALSE
  
  ## Dependencies
  packages <- c("data.table", "XLConnect", "xlsx")
  for (pkg in packages) {
    
    ## Install
    if(!pkg %in% installed.packages()[, 1])
      install.packages(pkg)
    
    ## Load
    if(!paste0("package:", pkg) %in% search())
      require(pkg, character.only = TRUE)
    
  }
  
  n.rows <- length(yearRange)
  filetype <- unlist(strsplit(path, "\\."))
  filetype <- filetype[length(filetype)]
  
  ## Read in data
  if (filetype == "xlsx") {
    
    data <- read.xlsx(path, 1, startRow = sum(metaRange, 2), endRow = sum(metaRange, n.rows, 1), header = FALSE)
    meta <- read.xlsx(path, 1,stringsAsFactors = FALSE, startRow = metaRange[1] + 2, endRow = sum(metaRange) +1, header = FALSE)
    
  }
  
  if (filetype == "csv") {
    
    data <- read.csv(path, skip = sum(metaRange), nrows = n.rows)
    meta <- read.csv(path, stringsAsFactors = FALSE, skip = metaRange[1], nrows = metaRange[2])
    
    ## Remove 1000s separator, where csv uses it
    data <- data.frame(apply(data, 1:2, gsub, pattern = ",", replacement = ""))
    
  }
  
  ## Convert to numeric
  data[, -1] <- apply(data[, -1], 1:2, as.numeric)
  
  ## Combine media and country to create variable names
  names(data) <- c("Year", paste(meta[1,-1], meta[2,-1], sep = "_"))
  
  ## Get vector of media channels
  medium <- unique(as.character(meta[2, ]))
  medium <- medium[medium != "NA"]
  medium <- medium[medium != ""]
  
  ## Remove regex meta characters
  medium <- gsub("\\^|\\*", "", medium)
  
  ## Calculation log
  # log <- matrix(NA, ncol = length(medium), ncol = dim(data)[1])
  # colnames(log) <- medium
  
  ## Sum adex for all countries by media channel 
  totals <- t(apply(data[,-1], 1, function(x) {
    year <- NULL
    for (i in 1:length(medium)) {
      year <- append(year, sum(x[grep(medium[i], meta[2, -1])], na.rm = TRUE))
      # log[[medium[i]]] <- length(x[grep(medium[i], meta[2, -1])])
    }
    return(year)
  }))
  
  ## Clean up
  totals <- data.frame(totals)
  dimnames(totals) <- list(data[, 1], medium)
  
  ## Write to new file
  if (writeFile == "wb") {
    
    filename <- paste0(paste(sample(0:10, 7), collapse = ""), ".xlsx")
    system.file(filename, package = "XLConnect")
    
    ## Add Year as Variable
    with.year <- cbind.data.frame(data$Year, totals)
    names(with.year)[1] <- "Year"
    
    writeWorksheetToFile(filename, data = with.year, sheet = "All Country Totals")
    
  }
  
  ## Write to existing WB
  if (writeFile == "sheet") {
    
    write.xlsx(totals, path, "All Country Totals", col.names = TRUE, row.names = TRUE, append = TRUE, showNA = FALSE)
    
  }
  
  return(totals)
}