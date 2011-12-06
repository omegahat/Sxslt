\name{xsltApplyStyleSheet}
\alias{xsltApplyStyleSheet}
\alias{xsltApplyStyleSheet,XMLInternalDocument,character-method}
\alias{xsltApplyStyleSheet,XMLInternalDocument,XSLStyleSheet-method}
%\alias{xsltApplyStyleSheet.XMLInternalDocument}
\alias{xsltApplyStyleSheet,ANY,ANY-method}
\alias{xsltApplyStyleSheet,character,missing-method}
\alias{xsltApplyStyleSheet,character,ANY-method}
\alias{xsltApplyStyleSheet,XMLInternalDocument,missing-method}
\title{Process XML document with XSLT stylesheet}
\description{
  From within R, this applies the rules in the specified
  stylesheet to the given XML document given either
  as the name of a file/URI, string containing
  the XML, or an internal DOM constructued
  using \code{\link[XML]{xmlTree}}
  and creates a new document as a result of the transformation. 
}
\usage{
xsltApplyStyleSheet(fileName, sheet,
                     isURL = length(grep("^(http|ftp)", fileName)) > 0,
                     xinclude = TRUE, ..., .params = character(0),
		     .profile = FALSE, .merge = TRUE,
		     .errorFun = xmlErrorCumulator("XSLErrorList"))
}
\arguments{
  \item{fileName}{the name of the file containing the XML document to
    process or alternatively a string containing the XML content directly.}
  \item{sheet}{the \code{XSLTStylesheet} object created
    via \code{\link{xsltParseStyleSheet}} that contains the rules
    with which to process the XML document.}
  \item{isURL}{a logical value indicating whether the \code{fileName}
    argument refers to a URI. This can be used to explicitly override
  the default detection mechanism.}
  \item{\dots}{any number of \code{name=value} pairs which are taken as
   XSLT parameters to use in the processing.}
 \item{.params}{an alternative mechanism to the \dots for specifying
      the parameters. This is a named character vector giving the
      \code{name = value} pairs of parameters.
      These values are merged with any in the \dots arguments.
      Elements in \dots with the same name as in \code{.params}
      are used in preference to those in \code{.params}.
      Therefore, only those elements of \code{.params}
      whose names are not in \dots are added to \dots
      to make up the list of properties.
      These two arguments allow the caller to specify a
      persistent set across calls via the .params
      and to override individual values within that set
      for specific calls to \code{xsltApplyStyleSheet}.
    }
    \item{xinclude}{a logical value indicating whether to enable 
      XInclude support during the processing of the XML document.
    }
  \item{.profile}{a logical value, a string or a function indicating that profiling
  of the XSL operations  should be done and the results returned as a
  data frame (via \code{readXSLProfileData})
  or written to the file given by this name.
   If a function is provided, it will be invoked with one argument
   which is an \code{\link[XML]{XMLInternalDocument-class}} object.
   See \code{readXSLProfileData} for an example of how to parse this
   material.  For most situations, it is easiest to use this and work with
   the subsequent results. The measurements are in milliseconds.
  }
  \item{.merge}{either a string or a logical value that controls
    whether the function searches for an XSL style sheet within the
    XML document itself and uses that along with any style sheet
    specified via the \code{sheet} argument.
   If this is \code{FALSE}, no attempt to find a style sheet in the
   XML document is used.
   If this is \code{TRUE}, the first and hopefully only 
   \code{<xsl:stylesheet>} node is used as the  top-level style sheet.
   If it doesn't exist, an error occurs.
   If the value of \code{.merge}  is a string, then we use this to
   find an    \code{<xsl:stylesheet>}  with
   a \code{format} attribute that matches this value,
    i.e. the XPath expression 
      \code{"//xsl:stylesheet[@format='html']"}.

  If a style sheet is used from the input XML document,
  any style sheet specified via the \code{sheet} argument
  is imported into that top-level sheet, i.e. the equivalent of 
    \code{<xsl:import href="xsl"/>}.

   If more contol is needed over how the style sheets are merged, see 
   \code{mergeXSL} in the package.
  }
  \item{.errorFun}{an R function (or \code{NULL}) that is invoked as
     each error is encountered during the XSL transformation process.
    This can raise an error in R or allow the process to continue,
    collecting more errors should they occur so that a user can fix
    many together.. This is the same as the \code{error} parameter in 
    \code{\link[XML]{xmlTreeParse}} and related functions.}
}
\value{
  An object of class \code{XMLInternalXSLTDocument}
  which has three slots:
  \item{doc}{ a reference to the native (C-level) XML document.}
  \item{stylesheet}{a reference to the native (C-level) XSLT stylesheet
    used to process the original document. This is needed to serialize
    the newly created document.}
  \item{status}{an integer value which is either
    an \code{NA} or the state of the XSL transformation context
    when the transformation concluded. The possible values are
    OK = 0,  ERROR = 1, STOPPED = 2. The name is on the vector if it is
    not \code{NA}. This allows us to determine whether an error occurred,
   with 0 being the value if all was well. If \code{status} is
   \code{NA}, we cannot tell.  This only happens when we are profiling
   the XSL processing.}

}
\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}
  \url{http://xmlsoft.org/XSLT}
  htt}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
  \code{\link[XML]{saveXML}}
  \code{\link{xsltParseStyleSheet}}
}    


\examples{

 files = sapply(c("sqrt.xml", "sqrt.xsl"), function(f) system.file("examples", f, package = "Sxslt"))
 doc <- xsltApplyStyleSheet(files[1], files[2])

 sheet <- xsltParseStyleSheet(system.file("examples", "params.xsl", package="Sxslt"))
 doc <- xsltApplyStyleSheet("<?xml version='1.0' ?><doc></doc>\n", sheet, isURL= FALSE, myParam="'foo'")


   # Using the style sheet within the input XML document.
 f = system.file("examples", "embeddedXSL.xml", package = "Sxslt")
 z = xsltApplyStyleSheet(f , .merge = "html")


\dontrun{
 segments = xsltParseStyleSheet(path.expand("~/Projects/org/omegahat/XML/Literate/segment.xsl"))
 doc <- xsltApplyStyleSheet(path.expand("~/Projects/org/omegahat/XML/Literate/examples/functionParts.xml"),
                             segments, isURL = FALSE)

 saveXML(doc)
}

}

\keyword{IO}
\concept{XML}
\concept{dynamic content}
