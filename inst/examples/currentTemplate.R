templateIntrospection =
function(ctxt, node)
{
  template = xsltGetCurrentTemplate(ctxt)

  cat("Current node name:", xmlName(xsltGetCurrentInputNode(ctxt)), "\n")
  print(template)
  paste(xmlName(node[[1]]), "->", template$match)
}

class(templateIntrospection) = "XSLTContextFunction"

doc = xsltApplyStyleSheet("currentTemplate.xml", "currentTemplate.xsl")
cat(saveXML(doc))

