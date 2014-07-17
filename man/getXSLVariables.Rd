\name{getXSLVariables}
\alias{getXSLVariables}
\title{ Get the value of one or more top-level/global XSL parameters}
\description{
 This function allows an R function invoked from an XSL  template
 to query the current value of one or more top-level XSL parameters or global
 variables that are defined in the XSL style sheet(s).
  These parameters can be set by the caller and have default values
  set in the style sheets.

  This can only be called during an XSL transformation and by an R
  function that has access to the   \code{\link{XMLXPathParserContext-class}}
  associated with the XSL transformation.
 
}
\usage{
getXSLVariables(ctxt, vars, uris = names(vars), 
                         nsDefs =  xmlNamespaceDefinitions(as(ctxt, "XMLInternalDocument"), simplify = TRUE))
}

\arguments{
  \item{ctxt}{an \code{\link{XMLXPathParserContext-class}} object
  representing the internal control structure for the XSL
  transformation in effect. }
  \item{vars}{ the names of the variables of interest. 
      These can have a name space prefix qualifying them, e.g
      r:verbose.
      The name space has to be resolved either via the \code{nsDefs}
       vector.
  }
  \item{uris}{a character vector giving the prefixes of the namespaces of the variables being requested.}
  \item{nsDefs}{a character vector giving namespace prefix mappings to
   the corresponding URIs}
}

\value{
   A named character vector with the values.
}
\references{XSL }
\author{ Duncan Temple Lang}

\seealso{ 
  \code{\link{xsltApplyStyleSheet}}
  \code{\link{registerXSLFunction}}
  \code{XSLTContextFunction}
}
%\examples{ }

\keyword{IO}
\keyword{programming}
\concept{XSL}
