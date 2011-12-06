\name{registerXSLFunction}
\alias{registerXSLFunction}
\title{Define an XSL extension function} 
\description{
  This function provides a way to define an XSL function
  that is implemented using an R function.
  The XSL function is immediately available to  the XSLT engine.
  This should only be called during the initialization
  of the XSLT module (or during the evaluation of one of the
  R functions exported to the XSLT module).
  It is not used in between the application of
  XSL sheets. To \dQuote{queue} functions to be registered
  with the XSLT engine when the module is initialized,
  use \code{\link{addXSLTFunctions}} rather than this one.
}
\usage{
registerXSLFunction(name, fun, symbol=NULL, uri= RExtensionNamespace,
                    old=FALSE, context = NULL)
}
\arguments{
  \item{name}{the name to use for the XSL function being defined.
  This is how it will be addressed/referenced in the XSL stylesheets.}
\item{fun}{a function object, the name of a function or
  a string that is an S expression that evaluates to a function object.
  If this is not supplied, we use the function named
   \code{name}.}
 \item{symbol}{the name of a C routine to use as the implementation
   of the XSL function \code{name}. Either \code{fun}
  or \code{symbol} is usually specified, not both.}
\item{uri}{the URI identifying the XSL namespace for this XSL function.
  This specifies how the XSL code addresses the function.
   The namespace and URI should be declared in the XSL document.}
 \item{old}{a logical value indicating whether the previous function or
   symbol associated with this XSL function name should be returned or
   not.
   This allows the function to be easily called from XSL
   (the \code{register} function) without having to deal with
   complicated conversion of an R object to an XSL value.
 }
 \item{context}{the XSLT parsing context that is passed as the second
   argument to the initialization function.}
}
\details{
  This stores the S function in an internal table under
  the index \code{name} and registers the XSL function
  name   with the XSLT engine along with a C routine that is a generic R function handler.
  When the XSL function is called, the XSLT engine calls that C routine
  which retrieves the associated R function from the internal table
  and calls it with the arguments from the XSL stack.
}
\value{
  If \code{old} is \code{FALSE},
  this returns a logical value indicating whether the function
  was registered or not.
  If \code{old} is \code{TRUE}, the R function
  or C symbol that was previously registered (if any) will be returned.
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
  \code{\link{addXSLTFunctions}}
  
  \url{register.xsl}, \url{register.xml}
  and \url{register.R} in the examples directory.
}

\examples{
\dontrun{
  registerXSLFunction("init", function(...) { TRUE })
  registerXSLFunction("register", function(name, func) { TRUE })
  registerXSLFunction("foo", function(x) { cat("in foo\n"); print(x) ; x*2})
  registerXSLFunction("bar", function(x,y) { cat("in bar\n"); print(x) ; print(y) ; nchar(x) + nchar(y)})

  xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"),
                      system.file("examples", "register.xsl", package = "Sxslt"), FALSE)
}
}
\keyword{IO}
\concept{XML}
\concept{dynamic content}
