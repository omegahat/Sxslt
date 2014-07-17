\name{xsltInsert}
\alias{xsltInsert}
\alias{xsltGetInsertNode}
\title{Tools for adding nodes to the the target/output document
  in an XSL transformation.}
\description{
  These functions allow us to directly insert
  new nodes or content into the document
  being created in an XSL transformation.
  \code{xsltInsert} inserts one or more
  (internal) nodes  directly into the document
  as children of the currently active node.

  \code{xsltGetInsertNode} allows us to retrieve
  a reference to the (internal) XML node that
  is the current point of insertion in the XSL
  transformation process.
  We can then use other tools (e.g.
  \code{\link[XML]{addChildren}}) to add content to
  that node or to navigate to a different
  node in the tree and add content there.
}
\usage{
xsltInsert(ctx, ..., .nodes = list(...))
xsltGetInsertNode(ctx)
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
  \item{\dots}{zero or more (internal/C-level) nodes which are to be inserted as
    children of the currently active node in the
    output document. Text is converted to \code{XMLInternalTextNode}
    objects.
    This mechanism of specifying the nodes individually
    is useful for interactive use.
    When the collection of nodes have been pre-computed
    and are in a \code{list},  use the \code{.nodes}
    argument.
   }
   \item{.nodes}{the collection of nodes to insert as a \code{list}.}
}
\value{
 \code{NULL}
}
%\references{}
\author{Duncan Temple Lang}
\seealso{
  \code{\link{xsltContextFunction}}
  \code{\link{xsltApplyStyleSheet}}
}

\keyword{IO}
\keyword{programming}
\concept{XML}
\concept{XSL}
