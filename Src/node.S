nodeElements <-
c("name" = 1, 
  "length" = 2, 
  "children" = 3, 
  "doc" = 4, 
  "attributes" = 5, 
  "namespace" = 6, 
  "namespaces" = 7,
  "sibling" = 8, 
  "parent" = 9,
  "value" = 10)

storage.mode(nodeElements) <- "integer"

setOldClass("XMLNodeRef")

# setMethod("names", "XMLNodeRef", function(x) nodeElements)

"$.XMLNodeRef" <-
function(node, name)
{
 if(is.character(name)) {
  which <- match(name, names(nodeElements))
  if(is.na(which))
    stop("no such element ", name, " in an XMLNodeRef object")
 } else
  which <- as.integer(name)

 .Call("RXSLT_getNodeAttribute", node, as.integer(which), PACKAGE = "Sxslt")
}

"$.XMLAttributes" <-
function(x, name)
{
  x[name]
}

"[.XMLAttributes" <-
function(x, name)
{
  .Call("RXSLT_getAttribute", x, as.character(name), PACKAGE = "Sxslt")
}

names.XMLAttributes <-
function(x)
{
 .Call("RXSLT_getAttributeNames", x, PACKAGE = "Sxslt")
}
