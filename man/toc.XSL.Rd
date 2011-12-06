\name{toc.XSL}
\alias{toc.XSL}
\title{Get a table of contents of templates in an XSL document (and imports)}
\description{
 This is a utility function that retrieves the specification of the
  node names and expressions that templates match in an XSL 
 templates. This is useful for understanding what node names
  are "active". This can help in documenting and understanding the entire set of nodes.

  This function can recursively process sub-XSL documents which are import'ed or include'd
  via XSL.

}
\usage{
toc.XSL(doc, base = if (is.character(doc)) doc else docName(doc), recursive = TRUE, ignore = character())
}
\arguments{
  \item{doc}{the XSL document, either a file name, URL or a parsed document}
  \item{base}{the base document, which defaults to \code{doc}.}
  \item{recursive}{a logical value indicating whether to 
   process xsl:import or xsl:include.}
  \item{ignore}{a character vector. This can be a vector of URLs or file names
   to not process}
}
%\details{}
\value{
 A character vector giving the individual parts of the different templates,
e.g \code{c("r:code", "r:expr")} from the template 
  \code{<xsl:template match="r:code|r:expr">}
 All of the different templates are merged together.
}
\author{
Duncan Temple Lang
}


\seealso{
 \code{\link[XML]{xmlParse}}
 \code{\link[XML]{getNodeSet}}
}
\examples{
library(XML)
  xsl = catalogResolve("http://www.omegahat.org/XDynDocs/XSL/html.xsl")
 
  tmpls = toc.XSL(xsl, recursive = FALSE)

  tmpls = toc.XSL(xsl)

  tmpls = toc.XSL(xsl, ignore = "http://docbook")
}
\keyword{programming}

