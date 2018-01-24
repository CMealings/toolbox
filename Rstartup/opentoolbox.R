openToolbox <- function() {
  path <- paste0(Sys.getenv("TOOLBOX"), "\\Rstartup")
  toolbox <- grep(".R$", list.files(path), value = TRUE)
  for (tool in toolbox)
    source(paste0(path, "\\", tool))
}
