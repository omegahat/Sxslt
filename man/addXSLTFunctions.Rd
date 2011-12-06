\name{addXSLTFunctions}
\alias{addXSLTFunctions}
\alias{getXSLTFunctions}
\alias{setXSLTFunctions}
\alias{xsltContextFunction}
\title{Queue R functions to registered as XSL functions.}
\description{
  These functions allow one to set and query a list
  of functions maintained in R that will be registered
  with the R XSLT extension module each time it is initialized,
  i.e. each time a stylesheet that refers to the extension is applied to
  an XML document.
  The \code{addXSLTFunctions} allows one to add functions to the
  existing queue, and optionally to clear the existing contents
  (via the \code{clear} argument).

  R functions registered in the default manner can be called from XSL
  but have little access to the state of the XSL transformation.
  However, an R function can arrange to be always
  called from XSL with an XSLTContext
  reference object as its first argument.
  This happens for the R functions that inherit from
  the S3-style class XSLTContextFunction.
  One can specify this as the class of a function or
  alternativel call \code{xsltContextFunction}
  in the call to register/add the R function.
  
  \code{getXSLTFunctions} returns the current list of functions
  that are queued to be registered.

  These functions are only useful if the default
  registration function is used. This is installed
  when the package is loaded but can be changed via
  \code{\link{SxsltInitializationFunction}}.

  \code{setXSLTFunctions} is for use when we need
   to manipulate the list of functions such as when
   we want to remove just some of the functions.
   Be very cautious about using this.  One has to 
   know precisely which functions should be removed
   and which should be kept and there may be name 
   conflicts which make this ambigious, e.g. instances
   of the same function with different environments.
   
}
\usage{
addXSLTFunctions(..., .namespace = "r", .funcs = list(), clear = FALSE)
getXSLTFunctions()
setXSLTFunctions(funs)
xsltContextFunction(f)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{a named list of R functions.  Each name is used as the
    name in the XSLT extension module, i.e. the name by which the
    corresponding function can be called from within an XSL rule.
    This can be best used when calling the function interactively.}
  \item{.namespace}{a character string.  This identifies the namespace
    for which the function is being added.  The value can either be the
    prefix for the namespace, e.g. "r", or the namespace's full URI,
    e.g. "http://www.r-project.org".
  }
  \item{.funcs}{a named list of R functions that provides an alternative
    mechanism than the \dots for specifying the functions. This is
    convenient for programatic use.}
  \item{clear}{ a logical value which if \code{TRUE}
    first removes existing elements from the list of functions to be registered.
  }
  \item{f}{the function which is to be identified as an
    \code{XSLTContextFunction} instance.}
  \item{funs}{a named list of functions which are to be registered
    using the names in the list. This is often used to reset the
    entire collection of "global" functions that will be registered
    with the XSLT engine when it next starts to process a document.}
}
\details{
  This uses a closure within the name space  to
  allow updates of the R list of functions.
}
\value{
  Both functions return the current list of
  queued functions.
  \code{addXSLTFunctions} returns it invisibly to avoid
  the default printing.

  \code{xsltContextFunction} returns an object of class
  \code{XSLTContextFunction}.
}
\references{
  \url{http://www.omegahat.org/Sxslt}
  \url{http://www.xmlsoft.org/XSLT}

  \code{registration.R} in the \code{examples/} directory.
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
  \code{\link{SxsltInitializationFunction}}
  \code{\link{xsltApplyStyleSheet}}
}
\examples{

  addXSLTFunctions(foo = function(x) {
                            cat("in foo\n")
                            print(x)
                            x*2
                         },
                   bar = function(x,y) {
                            cat("in bar\n")
                            print(x)
                            print(y) 
                            nchar(x) + nchar(y)
                         },
                   vars = xsltContextFunction(
                             function(ctxt) {
                                cat("xsl variable bob has value", getXSLVariables(ctxt, "bob"), "\n")
                             })
   )

  xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"),
                      system.file("examples", "register.xsl", package = "Sxslt"), FALSE)

  addXSLTFunctions(Date = date)
}
\keyword{IO}
\concept{XML}
\concept{dynamic report generation}
