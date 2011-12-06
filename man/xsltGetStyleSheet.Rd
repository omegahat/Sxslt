\name{xsltGetStyleSheet}
\alias{xsltGetStyleSheet}
\alias{xsltGetInputDocument}
\alias{xsltGetOutputDocument}
\title{Obtain a reference to the XML internal document object
    for the style sheet or the input XML document.}
\description{

  These functions allow us to query the XSL transformation context to
  get a reference object in R to the style sheet DOM, the input XML
  document of the XSL transformation, or the output DOM being
  constructed..  This allows us then to use XPath expressions to
  access different nodes within these documents, identifying templates
  in the XSL document, or getting nodes and node sets for use in R
  calculations to create output in the target document.  These allow
  us to manipulate all of the inputs from within R rather than relying
  on XSL operations and can be used from within an R function called
  by an XSL template. Such functions need to the XMLXPathParserContext 
  object associated with the XSL transformation. This is passed as the
  first argument for any R function which has an S3 class named
 \code{XSLTContextFunction}.
}
\usage{
xsltGetStyleSheet(ctx)
xsltGetInputDocument(ctx)
xsltGetOutputDocument(ctx)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ctx}{the \code{XMLXPathParserContext}
    object that is passed to an R function
    that is called from the XSL transformation.
    Such an R function must be registered with
    XSLT as an extension function, typically using
    \code{\link{addXSLTFunctions}}   and must
    be an object of (S3) class \code{XSLContextFunction}
    created by a call to \code{\link{xsltContextFunction}}.
%    Alternatively, one can call
  }
}
\value{
  An object of class
  \code{XMLInternalDocument}
  which can be used in calls to
  \code{\link[XML]{getNodeSet}}
  and whose root node can be accessed
  with \code{\link[XML]{xmlRoot}}
  and the resulting tree navigated.
}
\references{
 \url{http://www.xmlsoft.org/XSLT}
}
\author{Duncan Temple lang}
\seealso{
  \code{\link[XML]{getNodeSet}}
  \code{\link{addXSLTFunctions}}
  \code{\link{xsltContextFunction}}.

  For an example, see
  applyTemplates.R,   applyTemplates.xsl
  and   applyTemplates.xml.
}
\examples{
  # Find the XML and XSL files.
 files = sapply(c("applyTemplates.xml", "applyTemplates.xsl"),
                function(i)
                    system.file("examples", i, package = "Sxslt"))



 z = xsltApplyStyleSheet(files[1], files[2])

 saveXML(z$doc)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{IO}
\keyword{programming}
\concept{XML}
\concept{XSL}

