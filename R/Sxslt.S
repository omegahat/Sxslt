xsltParse <- xsltParseStyleSheet <-
function(fileName, isURL = is(fileName, "character") && length(grep("^(http|ftp)", fileName)) > 0)
{
    # if we are given an XMLInternalDocument, just pass that on to the C routine.
    # Alternatively, if we are dealing with a string/character vector, then
    # we see if it is a URL, or if the string identifies a file or else we parse the content
    # directly as  in-memory text.
  if(!is(fileName, "XMLInternalDocument")) {
    if(is.character(fileName)) {
      if(isURL)
         TRUE
      else if(file.exists(fileName)) 
        fileName <- path.expand(fileName)
      else 
        fileName <- xmlParse(as.character(fileName), asText = TRUE)

    } else
       stop("need an XMLInternalDocumet or a character vector")
  }
  
  ref = .Call("S_parseStylesheet", fileName, PACKAGE = "Sxslt")
  if(is.null(ref))
    stop("Error parsing stylesheet ", fileName)
  else
    ref
   # new("XSLStyleSheet", ref = ref)
}  

#
# We extend this to allow the caller to just provide the file name and allow that XML to have 
# a style sheet within it. In fact, it can have several stylesheets for different target formats.
# The caller can omit sheet.  If there is only one xsl:stylesheet node within the input document,
# that is used.
#  If no sheet is provided, we use the one in the 
#
#  .merge should be either TRUE or FALSE or a string used to identify the format of the 
#  stylesheet of interest, i.e. match the @format attribute.
#

#
setGeneric("xsltApplyStyleSheet",
           function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE, ...,
                    .params = character(0), .profile = FALSE, .merge = TRUE, 
                    .errorFun = xmlErrorCumulator("XSLErrorList"))
            standardGeneric("xsltApplyStyleSheet")
          )


#xsltApply = xsltApplyStyleSheet


setMethod("xsltApplyStyleSheet",
            # just the document, no style sheet so parse the doc. and pass it along
          c("character", "missing"),
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE, ...,
                   .params = character(0), .profile = FALSE, .merge = TRUE,
                   .errorFun = xmlErrorCumulator("XSLErrorList"))
            {
              doc = xmlInternalTreeParse(fileName)
              xsltApplyStyleSheet(doc, ,  , xinclude, ..., .params = .params, .profile = .profile, .merge = .merge,
                                      .errorFun = .errorFun)
            })

setMethod("xsltApplyStyleSheet",
            # just the parsed document, no style sheet so get the style sheet
            # from the input document and pass it along          
          c("XMLInternalDocument", "missing"),
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE, ...,
                   .params = character(0), .profile = FALSE, .merge = TRUE,
                   .errorFun = xmlErrorCumulator("XSLErrorList"))
            {
               sheet = mergeXSL(fileName, , .merge, local = TRUE)
               xsltApplyStyleSheet(fileName, sheet, ,xinclude, ..., .params = .params, .profile = .profile, .merge = FALSE,
                                      .errorFun = .errorFun)               
            })

setMethod("xsltApplyStyleSheet",
          c("XMLInternalDocument", "XSLStyleSheet"),
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE, ...,
                   .params = character(0), .profile = FALSE, .merge = TRUE,
                   .errorFun = xmlErrorCumulator("XSLErrorList"))
            {

              if(is.character(.merge) || (is.logical(.merge) && .merge)) 
                sheet = mergeXSL(fileName, sheet, .merge)
              
              .params <- mergeXSLTParams(..., .params = .params)

              old = xinclude()
              xinclude(xinclude)
              on.exit(xinclude(old))

              read = FALSE

                 # .profile should end up being FALSE, a function (taking an XMLInternalDocument)
                 # or a string naming a file.
              if(!is.logical(.profile) && !is.function(.profile))
                .profile = as.character(.profile)
              else if(is.logical(.profile) && .profile)
                .profile = readXSLProfileData


              if(is.null(.errorFun))
                .errorFun = xslRError
              
              ans = .Call("S_applySheetToDOM", fileName, sheet, .params, .profile, .errorFun, PACKAGE = "Sxslt")

              if(is.list(ans) && length(ans) == 2)
                names(ans) = c("document", "profiling")
#            if(read) {
#              prof = readXSLProfileResults(.profile)
#              list(doc = ans, profile = prof)
#            } else
                ans
           })



setMethod("xsltApplyStyleSheet",
          c("XMLInternalDocument", "character"),
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE, ...,
                   .params = character(0), .profile = FALSE, .merge = TRUE,
                   .errorFun = xmlErrorCumulator("XSLErrorList"))
            {
                if(is.character(.merge) || (is.logical(.merge) && .merge)) 
                  style = mergeXSL(fileName, sheet, .merge)
                else {
                  style <- xsltParseStyleSheet(sheet[1])
                  style = xslImportStyleSheets(style, sheet[-1])
                }
                
                xsltApplyStyleSheet(fileName, style, isURL, xinclude, ..., .params = .params, .profile = .profile,
                                    .merge = FALSE, .errorFun = .errorFun)
            })


setMethod("xsltApplyStyleSheet",
          c("character"),  
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE,
                    ..., .params = character(0), .profile = FALSE, .merge = TRUE,
                    .errorFun = xmlErrorCumulator("XSLErrorList"))
          {
              doc = xmlParse(fileName)
              xsltApplyStyleSheet(doc, sheet, FALSE, xinclude, ..., .params = .params, .profile = .profile,
                                    .merge = .merge, .errorFun = .errorFun)              
          })


setMethod("xsltApplyStyleSheet",
          c("ANY"),  
          function(fileName, sheet, isURL = length(grep("^(http|ftp)", fileName)) > 0, xinclude = TRUE,
                    ..., .params = character(0), .profile = FALSE, .merge = TRUE,
                    .errorFun = xmlErrorCumulator("XSLErrorList"))
          {
              #  handle the .merge
            if(is.character(.merge) || (is.logical(.merge) && .merge))
               sheet = mergeXSL(fileName, sheet, .merge)
              
            isText <- FALSE
            if(!isURL) {
              if(file.exists(fileName))
                fileName <- path.expand(fileName)       
              else {
                isText <- TRUE
                fileName <- as.character(fileName)
              }
            }


            if(!is.logical(.profile) || .profile ) {
              doc = xmlParse(fileName)
              return(xsltApplyStyleSheet(doc, sheet, isURL, xinclude, ..., .params = .params, .profile = .profile,
                                         .merge = .merge, .errorFun = .errorFun))
            }
            
            .params <- mergeXSLTParams(..., .params = .params)

            if(is.character(sheet)) {
              style <- xsltParseStyleSheet(sheet[1])
              style = xslImportStyleSheets(style, sheet[-1])              
            } else
              style = sheet

            old = xinclude()
            xinclude(xinclude)
            on.exit(xinclude(old))
           
            .Call("S_applySheet", as.character(fileName), as.logical(isText),
                                 style, .params, xinclude, .errorFun, PACKAGE = "Sxslt")
          })



#########################################################################################################


xslImportStyleSheets =
function(style, sheets, import = TRUE)
{
  lapply(sheets,
           function(x) {
             n = newXMLNode("xsl:import",
                            attrs = c("href" = x),
                            namespace = c("xsl" =  "http://www.w3.org/1999/XSL/Transform"))
             .Call("R_xsltParseStylesheetImport", style, n, as.logical(import))
           })                  
  style
}



setOldClass("XMLInternalXSLTDocument")
setOldClass("XSLTemplateDescription")

saveXML.XMLInternalXSLTDocument <-
function(doc, file = NULL, compression = 0, indent = TRUE,
         prefix = "<?xml version=\"1.0\"?>\n",
         doctype = NULL, encoding = "", ...)  
{
 if(is.null(file))
   .Call("S_saveXMLDocToString", doc, as.character(encoding), PACKAGE = "Sxslt")
 else {
   file = normalizePath(path.expand(as.character(file)), mustWork = FALSE)
   .Call("S_saveXMLDocToFile", doc, file, as.integer(compression), PACKAGE = "Sxslt")
 }
}  

if(isGeneric("saveXML"))
  setMethod("saveXML", "XMLInternalXSLTDocument", saveXML.XMLInternalXSLTDocument)


getXSLVariables =
  #
  # XXX simplify is not used
  #  document uris
  #  Why do we need uris and nsDefs ?
  #
function(ctxt, vars, uris = names(vars), nsDefs = xmlNamespaceDefinitions(as(ctxt, "XMLInternalDocument"), simplify = TRUE))
{
  vars = as(vars, "character")

  if(length(nsDefs)) {
    i = grep(":", vars)
    tmp = strsplit(vars[i], ":")
    ns = sapply(tmp, function(x) x[1])
    u = match(ns, names(nsDefs))
    if(any(is.na(u)))
      warning("no namespace definition specified for ", paste(ns[is.na(u)], collapse = ", "))
    uris[i] = nsDefs[u]
    vars = gsub(".*:", "", vars)
  }
  
  if(is.null(uris))
    uris <- rep("", length(vars))
  uris = as.character(uris)
  if(length(uris) != length(vars))
    length(uris) = length(vars)

  ans = .Call("RXSLT_getXSLVariable", ctxt, vars, uris)
  names(ans) = vars
  ans
}  


xinclude =
function(status = integer())
{
  .Call("R_setXInclude", as.logical(status))
}  



xslRError =
function(msg)
{
  e = simpleError(msg)
  class(e) = c("XSLError", class(e))
  
  stop(e)
}  


