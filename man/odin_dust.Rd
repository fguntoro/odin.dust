% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/odin_dust.R
\name{odin_dust}
\alias{odin_dust}
\alias{odin_dust_}
\title{Create a dust odin model}
\usage{
odin_dust(x, verbose = NULL, real_t = NULL, workdir = NULL)

odin_dust_(x, verbose = NULL, real_t = NULL, workdir = NULL)
}
\arguments{
\item{x}{Either the name of a file to read, a text string (if
length is greater than 1 elements will be joined with newlines)
or an expression.}

\item{verbose}{Logical scalar indicating if the compilation should
be verbose.  Defaults to the value of the option
\code{odin.verbose} or \code{FALSE} otherwise.}

\item{real_t}{C++ type to use for real (floating point)
numbers. Defaults to \code{double}.}

\item{workdir}{Working directory to use for the compilation. By
default we use a new path within the temporary directory. Passed
to \code{\link{dust}}; a mini package will be created at this
path.}
}
\description{
Compile an odin model to work with dust.
}
\details{
Note that this does not (yet) support the full odin output object,
instead creating the more limited dust interface. However, for
many uses this should be considerably faster than the interface
that odin normally uses (built on dde).
}
