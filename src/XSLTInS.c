/*
 From Dan Veillard's XSLT page (http://xmlsoft.org/XSLT/API)
  1.configure the parser for XSLT: 

    xmlSubstituteEntitiesDefault(1);

    xmlLoadExtDtdDefaultValue = 1;

  2.parse the stylesheet with xsltParseStylesheetFile() 
  3.parse the document with xmlParseFile() 
  4.apply the stylesheet using xsltApplyStylesheet() 
  5.save the result using xsltSaveResultToFile() if needed set xmlIndentTreeOutput to 1 
*/

#include <libxml/parserInternals.h>
#include <libxml/xmlmemory.h>
#include <libxml/xinclude.h>

#include <libxslt/xsltconfig.h>

#include <libxslt/xsltInternals.h>
#include <libxslt/transform.h>

#include <libxslt/xsltutils.h>

#include <libxslt/pattern.h>

#include "RSCommon.h"


#ifdef match
#undef match
#endif


SEXP
RXSLT_getLibXSLTVersion()
{
   return(mkString(LIBXSLT_DOTTED_VERSION)); /* xsltEngineVersion or LIBXSLT_DOTTED_VERSION */
}

void R_xmlFreeDoc(SEXP ref)
{
  xmlDocPtr doc;
  doc = (xmlDocPtr) R_ExternalPtrAddr(ref);

  if(doc) {
#ifdef XSLT_DEBUG
      const xmlChar *url = doc->URL ? doc->URL : doc->name ? doc->name : "";
      fprintf(stderr, "(Sxslt) Cleaning up document %p, %s\n", (void *) doc, url);
#endif
      xmlFreeDoc(doc);

      R_ClearExternalPtr(ref);
  }
}

void R_xsltFreeStylesheet(SEXP ref)
{
    xsltStylesheetPtr ptr = (xsltStylesheetPtr) R_ExternalPtrAddr(ref);
    if(ptr) {
#ifdef XSLT_DEBUG
fprintf(stderr, " freeing xsltStylesheet:  %p\n", ptr);
#endif
	    const xmlChar *url;
	    if(ptr->doc == (xmlDocPtr) 0xffffffff) {
#ifdef XSLT_DEBUG
		    fprintf(stderr, "Seem to be freeing a style sheet (%p) for a second time\n", ptr);
#endif
		    return;
	    }
	    url = ptr->doc && ptr->doc->URL ? ptr->doc->URL : (ptr->doc->name  ? ptr->doc->name : BAD_CAST( "" ) );
	    if(ptr->_private && ptr->_private == R_NilValue) {
#ifdef XSLT_DEBUG
		    fprintf(stderr, "stylesheet %p which doesn't own its doc (%s)\n", (void *) ptr, url);
#endif
		    ptr->doc = NULL;
	    }
#ifdef XSLT_DEBUG
        fprintf(stderr, "Freeing stylesheet %p, %s\n", (void *) ptr, url);
#endif
	xsltFreeStylesheet(ptr);
#ifdef XSLT_DEBUG
	fprintf(stderr, "Done    stylesheet %p\n", (void *) ptr);
#endif
	R_SetExternalPtrAddr(ref, NULL);
    }
}

/**XXX  Originally taken from XML package: XMLTree.c. But now extended. */
USER_OBJECT_
R_createXMLDocRef(xmlDocPtr doc, USER_OBJECT_ sheet, int state)
{
  SEXP ref, tmp;

  PROTECT(ref = NEW_LIST(3));
  PROTECT(tmp = R_MakeExternalPtr(doc, Rf_install("XMLInternalDocument"), NULL_USER_OBJECT));
  SET_CLASS(tmp, mkString("XMLInternalDocument"));
  R_RegisterCFinalizer(tmp, R_xmlFreeDoc);

  SET_VECTOR_ELT(ref, 0, tmp);
  SET_VECTOR_ELT(ref, 1, sheet);
  PROTECT(tmp = ScalarInteger(state < 0 ? NA_LOGICAL : state));
  if(state > -1 && state < 3) {
      const char *ids[] = {"OK", "ERROR", "STOPPED"};
      SET_NAMES(tmp, ScalarString(mkChar(ids[state]))); 
  }
  SET_VECTOR_ELT(ref, 2, tmp);
  UNPROTECT(1);

  PROTECT(tmp = NEW_CHARACTER(1));
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING("XMLInternalXSLTDocument"));
  SET_CLASS(ref, tmp);

  PROTECT(tmp = NEW_CHARACTER(3));
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING("doc"));
  SET_STRING_ELT(tmp, 1, COPY_TO_USER_STRING("stylesheet"));
  SET_STRING_ELT(tmp, 2, COPY_TO_USER_STRING("status"));
  SET_NAMES(ref, tmp);


  UNPROTECT(4);

  return(ref);
}


USER_OBJECT_
S_createSStyleSheetObject(xsltStylesheetPtr sheet, int addFinalizer)
{
  USER_OBJECT_ tmp, klass, ext;
  if(!sheet) 
     return(R_NilValue);


  PROTECT(klass = MAKE_CLASS("XSLStyleSheet"));
  PROTECT(tmp = NEW(klass));
  SET_SLOT(tmp, Rf_install("ref"), ext = R_MakeExternalPtr(sheet, Rf_install("XSLTStyleSheet"), NULL_USER_OBJECT));

  /* SET_CLASS(tmp, mkString("XSLTStyleSheet")); */

  if(addFinalizer)
	R_RegisterCFinalizer(ext, R_xsltFreeStylesheet);

  UNPROTECT(2);
  return(tmp);
}

xsltStylesheetPtr 
S_resolveStyleSheetRef(USER_OBJECT_ ref)
{
   if(TYPEOF(ref) != EXTPTRSXP) {
      ref = GET_SLOT(ref, Rf_install("ref"));
   }

   if(TYPEOF(ref) != EXTPTRSXP) {
      PROBLEM "expected an external pointer for the XSLTStyleSheet"
      ERROR;
   }

   if(R_ExternalPtrTag(ref) != Rf_install("XSLTStyleSheet")) {
      PROBLEM "expected external pointer to have the internal tag 'XSLTStyleSheet', got %s",
          CHAR(PRINTNAME(R_ExternalPtrTag(ref)))
      ERROR;
   }   


   return( (xsltStylesheetPtr) R_ExternalPtrAddr(ref));
}

#include "Rsupport.h"

USER_OBJECT_
S_parseStylesheet(USER_OBJECT_ fileName)
{
 xsltStylesheetPtr sheet;
 const char *urlName = "";

 if(OBJECT(fileName) && R_isInstanceOf(fileName, "XMLInternalDocument")) {
     xmlDocPtr doc;
     doc = (xmlDocPtr) R_ExternalPtrAddr(fileName);
     sheet = xsltParseStylesheetDoc(doc);
     if(sheet)
        sheet->_private = R_NilValue;
     else
        urlName = (char *) (doc->URL ? doc->URL : (doc->name ? doc->name : BAD_CAST( "??" ) ));
 } else {
     sheet = xsltParseStylesheetFile(CHAR_DEREF(STRING_ELT(fileName, 0)));
     urlName =  CHAR(STRING_ELT(fileName, 0));
 }

 if(!sheet) {
     PROBLEM "Cannot parse XSL document %s", urlName
     ERROR;
 }
 return(S_createSStyleSheetObject(sheet, 1));
}


/*
 Call the function readXSLProfileData with the 
 XML document reference which contains the profile
 information.
*/
static USER_OBJECT_
R_ProcessXSLTProfile(xsltTransformContextPtr ctxt, SEXP fun)
{
    xmlDocPtr doc = xsltGetProfileInformation(ctxt);
    SEXP e, tmp, ans;
    PROTECT(e = allocVector(LANGSXP, 2));
    SETCAR(e, fun); /* Rf_install("readXSLProfileData") */
    PROTECT(tmp = R_MakeExternalPtr(doc, Rf_install("XMLInternalDocument"), NULL_USER_OBJECT));
    SET_CLASS(tmp, mkString("XMLInternalDocument"));
    SETCAR(CDR(e), tmp);
    ans = Rf_eval(e, R_GlobalEnv);
    xmlFreeDoc(doc);
    UNPROTECT(2);
    return(ans);
}

void
RXSLT_transformErrorHandler(void *userData, const char *msg, ...)
{
    SEXP e;
    char buf[5000];
    va_list args;
    va_start(args, msg);

    if(msg)
	vsnprintf(buf, 5000, msg, args);

    PROTECT(e = allocVector(LANGSXP, 2));
    SETCAR(e, userData ? (SEXP) userData : Rf_install("xslStop"));
    SETCAR(CDR(e), msg ? mkString(buf) : NEW_CHARACTER(0));

    Rf_eval(e, R_GlobalEnv);
    UNPROTECT(1);
}

static  USER_OBJECT_
applySheet(xmlDocPtr doc, USER_OBJECT_ styleSheet, USER_OBJECT_ sparams, USER_OBJECT_ r_profile, USER_OBJECT_ errorFun)
{
	xmlDocPtr tdoc;
	xsltStylesheetPtr sheet;
	const char ** params = NULL;
	int numParams, i;
	xsltTransformContextPtr ctxt = NULL;
	USER_OBJECT_ ans;

	sheet = S_resolveStyleSheetRef(styleSheet);

	numParams = GET_LENGTH(sparams);
	if(numParams > 0) {
		int ctr = 0;
		USER_OBJECT_ paramNames = GET_NAMES(sparams);
		params = (const char **) R_alloc(2*numParams + 1, sizeof(char *));
		for(i = 0; i < numParams; i++, ctr+=2) {
			params[ctr] = CHAR_DEREF(STRING_ELT(paramNames, i));
			params[ctr+1] = CHAR_DEREF(STRING_ELT(sparams, i));
		}
		params[2*numParams] = NULL;
	}

	if(TYPEOF(r_profile) == STRSXP && GET_LENGTH(r_profile)) {
	    FILE *f;
	    const char *profile = CHAR_DEREF(STRING_ELT(r_profile, 0));
	    f = fopen(profile, "w");
	    if(!f) {
	         PROBLEM "cannot create file %s for writing", profile
		    ERROR;
	    }
            tdoc = xsltProfileStylesheet(sheet, doc, (const char **) params, f);
	    fclose(f);
	} else {

	    ctxt = xsltNewTransformContext(sheet, doc);
	    xsltSetTransformErrorFunc(ctxt, errorFun, RXSLT_transformErrorHandler);

	    if(TYPEOF(r_profile) == CLOSXP)  /* old LGLSXP && LOGICAL(r_profile)[0]) */
	       ctxt->profile = 1;

	    tdoc = xsltApplyStylesheetUser(sheet, doc, (const char **) params, NULL, NULL, ctxt);
        }

	if(!tdoc) {
	   if(ctxt) 
	       xsltFreeTransformContext(ctxt);

	   RXSLT_transformErrorHandler(errorFun, NULL);
	   /* Shouldn't get here. */
   	   PROBLEM "problem applying stylesheet. No document created."
  	   ERROR;
	}

        if(ctxt && ctxt->profile) {
	    PROTECT(ans = NEW_LIST(2));
	    SET_VECTOR_ELT(ans, 0, R_createXMLDocRef(tdoc, styleSheet, ctxt->state));
	    SET_VECTOR_ELT(ans, 1, R_ProcessXSLTProfile(ctxt, r_profile));
	    UNPROTECT(1);
	    xsltFreeTransformContext(ctxt);
	} else 
	    ans = R_createXMLDocRef(tdoc, styleSheet, ctxt ? ctxt->state : -1);

	return(ans);
}

USER_OBJECT_
S_applySheetToDOM(USER_OBJECT_ docRef, USER_OBJECT_ styleSheet, USER_OBJECT_ sparams, USER_OBJECT_ r_profile, USER_OBJECT_ errorFun)
{
    xmlDocPtr doc;

    doc = (xmlDocPtr) R_ExternalPtrAddr(docRef);
    
    return(applySheet(doc, styleSheet, sparams, r_profile, errorFun));
}

USER_OBJECT_
S_applySheet(USER_OBJECT_ xmlContent, USER_OBJECT_ isText, USER_OBJECT_ styleSheet,
             USER_OBJECT_ sparams, USER_OBJECT_ xinclude, USER_OBJECT_ errorFun)
{
	xmlDocPtr doc;

	const char *tmp = CHAR_DEREF(STRING_ELT(xmlContent, 0));

	if(!LOGICAL_DATA(isText)[0]) {
	  doc = xmlParseFile(tmp);
	} else {
   	  doc = xmlParseMemory(tmp, strlen(tmp));
	}

	/* Perform the xinclude */
	if(TYPEOF(xinclude) == LGLSXP) {
	    if(LOGICAL(xinclude)[0]) 
/* Different for older versions of libxml*/
#if LIBXML_VERSION >= 20603
  	         xmlXIncludeProcessFlags(doc, XML_PARSE_XINCLUDE);
#else
  	         xmlXIncludeProcess(doc);    
#endif
	}
		
		
        return(applySheet(doc, styleSheet, sparams, R_NilValue, errorFun));
}


/*  The following section is for serializing the resulting document
    to a file or a string. Soon we will add facilities for writing
    to a connection.
*/
typedef struct {
   char *str;
   unsigned int curLen;
   unsigned int maxLen;
} S_XML_OutputBuf;

int S_XML_OutputBuf_close(void *context)
{
 return(0);
}

int S_XML_OutputBuf_write(void *context, const char *buffer, int len)
{
	S_XML_OutputBuf *b = (S_XML_OutputBuf *) context;
	if(!b->str) {
                b->maxLen = len > b->maxLen ? len : b->maxLen + 1;
		b->str = (char *) S_alloc(b->maxLen, sizeof(char));
	} else if(b->curLen + len > b->maxLen - 1) {
		int old = b->maxLen;
		b->maxLen = b->curLen + len + 1;
		b->str = (char *) S_realloc(b->str, b->maxLen, old, sizeof(char));
	}

	memcpy(b->str + b->curLen, buffer, len);
	b->curLen += len;
	b->str[b->curLen] = '\0';

	return(len);
}

USER_OBJECT_
S_saveXMLDocToString(USER_OBJECT_ sdoc, USER_OBJECT_ encodingStyle)
{
  xmlDocPtr doc;
  xsltStylesheetPtr sheet;
  xmlOutputBuffer *buf;
  S_XML_OutputBuf sbuf = {NULL, 0, 0};
  USER_OBJECT_ ans;

  int status = 0;
 
  const char *encoding;
  xmlCharEncodingHandlerPtr encoder = NULL;


  if(encodingStyle != NA_STRING) {
     encoding = CHAR(STRING_ELT(encodingStyle, 0));
     if(*encoding)
        encoder = xmlFindCharEncodingHandler(encoding);
  }

  buf = xmlOutputBufferCreateIO(S_XML_OutputBuf_write, S_XML_OutputBuf_close,
				&sbuf, encoder);


  doc = (xmlDocPtr) R_ExternalPtrAddr(VECTOR_ELT(sdoc, 0));
  sheet = S_resolveStyleSheetRef(VECTOR_ELT(sdoc, 1));

  if((status = xsltSaveResultTo(buf, doc, sheet)) < 0) {
      Rf_error("error writing to buffer");
  }

  if(!sbuf.str) {
     Rf_error("no content in the document");
  }

  PROTECT(ans = NEW_CHARACTER(1));
  SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(sbuf.str));
  UNPROTECT(1);

  return(ans);
}


/* Can use xsltSaveResultToFd() to write onto a connection.
   Or use the generic buffer above.
 */

USER_OBJECT_
S_saveXMLDocToFile(USER_OBJECT_ sdoc, USER_OBJECT_ sfileName, USER_OBJECT_ compression)
{
  xmlDocPtr doc;
  xsltStylesheetPtr sheet;
  const char *fileName;
  USER_OBJECT_ ans;
  int status;
  fileName = CHAR_DEREF(STRING_ELT(sfileName, 0));

  doc = (xmlDocPtr) R_ExternalPtrAddr(VECTOR_ELT(sdoc, 0));
  sheet = S_resolveStyleSheetRef(VECTOR_ELT(sdoc, 1));

  if((status = xsltSaveResultToFilename(fileName, doc, sheet, INTEGER_DATA(compression)[0])) < 0) {
     PROBLEM "error writing XML document from XSLT to file %s", fileName
     ERROR;
  }

  return(ScalarInteger(status));
}

#include "Converters.h"
#include <libxml/xpathInternals.h>


/*
  Create an R object that is a reference to an xmlNodeSetPtr
  object in C and put the XML node references given in the 
  R list 'els' into the C-level node set.
 */
USER_OBJECT_
RXSLT_newXPathNodeSet(USER_OBJECT_ els, USER_OBJECT_ r_duplicate)
{
    xmlNodeSetPtr ans;
    xmlNodePtr tmp;
    int i, n;
    n = GET_LENGTH(els);

    ans = xmlXPathNodeSetCreate(NULL);
    if(!ans) {
	PROBLEM "cannot allocate space for an XPathNodeSet"
        ERROR;
    }

    for(i = 0 ; i < n ; i++) {
	tmp = (xmlNodePtr) R_ExternalPtrAddr(VECTOR_ELT(els, i));
	if(LOGICAL(r_duplicate)[0])
	    tmp = xmlCopyNode(tmp, 1); /* recursive */
	xmlXPathNodeSetAdd(ans, tmp);
    }
/*    return(RXSLT_exportPointer(ans, "XPathNodeSet")); */
    return(RXSLT_exportNodeSet_direct(ans));
}


#include <libxslt/variables.h>
#include <libxslt/extensions.h>

USER_OBJECT_
RXSLT_getXSLVariable(USER_OBJECT_ r_ctxt, USER_OBJECT_ names, USER_OBJECT_ uris)
{
    int i, n;
    USER_OBJECT_ ans;
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    n = GET_LENGTH(names);
    PROTECT(ans = NEW_LIST(n));
    for(i = 0; i < n ; i++) {
	xmlXPathObjectPtr val;
        const xmlChar *u = "";
	USER_OBJECT_ tmp = STRING_ELT(uris, i);
	if(tmp != NA_STRING)
	    u = (const xmlChar *) CHAR(tmp);
	/*  also xsltXPathVariableLookup */
	val = xsltVariableLookup(ctxt, CHAR(STRING_ELT(names, i)), u[0] ? u : NULL); 

	if(val) 
	    SET_VECTOR_ELT(ans, i, convertFromXPath(path_ctxt, val));
    }
    UNPROTECT(1);
    return(ans);
}



/* From XMLTree.c in the XML package. */
USER_OBJECT_
R_createBasicXMLDocRef(xmlDocPtr doc)
{
  SEXP ref, tmp;

  PROTECT(ref = R_MakeExternalPtr(doc, Rf_install("XMLInternalDocument"), R_NilValue));
/*  or just  SET_CLASS(tmp, mkString("XMLInternalDocument")); */
  PROTECT(tmp = NEW_CHARACTER(1));
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING("XMLInternalDocument"));
  SET_CLASS(ref, tmp);
  UNPROTECT(2);
  return(ref);
}


/*
 Given a context, get the corresponding XSL stylesheet xmlDocPtr
 so that we can find nodes within it.
 */
USER_OBJECT_
RXSLT_getStylesheetDocument(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    return(R_createBasicXMLDocRef(ctxt->style->doc));
}

SEXP
RXSLT_getStylesheetPtr(SEXP r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);
    return(S_createSStyleSheetObject(ctxt->style, 0));
}





/*
 Given a context, get the corresponding XSL stylesheet xmlDocPtr
 so that we can find nodes within it.
 */
USER_OBJECT_
RXSLT_getXMLDocument(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    return(R_createBasicXMLDocRef(ctxt->document->doc));
}


USER_OBJECT_
RXSLT_getStyleSheetXMLDocument(USER_OBJECT_ r_style)
{
    xsltStylesheetPtr ptr = (xsltStylesheetPtr) R_ExternalPtrAddr(r_style);
    return(R_createBasicXMLDocRef(ptr->doc));
}


USER_OBJECT_
RXSLT_getInsertNode(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    return(RXSLT_exportNode(ctxt->insert));
}


USER_OBJECT_
RXSLT_getOutputDocument(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    USER_OBJECT_ tmp;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);
    
    PROTECT(tmp = R_MakeExternalPtr(ctxt->output, Rf_install("XMLInternalDocument"), NULL_USER_OBJECT));
    SET_CLASS(tmp, mkString("XMLInternalDocument"));
    UNPROTECT(1);
    return(tmp);
}



USER_OBJECT_
RXSLT_getCurrentTemplateNode(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    return(RXSLT_exportNode(ctxt->inst));
}


USER_OBJECT_
RXSLT_getCurrentSourceNode(USER_OBJECT_ r_ctxt)
{
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    xmlNodePtr node;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    return(RXSLT_exportNode(ctxt->node));
}





USER_OBJECT_
RXSLT_insert(USER_OBJECT_ r_ctxt, USER_OBJECT_ snode)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    xmlNodePtr node;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);

    if(TYPEOF(snode) == STRSXP) {
	xsltCopyTextString(ctxt, ctxt->insert, CHAR_DEREF(STRING_ELT(snode, 0)), 0);
    } else {
	node = (xmlNodePtr) R_ExternalPtrAddr(snode);
	xmlAddChild(ctxt->insert, node);
    }

    return(ans);
}


#include <libxslt/xsltInternals.h>


/* Is xsltProcessOneNode actually exposed as part of the API on any platform? */
USER_OBJECT_
RXSLT_processOneNode(USER_OBJECT_ r_ctxt, USER_OBJECT_ snode)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
#ifndef WIN32
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    xmlNodePtr node;

    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);
    node = (xmlNodePtr) R_ExternalPtrAddr(snode);

    xsltProcessOneNode(ctxt, node, NULL);
#endif

    return(ans);
}


USER_OBJECT_
RXSLT_applyTemplates(USER_OBJECT_ r_ctxt, USER_OBJECT_ snode, USER_OBJECT_ sinst)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    xmlNodePtr node, inst;


/* Suggestion taken from the bottom of Dan Veillard's mail 
    http://mail.gnome.org/archives/xslt/2003-July/msg00028.html
*/
    xsltStylePreComp comp, *pre = NULL;
  
    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);
    node = (xmlNodePtr) R_ExternalPtrAddr(snode);
    inst = (xmlNodePtr) R_ExternalPtrAddr(sinst);


/*    xsltStylePreCompute(ctxt->style, inst); */

    if(1) {
	xsltStylePreCompPtr tmp;
//	xsltElemPrePreCompPtr tmp;
	tmp = ctxt->style->preComps;
	while(tmp) {
	    if(tmp->inst == inst) {
		pre = tmp;
		break;
	    }
	    tmp = tmp->next;
	}

	if(0 && pre == NULL) {
	    PROBLEM "can't find the pre-compiled template"
		ERROR;
	}
    }


    if(!pre) {
	memset(&comp, 0, sizeof(xsltStylePreComp));
	comp.inst = inst;
	comp.next = NULL;
	/* comp.type = XSLT_FUNC_MESSAGE;*/
	comp.func = NULL;
	pre = &comp;
    }

    xsltApplyTemplates(ctxt, node, inst, pre);

    return(ans);

}


/*
  Search for the template object by looking 
  through the linked list of templates in the style sheet
  and finding the one (if any) for who the 
  parent of the content is our node.
 */
static xsltTemplatePtr
find_templ(xsltTransformContextPtr ctxt, xmlNodePtr inst)
{
    xsltTemplatePtr ptr;
    ptr = ctxt->style->templates;
    while(ptr) {
	if(ptr->content && ptr->content->parent == inst)
	    return(ptr);
	ptr  = ptr->next;
    }
    return(NULL);
}

static xsltStylePreCompPtr
find_precomp(xsltTransformContextPtr ctxt, xmlNodePtr inst)
{
    xsltStylePreCompPtr tmp;
    tmp = ctxt->style->preComps;
    while(tmp) {
	    if(tmp->inst->parent == inst) {
		return(tmp);
	    }
	    tmp = tmp->next;
    }

    if(0) {
	PROBLEM "can't find the pre-compiled template"
	    ERROR;
    }

    return(NULL);
}

USER_OBJECT_
RXSLT_callTemplate(USER_OBJECT_ r_ctxt, USER_OBJECT_ snode, USER_OBJECT_ sinst,
                    USER_OBJECT_ params)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
    xsltTransformContextPtr ctxt;
    xmlXPathParserContextPtr path_ctxt;
    xmlNodePtr node, inst, tmp;

    xsltStylePreComp comp, *pre = NULL;
  
    path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    ctxt = xsltXPathGetTransformContext(path_ctxt);
    node = (xmlNodePtr) R_ExternalPtrAddr(snode);
    inst = (xmlNodePtr) R_ExternalPtrAddr(sinst);


    /* 
       pre = find_precomp(ctxt, inst);
       But rather, we use our own empty one 
    */
    if(1 || !pre) {
	memset(&comp, 0, sizeof(xsltStylePreComp));
	comp.inst = inst;
	comp.next = NULL;
	/* comp.type = XSLT_FUNC_MESSAGE;*/
	comp.func = NULL;
	pre = &comp;
    }

    pre->templ = find_templ(ctxt, inst);

    /* create a dummy node. Only its children are consulted so don't
       give it any.  We would add parameters here if we wanted any.
       A child should be a <with-param name=''>value</with-param>
       and the psvi field here has to be a precompiled xsltStylePreCompPtr
       containing a name
     */
    tmp = xmlNewNode(NULL, "call-template");
    if(tmp && GET_LENGTH(params) > 0) {
	/* Put the with-param elements as children of this call-template node. */
	int n = GET_LENGTH(params), i;
	USER_OBJECT_ names = GET_NAMES(params), el;
	xmlNsPtr ns = inst->ns;
	xmlNodePtr nnode;
	xsltStylePreCompPtr pcomp;

	for(i = 0; i < n; i++) {
	    el = VECTOR_ELT(params, i);
	    nnode  = xmlNewNode(ns, "with-param");
	    xmlAddChild(nnode, xmlNewText(CHAR_DEREF(STRING_ELT(el, 0))));
	    xmlNewProp(nnode, "name", CHAR_DEREF(STRING_ELT(names, 0)));
	    xmlNewProp(nnode, "select", CHAR_DEREF(STRING_ELT(el, 0)));

	    nnode->psvi = pcomp = (xsltStylePreCompPtr) xmlMalloc(sizeof(xsltStylePreComp));
	    memset(pcomp, 0, sizeof(xsltStylePreComp));
	    pcomp->inst = nnode;
	    pcomp->ns = NULL;

                /* Need to get the interned version of this for pointer equality. 
		   See the comparson of the tmpParam and iparam names in 
		   xsltApplyXSLTTemplate in transform.c
		 */
	    pcomp->name = xmlDictLookup(ctxt->style->dict, CHAR_DEREF(STRING_ELT(names, 0)), -1);

	    xmlAddChild(tmp, nnode);
	}
    }
    if(tmp) {
	xsltCallTemplate(ctxt, node, tmp, pre);
	xmlFreeNode(tmp);
    } else {
	PROBLEM "cannot create internal XML node"
	    ERROR;
    }
    /* Look at xsltApplyXSLTTemplate also */
    return(ans);
}


#include <libxslt/imports.h>

SEXP
R_xsltParseStylesheetImport(SEXP r_sty, SEXP r_node, SEXP import)
{
    xmlNodePtr node;
    xsltStylesheetPtr  sty;
    int status;
    sty = S_resolveStyleSheetRef(r_sty);
    node = (xmlNodePtr) R_ExternalPtrAddr(r_node);

    status = LOGICAL(import)[0] ?
                   xsltParseStylesheetImport(sty, node)
          	:  xsltParseStylesheetInclude(sty, node);
    
    if(status != 0) {
	PROBLEM "problem import stylesheet"
        ERROR;
    }

    return(ScalarInteger(status));
}



/* Experiments */
SEXP
R_addStylesheetImport(SEXP r_sty, SEXP r_imp)
{
    xsltStylesheetPtr  sty, imp;
    sty = S_resolveStyleSheetRef(r_sty);
    imp = S_resolveStyleSheetRef(r_imp);
    sty->imports = imp;
    return(R_NilValue);
}

SEXP
R_clearStylesheetImport(SEXP r_sty)
{
    xsltStylesheetPtr  sty;
    sty = S_resolveStyleSheetRef(r_sty);
    sty->imports = NULL;
    return(NULL_USER_OBJECT);
}



/****************************************************/
void
R_xsltFreeTransformContext(SEXP obj)
{
  xsltTransformContextPtr ptr;
  ptr = (xsltTransformContextPtr) R_ExternalPtrAddr(obj);
  if(ptr) {
//fprintf(stderr, " freeing xsltTransformContext:  %p\n", ptr);
      xsltFreeTransformContext(ptr);
      R_ClearExternalPtr(obj);
  }
}

USER_OBJECT_
S_createRTransformContextObject(xsltTransformContextPtr sheet, int addFinalizer)
{
  USER_OBJECT_ tmp;
  if(!sheet) 
     return(R_NilValue);


  tmp = R_MakeExternalPtr(sheet, Rf_install("XSLTTransformContext"), NULL_USER_OBJECT);
  PROTECT(tmp);
  SET_CLASS(tmp, mkString("XSLTTransformContext")); 

  if(addFinalizer)
	R_RegisterCFinalizer(tmp, R_xsltFreeTransformContext);

  UNPROTECT(1);
  return(tmp);
}


SEXP
RXSLT_createTransformContext(SEXP r_sty, SEXP r_doc)
{
    xsltStylesheetPtr  sty;
    xmlDocPtr doc;
    xsltTransformContextPtr ctxt;

    sty = S_resolveStyleSheetRef(r_sty);
    doc = (xmlDocPtr) R_ExternalPtrAddr(r_doc);
    ctxt = xsltNewTransformContext(sty, doc);

    return(S_createRTransformContextObject(ctxt, 1));
}


SEXP
RXSLT_getTransformContextStyle(SEXP r_ctxt)
{
    xsltTransformContextPtr ctxt;
    ctxt = (xsltTransformContextPtr) R_ExternalPtrAddr(r_ctxt);
    return(S_createSStyleSheetObject(ctxt->style, 0));
}


#ifdef match
#undef match
#endif

SEXP
makeRTemplateObject(xsltTemplatePtr templ)
{
    int i;
    SEXP ans;

    if(!templ) 
       return(NULL_USER_OBJECT);

    /* style sheet, 
        match attribute
        name attribute
        elem - node gives the entire node. 
	priority
        mode
     */
    PROTECT(ans = NEW_LIST(6));
    i = 0;
    SET_VECTOR_ELT(ans, i, S_createSStyleSheetObject(templ->style, 0)); i++;
    SET_VECTOR_ELT(ans, i, templ->match ? mkString(templ->match) : NEW_CHARACTER(0)); i++;
    SET_VECTOR_ELT(ans, i, templ->name ? mkString(templ->name) : NEW_CHARACTER(0)); i++;
    SET_VECTOR_ELT(ans, i, RXSLT_exportNode(templ->elem)); i++;
    SET_VECTOR_ELT(ans, i, ScalarReal(templ->priority)); i++;
    SET_VECTOR_ELT(ans, i, templ->mode ? mkString(templ->mode) : NEW_CHARACTER(0)); i++;

    UNPROTECT(1);
    return(ans);
}


/*
This doesn't work for db2latex. That uses a lot of includes and no
imports. We may have to walk the style files. See the note on
the documentation for xsltGetTemplate().
 */
SEXP
RSXSLT_getTemplate(SEXP r_ctxt, SEXP r_node, SEXP r_mode)
{
    xmlNodePtr node;
    xsltTransformContextPtr ctxt;
    xsltTemplatePtr templ;
    const xmlChar *oldMode, *tmpMode = NULL;

    ctxt = (xsltTransformContextPtr) R_ExternalPtrAddr(r_ctxt);
    if(Rf_length(r_mode)) {
	oldMode = ctxt->mode;
	ctxt->mode = tmpMode = CHAR_DEREF(STRING_ELT(r_mode, 0));
    }
    node = (xmlNodePtr) R_ExternalPtrAddr(r_node);
    templ = xsltGetTemplate(ctxt, node, ctxt->style);

    if(tmpMode)
	ctxt->mode = oldMode;
    return(makeRTemplateObject(templ));
}


SEXP
RXSLT_getCurrentTemplate(SEXP r_ctxt)
{
   xsltTransformContextPtr ctxt;
   xmlXPathParserContextPtr path_ctxt;

   path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
   ctxt = xsltXPathGetTransformContext(path_ctxt);

   if(!ctxt) {
       PROBLEM "null value passed for xsltTransformContextPtr"
       ERROR;
   }

    return(makeRTemplateObject(ctxt->templ));
}

SEXP
RXSLT_getCurrentInputNode(SEXP r_ctxt)
{
   xsltTransformContextPtr ctxt;
   xmlXPathParserContextPtr path_ctxt;

   path_ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
   ctxt = xsltXPathGetTransformContext(path_ctxt);

   if(!ctxt) {
       PROBLEM "null value passed for xsltTransformContextPtr"
       ERROR;
   }

   return(RXSLT_exportNode(ctxt->node));
}


