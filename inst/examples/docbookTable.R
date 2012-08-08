
MatrixToDBTable =
function(obj, ...)
{

  tbl = newXMLNode("table")
  tgroup = newXMLNode("tgroup", attrs = c(cols = ncol(obj)),  parent = tbl)

  els = sapply(1:nrow(obj),
            function(i) {
               newXMLNode("row", .children = sapply(1:ncol(obj),
                                                     function(j) newXMLNode("entry", as.character(obj[i, j]))))
             })
  addChildren(tgroup, kids = els)
  tbl
}  


if(FALSE) {
m = matrix(1:12, 3, 4)
v = MatrixToDBTable(m)
xsl = xsltParseStyleSheet("~/Projects/org/omegahat/Docs/XSL/Rhtml.xsl")
saveXML(xsltApplyStyleSheet(xmlDoc(v), xsl))
}
