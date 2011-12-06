pkgname <- "Sxslt"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('Sxslt')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("Sxsltproc")
### * Sxsltproc

flush(stderr()); flush(stdout())

### Name: Sxsltproc
### Title: R function mimicing shell command xsltproc
### Aliases: Sxsltproc Rxsltproc
### Keywords: IO

### ** Examples

## Not run: 
##D   # In the shell
##D  Sxsltproc tests/simple.xsl tests/simple.xml
##D  Sxsltproc --param foo "'123'" tests/simple.xsl tests/simple.xml
##D  Sxsltproc --stringparam foo "123" tests/simple.xsl tests/simple.xml
##D  
##D   # In R
##D  Sxsltproc(c("tests/simple.xsl", "tests/simple.xml"))
##D  Sxsltproc(c("--param", "foo", "'123'", "tests/simple.xsl", "tests/simple.xml"))
## End(Not run)



cleanEx()
nameEx("XMLAttributes")
### * XMLAttributes

flush(stderr()); flush(stdout())

### Name: [.XMLAttributes
### Title: Access attributes of XML Node
### Aliases: [.XMLAttributes $.XMLAttributes names.XMLAttributes
### Keywords: IO

### ** Examples

## Not run: 
##D   f <- function(nodeSet) {
##D     node <- nodeSet[[1]]
##D     paste(names(node), collapse=", ")
##D   }
##D   # registerXSLFunction("foo", f)
## End(Not run)



cleanEx()
nameEx("XMLXPathParserContext-class")
### * XMLXPathParserContext-class

flush(stderr()); flush(stdout())

### Name: XMLXPathParserContext-class
### Title: Class representing the internal data structure for an XSL
###   transformation
### Aliases: XMLXPathParserContext-class
###   coerce,XMLXPathParserContext,XSLStyleSheet-method
###   coerce,XMLXPathParserContext,XMLInternalDocument-method
### Keywords: classes

### ** Examples

 showClass("XMLXPathParserContext")



cleanEx()
nameEx("XSLParseEval")
### * XSLParseEval

flush(stderr()); flush(stdout())

### Name: XSLParseEval
### Title: Evaluate an S expression from an XSL string
### Aliases: XSLParseEval XSLNULLParseEval XSLParseEval,character-method
###   XSLParseEval,XMLInternalNode-method XSLParseEvalWithOutput
### Keywords: IO

### ** Examples

 XSLParseEval("rnorm(10)")
 XSLParseEval("rnorm(10)", className = "Array")
 XSLParseEval("rnorm(10)", className = "Array", name="me")



cleanEx()
nameEx("XSLTTransformContext-class")
### * XSLTTransformContext-class

flush(stderr()); flush(stdout())

### Name: XSLTTransformContext-class
### Title: Class "XSLTTransformContext"
### Aliases: XSLTTransformContext-class
###   coerce,XSLTTransformContext,XSLStyleSheet-method
### Keywords: classes

### ** Examples

 showClass("XSLTTransformContext")



cleanEx()
nameEx("XSLTemplateDescription-class")
### * XSLTemplateDescription-class

flush(stderr()); flush(stdout())

### Name: XSLTemplateDescription-class
### Title: Description of an XSL template
### Aliases: XSLTemplateDescription-class
###   XSLCopiedTemplateDescription-class
###   docName,XSLTemplateDescription-method
###   docName,XSLCopiedTemplateDescription-method
###   coerce,XSLTemplateDescription,XSLCopiedTemplateDescription-method
### Keywords: classes

### ** Examples

showClass("XSLTemplateDescription")



cleanEx()
nameEx("addXSLTFunctions")
### * addXSLTFunctions

flush(stderr()); flush(stdout())

### Name: addXSLTFunctions
### Title: Queue R functions to registered as XSL functions.
### Aliases: addXSLTFunctions getXSLTFunctions setXSLTFunctions
###   xsltContextFunction
### Keywords: IO

### ** Examples


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



cleanEx()
nameEx("closureGenerator")
### * closureGenerator

flush(stderr()); flush(stdout())

### Name: closureGenerator
### Title: Programmatically create functions with a shared environment
### Aliases: closureGenerator
### Keywords: programming

### ** Examples


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
  




cleanEx()
nameEx("getTemplate")
### * getTemplate

flush(stderr()); flush(stdout())

### Name: getTemplate
### Title: Find the template to process a node
### Aliases: getTemplate getTemplate,XSLStyleSheet,character-method
###   getTemplate,XSLStyleSheet,XMLInternalNode-method
###   getTemplate,character,character-method
###   getTemplate,character,XMLInternalNode-method
###   getTemplate,XSLTTransformContext,XMLInternalNode-method
###   getTemplate,XSLTTransformContext,missing-method
### Keywords: IO programming

### ** Examples

  
    # A query to see which template handles article.
   #XXX Problem
  temp = getTemplate("http://www.omegahat.org/XDynDocs/XSL/html.xsl", "article")

    # Query a node with a name space so have to create the node
    # (The node does get copied as it has no document which is needed
    # during the creation of the XSL context)
  library(XML)
  node = newXMLNode("r:code", namespaceDefinitions = c(r = "http://www.r-project.org"))
  rcode = getTemplate("http://www.omegahat.org/XDynDocs/XSL/html.xsl", node)

  rcode
  docName(rcode)
  rcode$location
  cat(rcode$node)
 

    # Instead of parsing the style sheet each time, do it once and do
    # multiple queries
  html.sty = xsltParseStyleSheet("http://www.omegahat.org/XDynDocs/XSL/html.xsl")

  rcode = getTemplate(html.sty, 
                      newXMLNode("r:code", namespaceDefinitions = c(r = "http://www.r-project.org")))

  templates = lapply(c("latex", "docbook", "ulink"), function(x)  getTemplate(html.sty, x))
  sapply(templates, docName)



cleanEx()
nameEx("getXSLParams")
### * getXSLParams

flush(stderr()); flush(stdout())

### Name: getXSLParams
### Title: Extract the top-level XSL parameters and default values in an
###   XSL stylesheet
### Aliases: getXSLParams
### Keywords: programming

### ** Examples

  system.file()



cleanEx()
nameEx("libxsltVersion")
### * libxsltVersion

flush(stderr()); flush(stdout())

### Name: libxsltVersion
### Title: Query the version of the libxslt library in use.
### Aliases: libxsltVersion
### Keywords: IO programming

### ** Examples

  libxsltVersion()



cleanEx()
nameEx("registerXSLFunction")
### * registerXSLFunction

flush(stderr()); flush(stdout())

### Name: registerXSLFunction
### Title: Define an XSL extension function
### Aliases: registerXSLFunction
### Keywords: IO

### ** Examples

## Not run: 
##D   registerXSLFunction("init", function(...) { TRUE })
##D   registerXSLFunction("register", function(name, func) { TRUE })
##D   registerXSLFunction("foo", function(x) { cat("in foo\n"); print(x) ; x*2})
##D   registerXSLFunction("bar", function(x,y) { cat("in bar\n"); print(x) ; print(y) ; nchar(x) + nchar(y)})
##D 
##D   xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"),
##D                       system.file("examples", "register.xsl", package = "Sxslt"), FALSE)
## End(Not run)



cleanEx()
nameEx("registerXSLTExtension")
### * registerXSLTExtension

flush(stderr()); flush(stdout())

### Name: registerXSLTExtension
### Title: Register a new XSLT extension namespace
### Aliases: registerXSLTExtension
### Keywords: IO programming

### ** Examples


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



cleanEx()
nameEx("saveXML")
### * saveXML

flush(stderr()); flush(stdout())

### Name: saveXML.XMLInternalXSLTDocument
### Title: Serializes XSLT-processed document to a file or string
### Aliases: saveXML.XMLInternalXSLTDocument
###   saveXML,XMLInternalXSLTDocument-method
### Keywords: IO

### ** Examples

 library(XML)

 doc <- xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"),
                            system.file("examples", "register.xsl", package = "Sxslt"), FALSE)

 cat(saveXML(doc))

 outFile <- tempfile()
 saveXML(doc$doc, outFile)

  # to an R string
 saveXML(doc)

## Not run: 
##D # These files won't exist. Will fix up the example soon!
##D  sheet <- xsltParseStyleSheet("../../../Literate/fragment.xsl")
##D  doc <- xsltApplyStyleSheet("../../../RSXMLObjects/Src/writeRS.xml", sheet)
##D 
##D  cat(saveXML(doc))
##D 
##D  saveXML(doc, "/tmp/foo.xml")
## End(Not run)



cleanEx()
nameEx("toc.XSL")
### * toc.XSL

flush(stderr()); flush(stdout())

### Name: toc.XSL
### Title: Get a table of contents of templates in an XSL document (and
###   imports)
### Aliases: toc.XSL
### Keywords: programming

### ** Examples

library(XML)
  xsl = catalogResolve("http://www.omegahat.org/XDynDocs/XSL/html.xsl")
 
  tmpls = toc.XSL(xsl, recursive = FALSE)

  tmpls = toc.XSL(xsl)

  tmpls = toc.XSL(xsl, ignore = "http://docbook")



cleanEx()
nameEx("xslGlobalParameterNames")
### * xslGlobalParameterNames

flush(stderr()); flush(stdout())

### Name: xslGlobalParameterNames
### Title: Get the names of the top-level/global XSL parameters
### Aliases: xslGlobalParameterNames
### Keywords: IO documentation

### ** Examples

  fun =  function(ctxt, ...) {
    params = xslGlobalParameterNames(ctxt)
    vals = getXSLVariables(ctxt, params)
    print(params)
    print(vals)
    paste(params, vals, sep = " = ", collapse = ", ")
  }

  xsl = '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org" 
                extension-element-prefixes="r" 
                version="1.0">
           <xsl:param name="globalParam" select="1"/>
           <xsl:template match="/">
              Global Parameters: <xsl:value-of select="r:foo()"/>
           </xsl:template>
         </xsl:stylesheet>
        '  

  xml = '<article/>'

  addXSLTFunctions("foo" = xsltContextFunction(fun))

  xsltApplyStyleSheet(xml, xsl, who = "'duncan'", depth = 2L, bob = TRUE)



cleanEx()
nameEx("xsltApplyStyleSheet")
### * xsltApplyStyleSheet

flush(stderr()); flush(stdout())

### Name: xsltApplyStyleSheet
### Title: Process XML document with XSLT stylesheet
### Aliases: xsltApplyStyleSheet
###   xsltApplyStyleSheet,XMLInternalDocument,character-method
###   xsltApplyStyleSheet,XMLInternalDocument,XSLStyleSheet-method
###   xsltApplyStyleSheet,ANY,ANY-method
###   xsltApplyStyleSheet,character,missing-method
###   xsltApplyStyleSheet,character,ANY-method
###   xsltApplyStyleSheet,XMLInternalDocument,missing-method
### Keywords: IO

### ** Examples


 files = sapply(c("sqrt.xml", "sqrt.xsl"), function(f) system.file("examples", f, package = "Sxslt"))
 doc <- xsltApplyStyleSheet(files[1], files[2])

 sheet <- xsltParseStyleSheet(system.file("examples", "params.xsl", package="Sxslt"))
 doc <- xsltApplyStyleSheet("<?xml version='1.0' ?><doc></doc>\n", sheet, isURL= FALSE, myParam="'foo'")


   # Using the style sheet within the input XML document.
 f = system.file("examples", "embeddedXSL.xml", package = "Sxslt")
 z = xsltApplyStyleSheet(f , .merge = "html")


## Not run: 
##D  segments = xsltParseStyleSheet(path.expand("~/Projects/org/omegahat/XML/Literate/segment.xsl"))
##D  doc <- xsltApplyStyleSheet(path.expand("~/Projects/org/omegahat/XML/Literate/examples/functionParts.xml"),
##D                              segments, isURL = FALSE)
##D 
##D  saveXML(doc)
## End(Not run)




cleanEx()
nameEx("xsltGetStyleSheet")
### * xsltGetStyleSheet

flush(stderr()); flush(stdout())

### Name: xsltGetStyleSheet
### Title: Obtain a reference to the XML internal document object for the
###   style sheet or the input XML document.
### Aliases: xsltGetStyleSheet xsltGetInputDocument xsltGetOutputDocument
### Keywords: IO programming

### ** Examples

  # Find the XML and XSL files.
 files = sapply(c("applyTemplates.xml", "applyTemplates.xsl"),
                function(i)
                    system.file("examples", i, package = "Sxslt"))



 z = xsltApplyStyleSheet(files[1], files[2])

 saveXML(z$doc)



### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
