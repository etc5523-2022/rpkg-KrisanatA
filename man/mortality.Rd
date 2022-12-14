% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mortality.R
\docType{data}
\name{mortality}
\alias{mortality}
\title{Global Mortality by diseases}
\format{
A data frame with 128,520 rows and 6 variables.
\describe{
\item{country}{Country name}
\item{code}{Country code (Alpha-3 code)}
\item{continent}{Continent of each country}
\item{year}{Year}
\item{disease}{Disease name}
\item{mortality_rate}{Mortality rate in percentage}
}
}
\source{
This dataset is from the following; Our world in Data \url{https://ourworldindata.org/causes-of-death}
and \url{https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv}.
This dataset only includes causes of death related to disease information. An entity such as continents and
income levels from the original dataset is removed.
}
\usage{
mortality
}
\description{
The mortality data set contains information about the mortality rate across diseases and
by countries from 1990 to 2019.
}
\keyword{datasets}
