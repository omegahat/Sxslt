\name{[.XMLAttributes}
\alias{[.XMLAttributes}
\alias{$.XMLAttributes}
\alias{names.XMLAttributes}
\title{Access attributes of XML Node}
\description{
  These functions provide access to
  the elements of a collection of XML attributes
  of an XML node. The usual list operators
  apply (\code{[}, \code{$}, etc.)
  but are implemented by accessing the C-level
  structure representing the set of attributes.
}
\usage{
\method{[}{XMLAttributes}(x, name)
\method{$}{XMLAttributes}(x, name)
\method{names}{XMLAttributes}(x)
}
\arguments{
  \item{x}{the \code{XMLAttributes} object whose contents are to be queried.}
  \item{name}{the name of the attribute whose value is to be retrieved.}
}
\details{
 The \code{XMLAttributes} objects are not regular named character
 vectors in S  but instead are references to C level structures
 managed by the XSLT engine. They are accessible as
 read-only values (as it makes little sense to modify them since they
 are not part of the output document).
}
\value{
\code{names} returns a character vector
giving the names of the attributes in the XML node.
\code{$} and \code{[} return the value of
the specified attributes.
}
\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}  
}
\author{
Duncan Temple Lang
}

\seealso{
 \code{\link{[[.XPathNodeSet}}
 \code{\link{[[.XMLChildren}}
 \code{node.xsl}, \code{node.xml} and \code{ok.R} in the examples directory.
}

\examples{
\dontrun{
  f <- function(nodeSet) {
    node <- nodeSet[[1]]
    paste(names(node), collapse=", ")
  }
  # registerXSLFunction("foo", f)
}
}

\keyword{IO}
\concept{XML}
\concept{dynamic content}
