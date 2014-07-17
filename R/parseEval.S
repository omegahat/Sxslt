setGeneric("XSLParseEval",
           function(cmd, className = NULL, asXML = FALSE, name = NULL, env = globalenv()) {
              standardGeneric("XSLParseEval")
           }
          )

setMethod("XSLParseEval", "character",
function(cmd, className = NULL, asXML = FALSE, name = NULL, env = globalenv())
{
     expr <- parse(text = cmd)
     x <- eval(expr, env)
     
     if(length(class(x)) == 0) {
       if(!missing(className))
          class(x) <-  className
       else if(is.call(expr)) 
          class(x) <- as.character(expr[[1]])
     }

     if(!is.null(name)) 
       assign(name, x, envir = globalenv())

     if(asXML)
       return(toXML(x))  # Where is this defined? In another package.
     else
       return(x)              
})

setMethod("XSLParseEval", "XMLInternalNode",
function(cmd, className = NULL, asXML = FALSE, name=NULL, env = globalenv())
{
   if(tolower(xmlGetAttr(cmd, "eval", "true")) %in% c("false", "no")) {
#     cat("ignoring node", xmlName(cmd), "\n")
     return(NULL)
   }
 
   XSLParseEval(xmlValue(cmd), className, asXML, name, env)
})

XSLNULLParseEval =
function(cmd, className=NULL, name=NULL, env = globalenv())
{
 expr <- parse(text = cmd)
 x <- eval(expr, env)
 if(!is.null(name)) {
     assign(name, x, envir = globalenv())
 }

 NULL 
}

XSLParseEvalWithOutput =
function(cmd, className=NULL, name=NULL, env = globalenv())
{
  paste(capture.output(XSLParseEval(cmd)), collapse = "\n")
}  


