\name{[.XMLChildren}
\alias{[.XMLChildren}
\alias{[[.XMLChildren}
\title{Get sub-nodes of an XML node}
\description{
  An XML node may have child or sub-nodes.
  These functions allow one to access them
  as if they were an S list (without element names).
}
\usage{
\method{[}{XMLChildren}(x, ...)
\method{[[}{XMLChildren}(x, i)
}
\arguments{
  \item{x}{the \code{XMLChildren} object containing the nodes.}
  \item{...}{the indeces of the nodes to retrieve.}
  \item{i}{the index of the single sub-node to retrieve}
}
\details{
 The \code{XMLChildren} object is a reference to an internal
C-level data structure managed by \code{libxslt}.
From this, we extract references to the different
children and represent these references as S objects.
}
\value{
\code{[.XMLChildren} returns a list
whereas \code{[[.XMLChildren} returns
a single element of class \code{XMLNode}.
}
\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}
  \url{http://xmlsoft.org/XSLT}
}
\author{
Duncan Temple Lang <duncan@wald.ucdavis.edu>
}

\seealso{
\code{\link{[.XMLAttributes}}
\code{\link{[[.XPathNodeSet}}
\code{node.xsl}, \code{node.xml} and \code{ok.R} in the examples directory.
}

\keyword{IO}
\concept{XML}
\concept{dynamic content}
