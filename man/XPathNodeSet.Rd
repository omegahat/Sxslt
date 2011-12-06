\name{XPathNodeSet}
\alias{XPathNodeSet}
\alias{XPathNodeSet-class}
\alias{[[.XPathNodeSet}
\alias{[.XPathNodeSet}
\alias{[[,XPathNodeSet-method}
\alias{lapply,XPathNodeSet-method}
\alias{sapply,XPathNodeSet-method}
\alias{length,XPathNodeSet-method}
\alias{length,XMLChildren-method}
\alias{unlist,XPathNodeSet-method}
\alias{coerce,XPathNodeSet,character-method}
\alias{coerce,XPathNodeSet,integer-method}
\title{Methods for an XPathNodeSet reference}
\description{

  An \code{XPathNodeSet} object is a container passed from XML/XSL to
  R and is a reference to a C-level data structure that contains a
  collection/set of nodes.  It is like a list in that it contains zero
  or more elements, and so we have R-level methods that allow it to be
  used like a list within R code.  These include operations to access
  an individual element by position, calculate the length and apply a
  function to each element of the set.

  The function \code{XPathNodeSet} object is used to create an XPathNodeSet
  object from within R.  This is useful if we want the result of an R
  function called from XSL to return a collection of nodes for further
  processing in the XSL transformer or to be included in the output
  document.

  Since an \code{XPathNodeSet} is like a list, we provide a
  a method for \code{[[} to extract individual elements.

}
\usage{
XPathNodeSet(..., els = list(...), duplicate = FALSE)
\method{[[}{XPathNodeSet}(x, i, j, ...)
\method{[}{XPathNodeSet}(x, i, j, ..., references = FALSE)
}
\arguments{
  \item{...}{individual XMLInternalNode elements.
    This can be obtained from other XSL calls operations
    or by explictly creating internal nodes using
    functions in the \code{XML} package
    such as \code{\link[XML]{newXMLNode}} and others.

    In the \code{[[} operator, ... are additional indices identifying
    the elements of interest.
  }
  \item{els}{the list of XMLInternalNode objects that are to be put
    into the XPathNodeSet object. This is for programmatic
    use when we already have a list  XMLInternalNode objects,
    as opposed to the \dots mechanism which is for interactive use
    when we have individual elements.
  }
  \item{x}{the \code{XPathNodeSet} reference object}
  \item{i, j}{the index/indices of the element to be returned.}
  \item{duplicate}{a logical value indicating whether the nodes being
   inserted into the XPathNodeSet container should be cloned/copied
   (in entirety, i.e. recursively).
  }

 \item{references}{a logical value that controls whether 
  we return the values of the XPath elements in the node set
  or references to the C-level objects. \code{references = TRUE}
  give us the latter and these can be useful if we want to modify 
  the C-level data structures rather than just query their values.}
}
\value{
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
\code{\link{[.XMLAttributes}}
\code{\link{[.XMLChildren}}
\code{node.xsl}, \code{node.xml} and \code{ok.R} in the examples directory.
}

\examples{
}

\keyword{IO}
\concept{XML}
\concept{dynamic content}
