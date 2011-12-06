createInternalNode <-
#
# Simple function that creates an XML/HTML tree
# consisting of an unordered list (<ul>) with
# an element for each of the elements of the `letters'
# vector. Each of the entries within this list is 
# simply
#   <a href="#i">i</a>
# where i is the particular letter.
#
# To see the result, use the command
#
#  saveXML(createInternalNode()$value())
#
function(asNode = TRUE)
{
  dom <- xmlTree()

  dom$addTag("ul", close=F)
   for(i in letters) {
      dom$addTag("li", close=F)
      dom$addTag("a", i, attrs=c(href=paste("#", i, sep="")))
      dom$closeTag()
   }
  dom$closeTag()

  if(asNode)
    return(dom$value()) # do we want the xmlRoot()

  
  invisible(dom)
}
