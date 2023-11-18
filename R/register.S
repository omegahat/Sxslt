SxsltInitializationFunction =
  #
  # Set or retrieve the current global function that is used to initialize the 
  # R module from the R side.
function(func = NULL)  
{
  if(missing(func))
    .Call("R_getInitialModuleFunction", PACKAGE = "Sxslt")
  else
    .Call("R_setInitialModuleFunction", func, PACKAGE = "Sxslt")  
}

RExtensionNamespace = "http://www.r-project.org"

registerXSLFunction <-
function(name, fun, symbol = NULL, uri = RExtensionNamespace, old = FALSE, context = NULL)
{
 name = as(name, "character")
 if(!missing(fun) && is(fun, "XPathNodeSet"))
   fun = unlist(fun[], recursive = FALSE)

 if(missing(fun) || length(fun) == 0 || (is.character(fun) && fun == ""))
   fun <- get(name)
 else if(is.character(fun)) {
   if(exists(fun, mode="function"))
     fun <- get(fun)
   else
       #XXX Potential security issues.
     fun <- eval(parse(text = fun))
 }

 if(is.null(uri) || uri == "") {
   uri <- RExtensionNamespace
 }

 if(!is.function(fun))
  stop("Must register a function")

 val <- .Call("RXSLT_registerFunction",
                as.character(name), fun, as.character(uri), symbol, context,
                PACKAGE = "Sxslt")

 if(old)
    return(val)
 else
    return(TRUE)
}


xsltContextFunction =
function(f)
{
  class(f) <- c(class(f), "XSLTContextFunction")
  f
}  



# Could keep a list for different URIs.
# i.e. each namespace.

z <- (function() {
.RegistrationFunctions <- list()
.namespaces = c(r = RExtensionNamespace )

resolveNamespace =
function(val)
{
  idx = match(val, names(.namespaces))
  if(is.na(idx))
    idx = match(val, .namespaces)

  if(is.na(idx))
    stop("No matching namespace for ", val)

  return(.namespaces[idx])
}  

registerExtension <-
function(ns, ..., .funcs = list())  
{
  .namespaces <<- c(.namespaces, ns)
  .RegistrationFunctions[[ns]] <<- list()
  .Call("R_xsltRegisterExtModule", as.character(ns))
  addXSLTFunctions(..., .namespace = ns, .funcs = .funcs)
  TRUE
}

defaultXSLTInitialization <-
function(uri, ctxt)
{
 u = resolveNamespace(uri)
 funs = .RegistrationFunctions[[u]]

 sapply(seq(along = funs),
         function(i) {
            id = names(funs)[i]
            f = funs[[i]]

            if(!is.function(f)) {
              warning('not registering non-function ', id)
              return(NULL)
            }
            
            if(inherits(f, "ClosureGenerator")) {
               tmp = f()
               sapply(names(tmp),
                       function(id) {
                         registerXSLFunction(id, tmp[[id]], context = ctxt, uri = uri)
                       })
            } else 
               registerXSLFunction(id, f, context = ctxt, uri = uri)
         })
}

addXSLTFunctions <-
function(..., .namespace = "r", .funcs = list(), clear = FALSE)
{

  u = resolveNamespace(.namespace)  
  if(clear) {
    if(u %in% names(.RegistrationFunctions))
       .RegistrationFunctions[[u]] <<- list()
  }

  args <- list(...)
  args <- append(args, .funcs)

  if(is.null(names(args)))
    .RegistrationFunctions[[u]] <<- c(.RegistrationFunctions[[u]], args)
  else
    .RegistrationFunctions[[u]][names(args)] <<- args
  
#  sapply(names(args), function(id) .RegistrationFunctions[[id]] <<- args[[id]])

               # use an mapply here.
  .RegistrationFunctions <<- structure(lapply(names(.RegistrationFunctions),
                                        function(id) {
                                             attr(.RegistrationFunctions[[id]], "xslFuncName") <- id
                                             .RegistrationFunctions[[id]]
                                           }), names = names(.RegistrationFunctions))

  invisible(.RegistrationFunctions)
}
 list(addXSLTFunctions = addXSLTFunctions,
      registerExtension = registerExtension,
      defaultXSLTInitialization = defaultXSLTInitialization,
      getXSLTFunctions = function() .RegistrationFunctions,
      setXSLTFunctions = function(funs) { .RegistrationFunctions <<- funs })
})()

addXSLTFunctions <- z$addXSLTFunctions
getXSLTFunctions <- z$getXSLTFunctions
setXSLTFunctions <- z$setXSLTFunctions
defaultXSLTInitialization <- z$defaultXSLTInitialization
registerXSLTExtension <- z$registerExtension

rm(z)



