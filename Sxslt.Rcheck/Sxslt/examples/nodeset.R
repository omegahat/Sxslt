bob =
function()
{
  dom = xmlTree()
  dom$addTag("a", close = FALSE)
  dom$addTag("b", "Some text inside node b")
  dom$addTag("c", "text inside c")
  dom$closeTag()

   z = xmlRoot(dom$value())
   structure(list(z), class = "XMLNodeList")
}

b =
function()
{
  cat("In function b()\n")
  newXMLNode("person",
              newXMLNode("firstname", "Duncan"),
              newXMLNode("surname", "Temple Lang"),             
              attrs = c(id= "123"))
}  

k =
function()
{
  dom = xmlTree()
  dom$addTag("a", close = FALSE)
  dom$addTag("b", "Some text inside node b")
  dom$addTag("c", "text inside c")
  dom$closeTag()

  dom$value()
}  

ns =
function()
{

  dom = xmlTree()
  dom$addTag("a", close = FALSE)
  dom$addTag("b", "Some text inside node b")
  dom$addTag("c", "text inside c")
  dom$closeTag()

  ans = XPathNodeSet( els = xmlChildren(xmlRoot(dom$value())))

  cat("# nodes", length(ans), "\n")
  ans
}

withContext =
function(ctxt)
{
  print(ctxt)
  pi
}
class(withContext) <- "XSLTContextFunction"

