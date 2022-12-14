#' Launch a shiny app
#'
#' @description This function calls the shiny app based on the provided dataset `mortality`.
#'
#' @return Shiny app.
#'
#' @export
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "dislib")
  shiny::runApp(app_dir, display.mode = "normal")
}
