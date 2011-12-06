\name{readXSL}
\alias{readXSL}
\title{Read an XSL document as an XML document, substituting import and
  include nodes with the contents of the referenced documents.}
\description{
  This  is a convenience function for treating an XSL document
  as an XML document so that we can process its contents directly,
  e.g. finding templates and parameters, using XPath expressions.
  (This is different from parsing the XSL document for use within
  XSL transformations. In that case, we use
  \code{\link{xsltParseStyleSheet}}).

  This function optionally allows the caller to have xsl:import and
  xsl:include nodes be substituted by reading the referenced XSL files
  and having their contents inserted in place of the
  xsl:import/xsl:include nodes. This "flattens" the XSL document and
  makes querying its contents easier.
}
\usage{
readXSL(doc, asText = !file.exists(doc), recursive = TRUE, base = character())
}
\arguments{
  \item{doc}{the XSL document, either as file name or URL name (i.e. a
    character)
    or a parsed XSL document (via \code{\link[XML]{xmlParse}}
     and not \code{\link{xsltParseStyleSheet}}).}
  \item{asText}{
     a logical value that indicates if the \code{doc}  value is XML
  itself or the name of an XML document, if it \code{doc} is a character
  string or vector.}
  \item{recursive}{a logical value indicating whether to process the
  xsl:import and xsl:include elements and replace these with the actual
  stylesheet contents to which they refer.}
  \item{base}{the base URL relative to which references to other XSL
    files in xsl:import and xsl:include nodes are resolved.
    Typically one does not need to specify this at the top-level
  call. It defaults to the source of the top-level XSL content, i.e. \code{doc}.}
}
\details{
  Currently, we replace the xsl:import and xsl:include nodes
  with the corresponding xsl:stylesheet node.
  In the future, we may replace the import/include nodes with the
  children of the stylesheet nodes.
}

\value{
  An \code{XMLInternalDocument} being a native (C-level)
  object that represents the parsed XML document.
}

\author{
Duncan Temple Lang
}

\seealso{
 \code{\link{xsltParseStyleSheet}}
}
\examples{

}

\keyword{programming}
\concept{XSL}
\concept{documents}

