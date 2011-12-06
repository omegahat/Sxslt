\name{closureGenerator}
\alias{closureGenerator}
\title{Programmatically create functions with a shared environment}
\description{
  This function returns a function which, each time it is called,
  creates a new list of functions all of which share the same
  environment and so have access to shared non-local variables
  whose values persist across calls to these functions.
  The function returned by a call to \code{closureGenerator}
  is identified as a special function with this characteristic
  by its S3 class \code{ClosureGenerator}.

  This function allows the caller of the \code{closureGenerator}
  or the caller of the function it creates to specify the
  environment to associate with each function and also
  to provide a list of variables which will be assigned into
  to the environment.
  In addition to these variables, each function
  will be able to "see" (i.e. access) all of the other functions
  as they are assigned into the environment using the names
  in the list.

  This is used when registering a function as an XSLT extension
  function. Rather than registering a ClosureGenerator function,
  the registration mechanism invokes this function and
  registers the functions it returns, not the original function.
}
\usage{
closureGenerator(..., .funs = list(...), .vars = list(), .env = new.env())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{\code{name = function} pairs. This is the form of the list
    that is returned by calling the function this function returns.
    However, the functions will have been assigned the relevant
    environment, but the names will remain the same.
  }
  \item{.funs}{an alternative way to specify the name = function pairs
    other than \dots.  This is useful when the collection of functions is
    already in list-form and it is incovenient to call \code{do.call}
    to pass them via the \dots mechanism.
  }
  \item{.vars}{a list of name = value pairs specifying any variables
    that are to be copied into the environment that will be associated
    with, and shared by, each function.
    These can be overridden in the call to the function that
    \code{closureGenerator} returns.
   }
  \item{.env}{the environment which is to be associated with each of the
    functions when the returned function is invoked.
    This can be specified in the call to the returned function, in the
    same manner as \code{.vars}.
  }
}

\value{
  A function of class \code{ClosureGenerator}.
  That function will return a list of functions
  which will have the same environment.
}
\author{Duncan Temple Lang}
\seealso{
  \code{\link{addXSLTFunctions}}
  \code{\link{registerXSLFunction}}
}
\examples{

  # This is a silly example only to illustrate the
  # mechanism.
  # We have two functions that share a common variable
  #  count
  # Each returns a value but records how often it was called

 a = function(size = 10, p = .5) {
    count["a"] <<- count["a"] + 1
    rbinom(1, size, p)
 }

 b = function(lambda = 5) {
    count["b"] <<- count["b"] + 1
    rpois(1, lambda)
 }

 numCount <-
  function(which = character()) {
     if(length(which))
        count[which]
     else
        sum(count)
  }

  f = closureGenerator(binomial = a, poisson = b, counts = numCount,
                       .vars = list(count = c(a = 0, b = 0)))

  addXSLTFunctions(f)

  stylesheet = system.file("examples", "closureCount.xsl", package = "Sxslt")

  z = xsltApplyStyleSheet("<?xml version='1.0'?><doc/>", stylesheet)
  library(XML)
  cat(saveXML(z))

     # Now do it again and we get a new set of counts.
  z = xsltApplyStyleSheet("<?xml version='1.0'?><doc/>", stylesheet)
  cat(saveXML(z))


   # If we really wanted to have the number of counts cumulate across
   # all calls to  xsltApplyStyleSheet(), then we would register the
   # functions themselves.

      # call the closure generator function ourselves
      # and register the individual functions returned by that
      # not the closureGenerator. These are function objects that will be
      # added to each XSLT context.
  addXSLTFunctions(.funcs = f(), clear = TRUE)

      # apply the stylesheet twice
  for(i in 1:2) 
     z = xsltApplyStyleSheet("<?xml version='1.0'?><doc/>", stylesheet)

      # We should see 8 calls to the functions, not 4.
  cat(saveXML(z))


 # For a real example, see dynamic.R in XML/Literate/ in the
 # org/omegahat repository, i.e. the SXMLDocs package.
  

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{programming}
\concept{closures}
\concept{shared persistent variables}
