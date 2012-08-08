SkipS4Problem = FALSE

 #setOldClass("XPathNodeSet")
setClass("XPathNodeSet", representation(ref = "externalptr"))

XPathNodeSet =
  #
  # is this used.
  #
function(..., els = list(...), duplicate = FALSE)
{
 if(!is.list(els))
   stop("elements must be in the form a list")
 
 .Call("RXSLT_newXPathNodeSet", els, as.logical(duplicate))
}  


if(!SkipS4Problem) {
setMethod("length", "XPathNodeSet", function(x) .Call("RXSLT_getNodeSetLength", x, PACKAGE = "Sxslt"))

if(!isGeneric("lapply"))
  setGeneric("lapply", function(X, FUN, ...) standardGeneric("lapply"))

if(!isGeneric("sapply"))
  setGeneric("sapply", function(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE) standardGeneric("sapply"))

setMethod("sapply", "XPathNodeSet",
           function(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE) {
              sapply(seq(along = X), function(i) FUN(X[[i]], ...), simplify = simplify, USE.NAMES = USE.NAMES)
           })
}

setGeneric("lapply", function(X, FUN, ...) standardGeneric("lapply"))
setMethod("lapply", "XPathNodeSet",
           function(X, FUN, ...) {
              lapply(seq(along = X), function(i) FUN(X[[i]], ...))
           })






# Should kill this off.  Not exported anymore
"[.XPathNodeSet" <-
function(n, i, j, ...)
{
  if(length(i) != 1)
    stop("Can only subset exactly one element in an XPathNodeSet")
  
 .Call("RXSLT_getNodeSetElement", n, as.integer(i-1)[1], PACKAGE = "Sxslt")
}

"[.XPathNodeSet" <-
function(x, i, j, ..., references = FALSE)
{
  if(missing(i))
    i = seq_len(length(x))
  
  lapply(i, function(idx) x[[idx, reference = references]])
}



setMethod("[[", "XPathNodeSet",
          function(x, i, j, ..., reference = TRUE) 
{
  n = length(x)
  i = i[1]
  if(i < 1 || i > n)
     stop("Can only index elements within 1 to ", n)

  ans = .Call("RXSLT_getNodeSetElement", x, as.integer(i-1), PACKAGE = "Sxslt")
  if(reference)
    ans
  else
    xmlValue(ans)
})

if(!SkipS4Problem) {
if(!isGeneric("unlist"))
  setGeneric("unlist",
              function (x, recursive = TRUE, use.names = TRUE)  
                 standardGeneric("unlist"))

setMethod("unlist", "XPathNodeSet",
           function (x, recursive = TRUE, use.names = TRUE)  {
            x[]
           })
}


setAs("XPathNodeSet", "integer",
       function(from) 
          as(from[], "integer"))

setAs("XPathNodeSet", "character",
       function(from) 
          as(from[], "character"))

          
"[[.XPathNodeSet" <-
function(x, i, j, ...)
{
  n = length(x)
  i = i[1]
  if(i < 1 || i > n)
     stop("Can only index elements within 1 to ", n)

  .Call("RXSLT_getNodeSetElement", x, as.integer(i-1), PACKAGE = "Sxslt")
}

# XMLChildren should be a class.
# Conceptually it is similar to XPathNodeSet if
# feasible.

"[.XMLChildren" <-
function(x, ...)
{
  which <- as.integer(as.integer(list(...)) - 1)
  .Call("RXSLT_getChildren", x, which, PACKAGE = "Sxslt")
}

"[[.XMLChildren" <-
function(x, i)
{
  tmp <- x[i]
  if(!is.null(tmp))
    tmp <- tmp[[1]]

  tmp
}

setOldClass("XMLChildren")

if(FALSE) 
 setMethod("length", "XMLChildren",
           function(x) {
            as.integer(NA) #XXX
           })
