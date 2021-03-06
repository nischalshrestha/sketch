% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source_file.R
\name{source_r}
\alias{source_r}
\title{Source a p5.R file}
\usage{
source_r(file, debug = F, launch_browser = "viewer")
}
\arguments{
\item{file}{A character string; path to the R file.}

\item{debug}{T or F; if T, print compiled code on screen.}

\item{launch_browser}{A character string; "viewer" or "browser", which
calls `rstudioapi::viewer` and `utils::browserURL` respectively; use
`NULL` to suppress display.}
}
\description{
Source a p5.R file
}
