#
# This is intended to illustrate how we can program
# XSL operations from within R even if the XSL operations
# are not there to insert the values back into the output
# document or provide us with the relevant nodes in the call
# to R functions.
# We want to be able to fetch nodes and extract their content
# and create output and put it into the output tree.

# We might also want to call <xsl:apply-templates> on a node
# but we can do this with RXSLT_processOneNode

# RXSLT_applyTemplates is not functioning at present.

#
#
#  We need to be able to find the template node of interest in the
# stylesheet.  And we need to identify the target node(s) that would
# emerge from the select expression in XSL. So we need access to the
# to xmlDocPtr - the original document, and the stylesheet document.
# Then we can find both and call RXSLT_applyTemplates in the C code.
# For all of this, we need the xmlXPathParseContextPtr context.




addXSLTFunctions(insert = xsltContextFunction(function(ctx) {

                      doc = xsltGetXML(ctx)
                      sects = getNodeSet(doc, "/doc/section")
                      els = lapply(seq(along = sects),
                                        function(i) {
                                            newXMLTextNode(paste(i, ") ", xmlValue(sects[[i]]), sep = ""))
                                        })

                           # insert text or a node (albeit a silly one!).
                      xsltInsert(ctx, "Table of Contents")                      
                      xsltInsert(ctx,  newXMLNode("pre", .children = els))
                      TRUE
                 }),
                 add = xsltContextFunction(function(ctx) {
                      cur = xsltGetInsertNode(ctx)
                      addChildren(cur, newXMLTextNode("And more text added directly from R"))
                      TRUE
                 }),
                 jane = xsltContextFunction(function(ctx) {

                      doc = xsltGetXML(ctx)
                      sects = getNodeSet(doc, "/doc/section")
                      els = lapply(sects,
                                   function(x) {
                                       newXMLNode("li", xmlValue(x))
                                   })
                      n = newXMLNode("ol", .children = els)
                      n
                 }),
                 bob = xsltContextFunction(function(ctx, node) {

                                                  # illustrates how we can fabricate a new node
                                                  # and apply an existing template to it to have the
                                                  # results inserted into the currently active node
                                                  # of the output document.
                                               xsltProcessNode(ctx, newXMLNode("toc"))
                                               return(TRUE)
                                             }),
                 g = xsltContextFunction(function(ctx, node) {
                             # test processOneNode
                           xsltProcessNode(ctx, node[[1]])
                           return(TRUE)
                 }),
                 h = xsltContextFunction(function(ctx, node) {
            
                          # get the stylesheet document and then look for the
                          #  node <xsl:template name="foo">
                        sh = xsltGetStyleSheet(ctx)                                                
                        temp = getNodeSet(sh, "//xsl:template[@name='foo']",
                                               c(xsl="http://www.w3.org/1999/XSL/Transform"))

                          # If we didn't find it, bail out. 
                        if(is.null(temp) || is.null(temp[[1]]))
                          return(FALSE)

                          # Now, we are going to call that named template and give it a node,
                          # specifically the one we were called with.
                        cat("Applying template from R with name='foo'\n")
                          # provide our own value for the parameter
                        xsltCallTemplate(ctx, node[[1]], temp[[1]], x = "abc")
                          # give a different node, the first section.
                        cat("Node name in call-template", xmlName(node[[1]][[1]][[1]]), "\n")
                        xsltCallTemplate(ctx, node[[1]][[1]][[1]], "foo")
                        cat("Done with applying template from within R.\n")


                     if(FALSE) {
                       #??? Doesn't work !
                        xsl = newXMLNode("xsl:apply-templates", namespaceDefinitions = c(xsl="http://www.w3.org/1999/XSL/Transform" ))
                        dummy = newXMLNode("dummy")
                        x = .Call("RXSLT_applyTemplates", ctx, dummy, xsl)
                        print(x)
                        browser()
                      }
                        
                         #XXX this doesn't behave as expected/desired yet.
#                        cat("Calling RXSLT_applyTemplates\n")
#                         x = .Call("RXSLT_applyTemplates", ctx, node[[1]], temp[[1]][[1]], x = 'bob')
#                        print(x)
#                        browser()

                        return(TRUE)
                      }))


#   doc = .Call("RXSLT_getXMLDocument", ctx)
#   temp = getNodeSet(doc, "//xsl:template[@name='toc']",
#                             c(xsl="http://www.w3.org/1999/XSL/Transform"))


z = xsltApplyStyleSheet("examples/applyTemplates.xml", "examples/applyTemplates.xsl")
cat(saveXML(z$doc))


