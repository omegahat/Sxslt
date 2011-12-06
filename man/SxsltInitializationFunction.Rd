\name{SxsltInitializationFunction}
\alias{SxsltInitializationFunction}
\title{Set an R function to be called each time the R extension module
  in XSLT  is initialized}
\description{
  This function allows the R user to specify an R function that
  is called each time the XSLT extension module for R is initialized.
  This happens each time the extension is referenced within
  an XSL style sheet that is being applied to an XML document.
  This provides an opportunity for R to perform some additional
  computations. Typically, the function registers any
  R functions that should be made available to the extension
  as extension functions.  However,
  other computations can be performed.

  When the package is loaded, a default function
  (\code{Sxslt:::defaultXSLTInitialization})
  is set as the
  initialization function. That handles registering functions
  queued with the \code{\link{addXSLTFunctions}} function
  also in this package.
}
\usage{
SxsltInitializationFunction(func = NULL)
}
\arguments{
  \item{func}{an R function which will be called each time the XSLT
    extension module is initialized. This function will be called with
    two arguments: a character vector of length 1 (i.e. a string) which
    identifies the URI of the extension, and an reference to the
    XSLT parser context. This is an opaque data type that can be used
    in calls to \code{\link{registerXSLFunction}} as the \code{context} argument.}
}
\value{
  This returns the previously registered R function that was used for
  handling the initialization of the extension module.
  This allows one to save the value and restore it after applying
  a stylesheet to a particular document or set of documents.
}

\references{
  \url{http://www.omegahat.org/Sxslt}
  \url{http://www.xmlsoft.org/XSLT}

  \code{registration.R} in the \code{examples/} directory.
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{registerXSLFunction}}
 \code{\link{addXSLTFunctions}}
}

\keyword{IO}
\concept{XML}
\concept{dynamic report generation}
\concept{dynamic documents}

