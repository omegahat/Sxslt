processXSLXInclude =
  #
  # This is like processXInclude() in XML, but 
  # is different
  #
function(node)
{
    # just the node, not the nodeset
  node = node[[1]]
    # Create a new document
  doc = newXMLDoc()
    # for now, wrap the xi:include node in a top-level node
    # can do it directly, but the resulting document ends up being
    # slightly odd.
#  addChildren(doc, newXMLNode("doc", node))
  addChildren(doc, node)

    # Do the XInclude
  processXInclude(xmlRoot(node))
#  ans = xmlChildren(xmlRoot(doc))
  ans = xmlChildren(doc)
  XPathNodeSet(els = ans, duplicate = TRUE)
}
