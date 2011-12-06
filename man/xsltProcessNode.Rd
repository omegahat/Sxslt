\name{xsltProcessNode}
\alias{xsltProcessNode}
\title{Process a single XML node within the context of an XSL stylesheet
     and transformation}
\description{
  At present, this is not available on Windows as the
  xsltProcessOneNode routine is not accessible from the binary version
  of the libxslt library.

  
  This allows us to essentially call
  \code{apply-templates} to a single node
  from within R rather than requiring
  such a call to be in a template within
  the XSL style sheet. This gives control to the R programmer to define
  what happens independently of, or in concert with,
  the XSL stylesheet and allows us to program
  a transformation using both languages.
}
\usage{
xsltProcessNode(ctx, node)
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
    created by a call to \code{\link{xsltContextFunction}}.}
  \item{node}{the XML node which is to be processed by the collection of
    templates}
}
\details{
  This calls the C routine \code{xsltProcessOneNode}
  in the libxslt library.
}
\value{
  \code{NULL}.
  The purpose is for the side effect of modifying the target/output
  document being created by the XSL transformation.
}
\references{
  \url{http://www.w3.org/Style/XSL}
  \url{http://www.xmlsoft.org/XSLT}
}
\author{Duncan Temple Lang}
\seealso{
  \code{\link{xsltContextFunction}}
  \code{\link{addXSLTFunctions}}
  \code{\link{xsltApplyStyleSheet}}

  See applyTemplates.R and the associated
  XML and XSL files in the examples/ directory.
}
\keyword{IO}
\keyword{programming}
  
