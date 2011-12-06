ok <-
#
# Example R function (used in node.xsl and node.xml)
# that access a nodeset and retrieves the nodes and 
# some of their "attributes".
#
function(x)
{
 print(x)
 cat("Number of nodes", length(x), "\n")
 print(class(x[[1]]))
 
 cat("Node name:", x[[1]]$name,"\n")

 cat("Namespace:", x[[1]]$namespace, "\n")
 cat("Length of first node", x[[1]]$length, "\n")
 print(names(x[[1]]$attributes))
 cat("Attribute names and values\n")
 print(x[[1]]$attributes[names(x[[1]]$attributes)])
# print(x[[1]]$children[[1]])

 tmp <- x[[1]]$children[[2]]
 cat("name of second child node of node 1:", tmp$name, "\n")
 cat("length of second child node of node 1:", length(tmp), "\n")

 return(tmp$name)
}


ok1 <-
function(nodeSet)
{
 print(nodeSet[[1]])
 "ok1 return value" 
}

nodes <-
function(els)
{
  cat("\ncall to nodes()\n")
  cat("# nodes:", length(els), "\n")

  cat("length/# nodes of this node: ", xmlSize(els[[1]]$parent), "\n")  
  print(sapply(els, function(x) x$name))
  
  cat("Contents of second node (", els[[2]]$name, ") :", els[[2]]$value, "\n")  
  cat("Class of first node's children attribute:", class(els[[1]]$children), "\n")

  length(els)
}  


bob =
function()
{
  .Call("R_newXMLNode", "bob", c(a= "1"), character(), NULL)  
}
