\name{xslImportStyleSheets}
\alias{xslImportStyleSheets}
\title{Import style sheets into an existing XSL style sheet}
\description{
 This function allows us to cause the specified style sheets to be
 added to the existing XSL style sheet as if they had been 
 specified with xsl:import or xml:import.
}
\usage{
xslImportStyleSheets(style, sheets, import = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{style}{the \code{\link{XSLStyleSheet-class}} object into which
   the other XSL style sheets wil be imported/included.}
  \item{sheets}{ the names of the XSL style sheets or the previously
  parsed XSL style sheets.}
  \item{import}{ a logical value indicating whether to xsl:import or
  xsl:include the style sheets}
}
\value{
  The \code{style}  object which contains the augmented information.
  
}
%\references{ ~put references to the literature/web site here ~ }
\author{Duncan Temple Lang}

\seealso{ 
 \code{\link{xsltParseStyleSheet}}
}
\examples{

}
\keyword{IO}
\keyword{programming}
\concept{XSL}

