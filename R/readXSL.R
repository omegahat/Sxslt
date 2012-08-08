XSLNS = c("xsl" = "http://www.w3.org/1999/XSL/Transform")

readXSL =
  #
  # This is different from xsltParseStyleSheet()
  # in that it reads the XSL document as an XML document
  # and optionally imports <xsl:import> files.
  # One can then query the XSL document using XPath.
  # xsltParseStyleSheet() parses the XSL into a structure
  # that can be used for transforming other XML documents.
  #
  # Can we get this information from the xsltParseStyleSheet() ?
  #  e.g. xsltStyleItemParam  and looking at the xsltStyleType field
  #  for a XSLT_FUNC_PARAM.
  #
  #
  #  xslImportStyleSheets() is not related to this. It is for adding <xsl:import> nodes to
  #  a stylesheet.
  #
  #  Imports and includes are different and should behave differently.
  #
  #
function(doc, asText = !file.exists(doc), recursive = TRUE, base = character())
{
  if(is.character(doc)) {
     xsl = xmlParse(doc)
  } else {
     xsl = doc
     doc = docName(doc)     
 }
  
  inc = getNodeSet(xsl, "/*/xsl:import|/*/xsl:include", XSLNS)

  sapply(inc, includeXSLNode, base = doc, recursive = recursive)

  xsl
}

includeXSLNode =
  #
  #  Perform the include by _currently_ reading the included XSL document
  #  and adding its root  in place of the xsl:import or xsl:include node .
  # We will probably change this in the future to include the contents
  # and not the xsl:stylesheet.
  #
function(node, base, recursive = TRUE)
{
   doc = xmlGetAttr(node, "href")
   if(length(grep("^((https?|file):|/)", doc)) == 0) {
     doc =  paste(dirname(base), doc, sep = .Platform$file.sep)
   }
   
   xdoc = xmlParse(doc)

   if(recursive)
     readXSL(xdoc, FALSE, recursive = TRUE, base = doc)

   pos = XML:::indexOfNode(node)
          # Really want to add the xmlChildren(xmlRoot(xdoc)) but this is frighteningly slow!
   addChildren(xmlParent(node), kids = list(xmlRoot(xdoc)), at = pos)
   removeNodes(node)
   TRUE
}
         

getXSLParams =
  #
function(doc, recursive = TRUE)
{
   xsl = readXSL(doc, recursive = recursive)
       # We use //xsl:stylesheet/xsl:param as we are current inserting the xsl:stylesheet
       # node of the import/included stylesheets rather than their children.
   nodes = getNodeSet(xsl, "//xsl:stylesheet/xsl:param", XSLNS)
   structure(sapply(nodes, function(x) if(xmlSize(x) > 0) xmlValue(x) else xmlGetAttr(x, "select")),
             names = sapply(nodes, xmlGetAttr, "name"))
}
