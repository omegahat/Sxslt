\name{processXSLXInclude}
\alias{processXSLXInclude}
\title{Replace the XInclude with the contents to which it refers}
\description{
 This function performs the substitution of the XInclude
 node. It is very similar to \code{\link[XML]{processXInclude}}
 but is for use with XSL processing where the node may not have
 a document and so would not work  with \code{processXInclude}.
 Further, here we are interested in retrieving the nodes that were
 created as part of the XInclude operation so that we might use
 them in another context. This differs from the common use of
 \code{processXInclude} which is to do the substitution in place, 
 i.e. replace the XInclude node with the contents to which it refers.

}
\usage{
processXSLXInclude(node)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{node}{an XPathNodeSet, typically passed from an XSL template
  rule that calls this R function}
}
\details{

}
\value{
 A reference to a C-level/internal XPathNodeSet object which contains
 the nodes that were the result of performing the XInclude substitution.
}
\references{
libxslt
XInclude}


\seealso{
 }
\examples{

}

\keyword{IO}
\keyword{programming}
\concept{XSL}
\concept{XML}

