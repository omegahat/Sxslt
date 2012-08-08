if(FALSE) {

#addXSLTFunctions("graphicsEval" = IDynDocs:::graphicsEval)
addXSLTFunctions(
                 "graphicsEvalWithData" =
                  function(nodeset, data){
                    data = loadData(data, TRUE)[[1]]
                    filename = tempfile()
                    jpeg(filename)
                    node = nodeset[[1]]
                    expr = parse(text = xmlValue(node))
                       # equivalent of with(data, expr)
                    eval(expr, data)
                    dev.off()
                    filename
                  }, "graphicsEval" =
                  function(nodeset){
                    node = nodeset[[1]]
                    filename = tempfile()
                    jpeg(filename)
                    x = eval(parse(text = xmlValue(node)))
                    dev.off()
                    filename
                  })
saveXML(xsltApplyStyleSheet("hw.xml", "hw.xsl", xinclude = FALSE, due = "Friday", solutions = TRUE), "hw.html")
}


loadData =
function(nodes, anonymous = FALSE)
{
 data =
   lapply(nodes,
         function(node) {
            format = xmlGetAttr(node, "r:format", "dget")
            txt = xmlValue(node)
            ans = dget(textConnection(txt))

            if(!anonymous)
              return(ans)
            
            if(!is.na(varName <- xmlGetAttr(node, "r:var", NA)))
               assign(varName, ans, globalenv())
          })


  if(anonymous)
    data
  else
    TRUE
}




foo =
function(ctxt, node)
{
  print(ctxt)
  tmpl = xsltGetCurrentTemplate(ctxt)
  cnode = xsltGetCurrentInputNode(ctxt)

  TRUE
}
class(foo) = "XSLTContextFunction"
