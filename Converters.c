#include "Converters.h"

#include <libxml/xpathInternals.h>
#include <libxml/xpointer.h>

#include <libxslt/extensions.h> /* For the xsltXPathGetTransformContext() */
#include <libxslt/xsltutils.h>


#include "Rinternals.h"
#include "Rsupport.h"

typedef int (*clearMemory_t)(xmlNodePtr node);
clearMemory_t  clearNodeMemoryManagement_f = NULL;

SEXP
R_set_clearNodeMemoryManagement(SEXP r_val)
{
    clearNodeMemoryManagement_f = R_ExternalPtrAddr(r_val);
    return(R_NilValue);
}



USER_OBJECT_ RXSLT_exportNodeSet(xmlXPathObjectPtr val);

#define RXSLT_R_OBJECT  XPATH_XSLT_TREE + 1

xmlXPathObjectPtr 
convertToXPath(xmlXPathParserContextPtr ctxt, USER_OBJECT_ ans)
{
    xmlXPathObjectPtr val = NULL;
    int n = GET_LENGTH(ans);

    if(ans == R_NilValue)
	return(xmlXPathNewNodeSet(NULL));

    if(OBJECT(ans) && R_isInstanceOf(ans, "XPathNodeSet")) {
        xmlNodeSetPtr ns = (xmlNodeSetPtr) R_ExternalPtrAddr(GET_SLOT(ans, Rf_install("ref")));	
	/* Do we need to move any XML nodes in here to this output document. */
	val = xmlXPathWrapNodeSet(ns);
	return(val);
    } else if(OBJECT(ans) && R_isInstanceOf(ans, "XMLInternalNode")) {


	/* Insert the node as a child of the currently active node. */
	xmlNodePtr node, cur;

	node = (xmlNodePtr) R_ExternalPtrAddr(ans);
        cur = xsltXPathGetTransformContext(ctxt)->insert;
	if( (node->doc && node->doc != cur->doc) )
	   node = xmlDocCopyNode(node, cur->doc, 1);

/* Need to be more specific about when to do this. */
        if(clearNodeMemoryManagement_f)
             clearNodeMemoryManagement_f(node);            

        xmlAddChild(cur, node);
	return(xmlXPathNewNodeSet(NULL));

    } else if(OBJECT(ans) && R_isInstanceOf(ans, "XMLInternalDocument")) {
        /* Return top-level node of the document as a node set. 
           Is this the right thing to do? Perhaps insert that document node
           into the current spot.
         */
        xmlNodePtr node, cur;
	xmlDocPtr doc;

	doc = (xmlDocPtr) R_ExternalPtrAddr(ans);
        node = doc->children;
        cur = xsltXPathGetTransformContext(ctxt)->insert;
        xmlAddChild(cur, node);
	return(xmlXPathNewNodeSet(NULL));
    } else if(TYPEOF(ans) == VECSXP) {
	xmlNodePtr node;
	int i, n = GET_LENGTH(ans);
        node = xsltXPathGetTransformContext(ctxt)->insert;
	for(i = 0; i < n; i++) {
	    xmlNodePtr el;
	    USER_OBJECT_ tmp;
	    tmp = VECTOR_ELT(ans, i);
	    if(TYPEOF(tmp) != EXTPTRSXP) {
		RXSLT_Warning(ctxt, "non-XML node returned as part of a list from an R function");
		continue;
	    }
	    el = (xmlNodePtr) R_ExternalPtrAddr(tmp);
	    if(el->doc && el->doc != node->doc) 
	      el = xmlDocCopyNode(el, node->doc, 1);		
	    xmlAddChild(node, el);
	}
	return(xmlXPathNewNodeSet(NULL));
    }


    if(n == 1) {
	switch(TYPEOF(ans)) {
  	  case INTSXP:
              val = xmlXPathNewFloat(INTEGER_DATA(ans)[0]);
	      break;
 	  case REALSXP:
              val = xmlXPathNewFloat(NUMERIC_DATA(ans)[0]);
	      break;
  	  case LGLSXP:
              val = xmlXPathNewBoolean(LOGICAL_DATA(ans)[0]);
	      break;
  	  case STRSXP:
              val = xmlXPathNewString(CHAR_DEREF(STRING_ELT(ans, 0)));
	      break;
  	  case EXTPTRSXP:
	      /* Shouldn't get to here. */
	      if(R_isInstanceOf(ans, "XMLInternalNode")){
		  val = R_ExternalPtrAddr(ans);
	      }
	      break;
   	  default:
	      val = NULL;
	}

	if(!val) 
	   fprintf(stderr, "Unhandled R type being converted to XSL\n");fflush(stderr);

    } else {
#if 0
        if(n > 1) {
   	     fprintf(stderr, "R object of length %d, type %d returned\n", Rf_length(ans), (int) TYPEOF(ans));fflush(stderr);
	     Rf_PrintValue(ans);
	}
#endif

	/* Create a new xmlXPathNodeSet object which is not one of the
	 * standard types. We'll set it to R_OBJECT_TYPE and shove the
	 *  reference to the R object into it
           For now, just preserve the object and don't release. Later
    	   we'll fix this.
 	*/
	R_PreserveObject(ans);
	val = xmlXPathWrapExternal(ans);
/*	return(xmlXPathNewNodeSet(NULL)); */
    }


    return(val);
}


USER_OBJECT_ 
convertFromXPath(xmlXPathParserContextPtr ctxt, xmlXPathObjectPtr val)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
    /* See xpath.h in libxml */
    switch(val->type) {
	case XPATH_STRING:
            PROTECT(ans = NEW_CHARACTER(1)); 
            SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(xmlXPathCastToString(val)));
            UNPROTECT(1);
	    break;
	case XPATH_BOOLEAN:
            ans = NEW_LOGICAL(1);
            LOGICAL_DATA(ans)[0] = xmlXPathCastToBoolean(val);
	    break;
	case XPATH_NUMBER:
            ans = NEW_NUMERIC(1);
            NUMERIC_DATA(ans)[0] = xmlXPathCastToNumber(val);
	    break;
	case XPATH_NODESET:
  	    ans = RXSLT_exportNodeSet(val);
	    break;
        case XPATH_UNDEFINED:
	    ans = NA_STRING; /* Was NA_LOGICAL which is an int, not a SEXP */
	    break;

        case XPATH_XSLT_TREE:
	    if(val->nodesetval->nodeNr == 1) {
		/* Should we get the child if this is a "fake" node? */
		ans = RXSLT_exportNode(val->nodesetval->nodeTab[0]);
                /* would like to add an immutable flag to this. */
	    }
	    break;
	case XPATH_USERS:
	    ans = (SEXP) val->user;
	    break;
	 
/*

  POINT
  RANGE
  LOCATIONSET
*/
        default:
   	    break;
    }

    return(ans);
}

USER_OBJECT_
RXSLT_exportNodeSet_direct(xmlNodeSetPtr val)
{
  USER_OBJECT_ ans;
  USER_OBJECT_ klass;
  PROTECT(klass = MAKE_CLASS("XPathNodeSet"));
  PROTECT(ans = NEW(klass));
  SET_SLOT(ans, Rf_install("ref"), R_MakeExternalPtr(val, Rf_install("XPathNodeSet"), R_NilValue));
  UNPROTECT(2);
  return(ans);
}


USER_OBJECT_
RXSLT_exportNodeSet(xmlXPathObjectPtr val)
{
  return(RXSLT_exportNodeSet_direct(val->nodesetval));
}



/*
  We should use the more complete version of this in the XML

  Borrowed from XMLTree.c
*/
const char * 
R_getInternalNodeClass(xmlElementType type)
{
    const char * p = "";
    switch(type) {
        case XML_ELEMENT_NODE:
              p = "XMLInternalElementNode";
              break;
        case XML_TEXT_NODE:
              p = "XMLInternalTextNode";
              break;
        case XML_CDATA_SECTION_NODE:
              p = "XMLInternalCDataNode";
              break;
        case XML_ENTITY_NODE:
              p = "XMLInternalEntityNode";
              break;
        case XML_ENTITY_REF_NODE:
              p = "XMLInternalEntityRefNode";
              break;
        case XML_PI_NODE:
              p = "XMLInternalPINode";
              break;
        case XML_COMMENT_NODE:
              p = "XMLInternalCommentNode";
              break;
        case XML_NOTATION_NODE:
              p = "XMLInternalNotationNode";
              break;
        case XML_DTD_NODE:
              p = "XMLDTDNode";
              break;
        case XML_NAMESPACE_DECL:
              p = "XMLNamespaceDeclaration";
              break;
        case XML_DOCUMENT_NODE:
              p = "XMLInternalDocument";
              break;
        case XML_ATTRIBUTE_NODE:
              p = "XMLAttributeNode";
              break;
       default:
              p = "XMLUnknownInternalNode";
	      break;
    }

    return(p);
}



USER_OBJECT_
RXSLT_exportNode(xmlNodePtr val)
{
  USER_OBJECT_ ans, tmp;

  if(!val)
     return(NULL_USER_OBJECT);

  if(val->type == XML_DOCUMENT_NODE) {
      return(R_createBasicXMLDocRef((xmlDocPtr) val)); /*XXX */
  }

  PROTECT(ans = R_MakeExternalPtr(val, Rf_install("XMLNodeRef"), R_NilValue));
  PROTECT(tmp = NEW_CHARACTER(3));

  
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING(R_getInternalNodeClass(val->type)));
  SET_STRING_ELT(tmp, 1, COPY_TO_USER_STRING("XMLNodeRef"));
  SET_STRING_ELT(tmp, 2, COPY_TO_USER_STRING("XMLInternalNode")); /* Corresponds to XML package. */
  SET_CLASS(ans, tmp);
  UNPROTECT(2); 
  return(ans);
}

USER_OBJECT_
RXSLT_exportPointer(void *val, const char *className)
{
  USER_OBJECT_ ans, tmp;
  PROTECT(ans = R_MakeExternalPtr(val, Rf_install("GenericReference"), R_NilValue));
  PROTECT(tmp = NEW_CHARACTER(1));
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING(className));
  SET_CLASS(ans, tmp);
  UNPROTECT(2); 
  return(ans);
}
