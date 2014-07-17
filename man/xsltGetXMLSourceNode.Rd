\name{xsltGetXMLSourceNode}
\alias{xsltGetXMLSourceNode}
\alias{xsltGetXSLNode}
\title{Get the active nodes in the XSL process}
\description{
 These functions  allow us to query the currently
 active nodes being processed in the XSL transformation.
  We can get the node in the XML document that is being transformed
  and also the node in the XSL transformation that is performing
  the transformation.
}
\usage{
xsltGetXMLSourceNode(context)
}
\arguments{
  \item{context}{an object of class \code{XMLXPathParserContext}
    which can only be (legitimately) obtained as the first argument
     in a call from XSL to an R function which inherits from
     the S3 class \code{XSLTContextFunction}.
   }
}
\value{
  An object of class \code{XMLInternalNode}.

  These objects should not be stored  after the function returns.
  They may/will be garbage collected at some point in the future and
  become  invalid.
}

\author{Duncan Temple Lang}
\seealso{ 
 \code{\link{registerXSLFunction}}
 \code{XSLTContextFunction}
}
%\examples{}
\keyword{IO}
\concept{XSL}

