# disease -----------------------------------------------------------------

#' Get a list of available disease
#'
#' @export
disease_list <- function() {
  unique(dislib::mortality$disease)
}


# country -----------------------------------------------------------------

#' Get a list of available country
#'
#' @export
country_list <- function() {
  unique(dislib::mortality$country)
}


# year --------------------------------------------------------------------

#' Get a list of available year for the country specified
#' @param country A character of country name
#' @export
year_list <- function(country = NULL) {
  if (is.null(country)) {
    stop("Country input are required")
  }

  else {
    country <- mortality %>%
      filter(country == country)

    unique(country$year)
  }
}
