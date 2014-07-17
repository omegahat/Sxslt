#
# Here we provide functionality that allows us to merge a stylesheet within an XML 
# document with another style sheet
#
# A half-assed version.

FO.ns = c(fo="http://www.w3.org/1999/XSL/Format")

mergeXSL =
  #
  #
  # e.g.
  #  z = mergeXSL("~/Projects/org/omegahat/XML/XSL/S/libxslt/examples/embeddedXSL.xml",
  #               "http://www.omegahat.org/IDynDocs/XSL/dynRFO.xsl")
  #  v = xsltApplyStyleSheet("~/Projects/org/omegahat/XML/XSL/S/libxslt/examples/embeddedXSL.xml", z)
  #  saveXML(v)

  #  doc - the XML document that might contain the embedded stylesheet
  #  local - logical indicating whether the style sheet in the XML document is considered the master
  #      and the ones referenced in the <r:arg>xsl</r:arg> parameter are to be imported.
  #
  #  import - logical indicating whether to import include the xsl files into the local master style sheet.
function(doc, xsl = character(), format = "fo",
         xpath = c(paste("//xsl:stylesheet[@format = '", tolower(format), "']", sep = ""),
                         "//xsl:stylesheet"),
         local = TRUE, import = TRUE
        )
{
  if(is.character(doc))
     doc = xmlParse(doc)

  for(i in xpath) {
    sty = getNodeSet(doc, i, c(xsl= "http://www.w3.org/1999/XSL/Transform"))
    if(length(sty))
      break
  }

  if(length(sty) == 0)
    return(xsl)
    
  if(inherits(sty, "XMLNodeSet") && length(sty) == 1)
     sty = sty[[1]]


    # If the style sheet node is just used to give a URI, then use that.
    # This should be moved to or coordinted with xsltApplyStyleSheet() when
    # there is no style sheet specified, just the XML file.
    # Better off putting in an explicit xsl:import!
  if(xmlSize(sty) == 0 && "href" %in% names(xmlAttrs(sty))) 
     return( xsltParseStyleSheet(xmlGetAttr(sty, "href")) )

  
    # if not local, then we use the given xsl file(s) and
    # add the stylesheet nodes in 
  if(!local) {
    if(is.character(xsl))
      style = xmlInternalTreeParse(xsl)
    else
      style = as(xsl, "XMLInternalDocument")

    xmlSApply(sty, function(x) cat(saveXML(x), "\n\n"))
    root = xmlRoot(style)
        # skip over top-level comments, etc.
        #XX put this into xmlRoot() itself. Looks like it is already there with the skip = TRUE
    while(!is.null(root) && !inherits(root, "XMLInternalElementNode")) 
        root = getSibling(root)


    addChildren(root, kids = xmlChildren(sty))    

    cat(saveXML(style))
    
    style = xsltParseStyleSheet(xsl)

      # XXX do we need to re-compile the style sheet.
      # If so, add the children to the XMLInternalDocument and then
      # parse the style sheet.

    return(style)
  }
  

    # Now we'll deal with the case where the style sheet in the XML document
    # is the master and we will add import/include nodes  for the given xsl files

    # Create a new document with the stylesheet as its node and then
    #
  new.doc = .Call("RS_XML_createDocFromNode", sty, PACKAGE = "XML")
  sty = xmlRoot(new.doc)

    # Add a node to ignore xsl:stylesheet or xsl:stylesheets nodes so that the style sheet will
    # be discarded.
    # Allow for XSL file not be specified and just use the one in the XML document.
  if(length(xsl)) {
     newXMLNode("xsl:template", attrs = c(match = "xsl:stylesheet|xsl:stylesheets"), parent = sty)

     if(is.character(xsl)) 
       xsl.name = xsl
     else 
       xsl.name = docName(as(xsl, "XMLInternalDocument"))

     newXMLNode("xsl:import", attrs = c(href = xsl.name), parent = sty, at = 0)
   }

    # Parse the style sheet and add the imports to complete the new style sheet 
  sty = xsltParseStyleSheet(new.doc)
#  importStyleSheets(sty, xsl, import)

  sty
}



processXInclude.XPathNodeSet =
function(node, flags = 0L)
 sapply(seq(along = node),  function(i) processXInclude(node[[i]]))

