

function(selection = list(), datapath) {
  
  # Get filetype
  
  filetype <- unlist(strsplit(datapath, "\\."))
  filetype <- filetype[length(filetype)]
  
  ## Read in data
  if (filetype == "xlsx") {
    
    wb <- loadWorkbook(datapath)
    sheets <- names(getSheets(wb))
    
    data <- list()
    
    if (length(sheets > 1)) {
      
      for (sht in 1:length(sheets)) {
        
        data <- append(data, list(read.xlsx(datapath, sht, header = FALSE)))
        
      }
      names(data) <- sheets
    } else {
      
      data <- read.xlsx(datapath, sht, header = FALSE)
    }
  }
  
  if (filetype == "csv") {
    
    data <- read.csv(datapath, header = FALSE)
    
    ## Remove 1000s separator, where csv uses it
    # data <- data.frame(apply(data, 1:2, gsub, pattern = ",", replacement = ""))
    
  }
  
  # Index Conversion
  
  rowkey <- 1:dim(data)[1]
  function() {
    n.col <- dim(data)[2]
    for (i in 1:n.col) {
      colkey <- append(aolkey, LETTERS[i])
      if (i == " Z")
    }
  }
}