openToolbox <- function() {
  path <- Sys.getenv("TOOLBOX")
  toolbox <- grep(".R$", list.files(path), value = TRUE)
  for (tool in toolbox)
    source(paste0(path, "\\", tool))
}
