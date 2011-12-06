\name{getXSLParams}
\alias{getXSLParams}
\title{Extract the top-level XSL parameters and default values in an XSL
stylesheet}
\description{
  This function processes an XSL file and recursively its xsl:import
  and xsl:include elements and then extracts the top-level
  XSL parameters. It returns a vector of the values,
  using the names of the XSL parameters as the names of the R vector.

  This function can help us learn about the possible XSL parameters
  we can use to control the run-time behavior of the stylesheet
  and also find the default values.  This was originally motivated
  by the desire to find XSL parameters for transformation to FO
  to compare the coloring of code elements with that in CSS files for HTML.
}
\usage{
getXSLParams(doc, recursive = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doc}{the XSL document, either as file name or URL name (i.e. a
    character)
    or a parsed XSL document (via \code{\link[XML]{xmlParse}} and not
      \code{\link{xsltParseStyleSheet}}).}
  \item{recursive}{a logical value indicating whether to process the
  xsl:import and xsl:include elements and replace these with the actual
  stylesheet contents to which they refer.}
}
\details{
 This uses \code{\link{readXSL}} to preform the recursive inclusion of
 the  XSL documents.
}
\value{
 Either a character vector or a list if any of the default values for
 the XSL parameters are nodes rather than single values.
 The names of the elements are the names of the XSL parameter.s
}
\references{
 The XSL  specification.
}
\author{
 Duncan Temple Lang
}

\seealso{
 \code{\link{xsltApplyStyleSheet}}
 \code{\link{xsltParseStyleSheet}}
}
\examples{
  system.file()
}
\keyword{programming}
\concept{documents}
\concept{XSL}

