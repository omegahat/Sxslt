\name{registerXSLTExtension}
\alias{registerXSLTExtension}
\title{Register a new XSLT extension namespace}
\description{
  This function allows the R programmer
  to declare a new XSLT extension namespace.
  One can either register functions for this extension
  in this call or via subsequent direct
  calls to \code{registerXSLTFunctions}.
}
\usage{
registerXSLTExtension(ns, ..., .funcs = list())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ns}{the namespace's URI. This can also be given
    in the form \code{c(prefix = "http:...")} and then
    the value of \code{prefix} can be used to identify
    the extension in calls to
    \code{registerXSLTFunctions} via its \code{.namespace}
    parameter.
   }
  \item{\dots}{name = function pairs of functions that are to be
    registered for this XSL extension and made available each time
    an XSL processor is activated.
  }
  \item{.funcs}{this is an alternative form of specifying
    the collection of name = function pairs
    which is more convenient when these functions are already in list
    form.
    The \dots approach is useful for "interactive" use, i.e.
    when the functions are known when the command is written.
  }
}
\value{
  \code{TRUE}!  It is the side-effect of creating
  a registry for this namespace that it is of interest.
}
\author{ Duncan Temple Lang}
\seealso{
 \code{\link{addXSLTFunctions}}
}
\examples{

 library(XML)  # for xmlValue
 e = new.env()
 omgEval = function(node) {
    eval(parse(text = xmlValue(node)), e)
 }
 environment(omgEval) = e

 registerXSLTExtension(c("omg" = "http://www.omegahat.org"),
                       eval = omgEval)
  # now  any XSL file can call omg:eval() by
  #  declaring the namespace http://www.omegahat.org
  #  and adding it to the extension-element-prefixes
  #  
}
\keyword{IO}
\keyword{programming}
\concept{XSL}
\concept{document transformation}
