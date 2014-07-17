#ifndef XSL_IN_R_ONLY
#include <libxslt/libxslt.h>
#endif

#include <libxslt/extensions.h>
#include <libxslt/transform.h>

#include <stdlib.h>

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>


#include "RSCommon.h"
#include "Rsupport.h"
#include "Converters.h"

#ifdef HAVE_R_EMBEDDED_H
#include "Rembedded.h"
#endif

#define R_URI "http://www.r-project.org"

void* RXSLT_initializeR(xsltTransformContextPtr ctxt, const xmlChar *URI);
void RXSLT_shutdownR(xsltTransformContextPtr ctxt, const xmlChar *URI, void *data);

void RXSLT_genericFunctionCall(xmlXPathParserContextPtr ctxt, int nargs);
void RXSLT_addFunction(const char *name, USER_OBJECT_ fun);


int registerBasicFunctions(xsltTransformContextPtr ctxt, const xmlChar *URI, int fromR);
void R_callInitializeExtensionFunc(xsltTransformContextPtr ctxt, const xmlChar *URI);

static int R_alreadyInitialized = 0;
static SEXP R_initializeModuleFunction = NULL;

SEXP
R_getInitialModuleFunction()
{
   return(R_initializeModuleFunction == NULL ? R_NilValue : R_initializeModuleFunction);
}

SEXP
R_setInitialModuleFunction(SEXP v)
{
   SEXP prev;
   if(R_initializeModuleFunction && GET_LENGTH(R_initializeModuleFunction))
       R_ReleaseObject(R_initializeModuleFunction);

   prev = R_initializeModuleFunction ? R_initializeModuleFunction : R_NilValue;

   if(GET_LENGTH(v))
       R_PreserveObject(v);

   R_initializeModuleFunction = v;
   
   return(prev);
}

SEXP
R_xsltRegisterExtModule(SEXP r_uri)
{
 const char *url = strdup(CHAR(STRING_ELT(r_uri, 0)));
 xsltRegisterExtModule((const xmlChar *) url, RXSLT_initializeR, RXSLT_shutdownR);
 return(R_NilValue);
}


void
registerRModule(int fromR)
{
#ifdef XSLT_DEBUG
    fprintf(stderr, "Registering R module\n");fflush(stderr);
#endif

    xsltRegisterExtModule((const xmlChar *) R_URI, RXSLT_initializeR, RXSLT_shutdownR);

/* This seems to be done twice, here and in RXSLT_initializeR. 
   It is called each time the module is initialized which is each time it is 
   required within the application of a stylesheet.
    registerBasicFunctions(NULL, R_URI, fromR);
*/
}



#include <libexslt/exslt.h>
/* 
  Called from within R.  This is used when we are not running
  in stand-alone mode, but within a regular R session and want 
  to use XSLT with the R extensions.
  We now call this when we load the Sxslt library regardless of 
  which mode we are in.  There is the possibility of duplication
  which we can take care of in the near future. XXX
*/
void
R_registerXSLTModule(int *fromR)
{
    exsltRegisterAll();
    registerRModule(*fromR);
    if(fromR)
        R_alreadyInitialized = 1;
}



/* This goes stale when called from within a regular R session 
   as it changes across calls to apply a stylesheet. 
*/
static xsltTransformContextPtr transformCtxt = NULL;


#include <libxslt/xsltutils.h>

void
RXSLT_Error(xmlXPathParserContextPtr ctxt, const char *msg, ...)
{
    char buf[5000];
    va_list args;

    va_start(args, msg);
    vsnprintf(buf, 5000, msg, args);

    xsltTransformError(xsltXPathGetTransformContext(ctxt), NULL, xsltXPathGetTransformContext(ctxt)->insert, buf);
}

void
RXSLT_Warning(xmlXPathParserContextPtr ctxt, const char *msg)
{
/*XXX */
//    xsltTransformError(xsltXPathGetTransformContext(ctxt), NULL, xsltXPathGetTransformContext(ctxt)->insert, msg);
    Rf_warning(msg);
    /* PROBLEM msg
       WARN; */
}


SEXP
R_xslError(SEXP msg, SEXP isError, SEXP r_ctxt)
{
    xmlXPathParserContextPtr ctxt = NULL;
    xsltTransformContextPtr xslCtxt;
    if(r_ctxt != R_NilValue) {
	ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
	xslCtxt = xsltXPathGetTransformContext(ctxt);
    } else {
	xslCtxt = transformCtxt;
    }
    /* xsltTransformError(xsltXPathGetTransformContext(ctxt), NULL, xsltXPathGetTransformContext(ctxt)->insert, buf); */
    RXSLT_Error(ctxt, CHAR(STRING_ELT(msg, 0))); 

    if(LOGICAL(isError)[0])
	xslCtxt->state = XSLT_STATE_STOPPED; /*  XSLT_STATE_ERROR  or stopped.*/

    return(R_NilValue);
}


SEXP
R_xslStop(SEXP r_ctxt)
{
    xmlXPathParserContextPtr ctxt = NULL;
    xsltTransformContextPtr xslCtxt;
    int prev;

    ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    xslCtxt = xsltXPathGetTransformContext(ctxt);

    prev = xslCtxt->state;
    xslCtxt->state = XSLT_STATE_STOPPED;

    /*XXX put a name on this - in R code. */
    return(ScalarInteger(prev));
}


xsltTransformContextPtr
getTransformCtxt()
{
    return(transformCtxt);
}

SEXP
R_getTransformContextMode(SEXP r_context)
{
  SEXP ans, names;
  xsltTransformContextPtr context;
  if(GET_LENGTH(r_context) && TYPEOF(r_context) == EXTPTRSXP)
    context = (xsltTransformContextPtr)  R_ExternalPtrAddr(r_context);
  else {
    PROBLEM  "null context passed to R_getTransformContextMode"
      ERROR;
  }

  PROTECT(ans = NEW_CHARACTER(1));
  PROTECT(names = NEW_CHARACTER(1));
  if(context->mode)
    SET_STRING_ELT(names, 0, COPY_TO_USER_STRING(context->mode));
  if(context->modeURI)
    SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(context->modeURI));
  SET_NAMES(ans, names);
  UNPROTECT(2);
  return(ans);
}

/**
 We can and probably need to remove this if we are just embedding within R
 and are not on Unix. (Why just Unix?)
 Then we should discard the "init" function when registering
 the builtins.
*/
void*
RXSLT_initializeR(xsltTransformContextPtr ctxt, const xmlChar *URI)
{
#ifdef XSLT_DEBUG
    fprintf(stderr, "Initializing R module\n");fflush(stderr);
#endif

    transformCtxt = ctxt;
    registerBasicFunctions(ctxt, URI, 0);
    R_callInitializeExtensionFunc(ctxt, URI);

    return(NULL);
}

void
RXSLT_shutdownR(xsltTransformContextPtr ctxt, const xmlChar *URI, void *data)
{
    transformCtxt = NULL;
}


/*
  The implementation of the r:call() XSL function.
 */
void
RXSLT_callConvert(xmlXPathParserContextPtr ctxt, int nargs, int leaveAsRObject)
{
  USER_OBJECT_ e, ans, tmp, fun;
  xmlXPathObjectPtr obj, *xpathArgs;
  int i, errorOccurred = 0;
  int addContext = 0;
  const char *funName, *colon;

  xpathArgs = (xmlXPathObjectPtr*) malloc(nargs * sizeof(xmlXPathObjectPtr));
  for(i = nargs-1; i >= 0; i--)
      xpathArgs[i] = valuePop(ctxt);

  funName = xmlXPathCastToString(xpathArgs[0]);

  colon = strchr(funName, ':');
  if(!colon) {
          /* regular name of a function. */
      fun = Rf_findFun(Rf_install(funName), R_GlobalEnv);
  } else {
         /* Handle a :: or ::: in the name by calling the corresponding function to get the value  */
      const char *realFunName = colon;
      char tmp[300], *p = tmp;
      do {
	  p[0] = ':'; 
	  p++;
	  realFunName++;
      } while(realFunName[0] == ':');

      p[0] = '\0';

      PROTECT(e = allocVector(LANGSXP, 3));
      SETCAR(e, Rf_install(tmp));
      memcpy(tmp, funName, colon - funName);
      SETCAR(CDR(e), mkString(tmp));
      SETCAR(CDR(CDR(e)), mkString(realFunName));
      /*??? Do we need to protect ?
       XXX If the symbol is not present, this seems to throw the error in R
         but using R_tryEval(), we should be gettting back to here.
      */
      fun = R_tryEval(e, R_GlobalEnv, &errorOccurred);
      if(errorOccurred) 
          RXSLT_Error(ctxt, "can't find R function %s", (char *) funName);

      UNPROTECT(1);
  }

  if(TYPEOF(fun) != CLOSXP && /*???*/ TYPEOF(fun) != FUNSXP && TYPEOF(fun) != BUILTINSXP) 
      RXSLT_Error(ctxt, "%s does not correspond to an R function (%d)", funName, TYPEOF(fun));


  addContext = OBJECT(fun) && R_isInstanceOf(fun, "XSLTContextFunction");


  PROTECT(e = allocVector(LANGSXP, nargs + addContext));
  obj = valuePop(ctxt);    /* ?? what is here. */
#ifdef XSLT_DEBUG
  fprintf(stderr, "RXSLT_call for %s with %d args\n", xmlXPathCastToString(xpathArgs[0]), nargs);fflush(stderr);
#endif


  SETCAR(e, fun); /* Rf_install(xmlXPathCastToString(xpathArgs[0])));*/
  tmp = CDR(e);
  if(addContext) {
      SETCAR(tmp, RXSLT_exportPointer(ctxt, "XMLXPathParserContext"));
      tmp = CDR(tmp);
  }

  for(i = 1 ; i < nargs; i++) {
    obj = xpathArgs[i]; 
    SETCAR(tmp, convertFromXPath(ctxt, obj));
    tmp = CDR(tmp);
  }

  ans = R_tryEval(e, R_GlobalEnv, &errorOccurred);

  if(!errorOccurred) {
     xmlXPathObjectPtr  val;
     PROTECT(ans);
     if(leaveAsRObject) {
	R_PreserveObject(ans);
	val = xmlXPathWrapExternal(ans);
     } else
        val = convertToXPath(ctxt, ans);

     if(val)
       valuePush(ctxt, val);
     UNPROTECT(1);
  } else {
    RXSLT_Error(ctxt, "[R:error] error calling R function %s\n", (char *) funName);
  }

  free(xpathArgs);
  UNPROTECT(1);

  return;
}

void
RXSLT_call(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callConvert(ctxt, nargs, 0);
}

void
RXSLT_callI(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callConvert(ctxt, nargs, 1);
}



#ifdef XSL_IN_R_ONLY
void
RXSLT_init(xmlXPathParserContextPtr ctxt, int nargs)
{
}
#else
void
RXSLT_init(xmlXPathParserContextPtr ctxt, int nargs)
{
    const char *defaultArgs[] = {"Rxsltproc", "--silent"};
    char **args;
    int argc, i;
    int mustFree;

    if(R_alreadyInitialized)
      return;

#ifdef XSLT_DEBUG
    fprintf(stderr, "in RXSLT_init %d\n", nargs);fflush(stderr);
#endif
    if(nargs == 0) {
       argc = sizeof(defaultArgs)/sizeof(defaultArgs[0]);   
       args = (char **)defaultArgs;
    } else {
	args = (char **) malloc((nargs+1) * sizeof(char*));
        args[0] = strdup("Rxsltproc");
        argc = nargs+1;
        for(i = 0; i < nargs; i++) {
            xmlXPathObjectPtr obj = valuePop(ctxt); 
            if(obj->type) {
		args[i+1] = strdup(xmlXPathCastToString(obj));
	    }
	}
        mustFree = TRUE;
    }

    Rf_initEmbeddedR(argc, args);
    loadXSLPackage();
    valuePush(ctxt, xmlXPathNewBoolean(1));
    if(mustFree) {
        for(i = 0; i < nargs+1; i++) {
	    free(args[i]);
	}      
        free(args);
    }


#if DEBUG_REGISTRATION
 xsltRegisterExtFunction(getTransformCtxt(), "foo", R_URI, RXSLT_genericFunctionCall);
 RXSLT_addFunction("foo", NULL_USER_OBJECT);
#endif

    R_alreadyInitialized = 1;
    return;
}

#endif



int
loadXSLPackage(void)
{
  USER_OBJECT_ e, fun, tmp;
  int isError;

  PROTECT(fun = Rf_findFun(Rf_install("library"), R_GlobalEnv));
  PROTECT(e = allocVector(LANGSXP, 2));

  SETCAR(e, fun);
  SETCAR(CDR(e), tmp = NEW_CHARACTER(1));
  SET_VECTOR_ELT(tmp, 0, COPY_TO_USER_STRING("Sxslt"));
  R_tryEval(e, R_GlobalEnv, &isError);
  if(isError) {
      Rf_error("Couldn't load Sxslt package. Check the setting of R_LIBS");
/*
      fprintf(stderr, "Couldn't load Sxslt package. Check the setting of R_LIBS\n");
      fflush(stderr);
*/
  }

   
  UNPROTECT(2);
  return(TRUE);
}


void
RXSLT_callNamedFunction(const char *name, xmlXPathParserContextPtr ctxt, int nargs, int leaveAsRObject)
{
  USER_OBJECT_ e, ans;
//  xmlXPathObjectPtr obj;
  int errorOccurred;
  int i, j;

#if 0
  PROTECT(e = allocVector(LANGSXP, 2));
  SETCAR(e, Rf_install((char *) name));
  SETCAR(CDR(e), tmp = NEW_CHARACTER(1));
  obj = valuePop(ctxt); 
  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING(xmlXPathCastToString(obj)));
#else
  PROTECT(e = allocVector(LANGSXP, nargs+1));
  SETCAR(e, Rf_install((char *) name));

#if 0
  for(i = 0; i < nargs; i++) {
    ans = CDR(e);
    for(j = nargs-1; j > i ; j--) {
      ans = CDR(ans);
    }
    SETCAR(ans, tmp = NEW_CHARACTER(1));
    obj = valuePop(ctxt); 
    SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING(xmlXPathCastToString(obj)));
  }
#else
  for(i = 0; i < nargs; i++) {
    ans = CDR(e);
    for(j = nargs-1; j > i ; j--) {
      ans = CDR(ans);
    }
   SETCAR(ans, convertFromXPath(ctxt, valuePop(ctxt)));
  }

#endif
#endif  
  ans = R_tryEval(e, R_GlobalEnv, &errorOccurred);
  if(errorOccurred) {
      RXSLT_Error(ctxt, "error in call to R function"); 
  } else {
     PROTECT(ans);
     valuePush(ctxt, convertToXPath(ctxt, ans));
     UNPROTECT(1);
  }

  UNPROTECT(1);
  return;
}

void
RXSLT_eval(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("XSLParseEval", ctxt, nargs, 0);
}

void
RXSLT_nullEval(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("XSLNULLParseEval", ctxt, nargs, 0);
}

void
RXSLT_evalWithOutput(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("XSLParseEvalWithOutput", ctxt, nargs, 0);
}


void
RXSLT_library(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("library", ctxt, nargs, 0);
}

void
RXSLT_exists(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("exists", ctxt, nargs, 0);
}


void
RXSLT_register(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("registerXSLFunction", ctxt, nargs, 0);
}

void
RXSLT_as(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("as", ctxt, nargs, 0);
}

void
RXSLT_class(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("class", ctxt, nargs, 0);
}

void
RXSLT_length(xmlXPathParserContextPtr ctxt, int nargs)
{
    RXSLT_callNamedFunction("length", ctxt, nargs, 0);
}


Rboolean
RXSLT_internalSource(const char *fileName)
{
  USER_OBJECT_ tmp, e, ans;
  int errorOccurred;

  PROTECT(e = allocVector(LANGSXP, 2));
  SETCAR(e, Rf_install("source"));
  SETCAR(CDR(e), tmp = NEW_CHARACTER(1));

  SET_STRING_ELT(tmp, 0, COPY_TO_USER_STRING(fileName));
  
  ans = R_tryEval(e, R_GlobalEnv, &errorOccurred);
  UNPROTECT(1);
  return(errorOccurred ? FALSE : TRUE);
}

void
RXSLT_noop(xmlXPathParserContextPtr ctxt, int nargs)
{

}


void
RXSLT_source(xmlXPathParserContextPtr ctxt, int nargs)
{
   Rboolean ok;
   xmlXPathObjectPtr obj;

   obj = valuePop(ctxt); 
   ok = RXSLT_internalSource(xmlXPathCastToString(obj));
   valuePush(ctxt, xmlXPathNewBoolean(ok));
}


/* Implements the <r:eval> element for XSL. We just evaluate the
 * contents of the node */
void
REvalFunctionDefn(xsltTransformContextPtr ctxt,
		  xmlNodePtr node,
		  xmlNodePtr inst,
		  xsltElemPreCompPtr comp)
{

    int errorOccurred = 0;
    SEXP e;
    PROTECT(e = allocVector(LANGSXP, 2));
    SETCAR(e, Rf_install("XSLParseEval"));
    SETCAR(CDR(e), RXSLT_exportNode(inst));
    R_tryEval(e, R_GlobalEnv, &errorOccurred);
    UNPROTECT(1);
}

int
registerBasicFunctions(xsltTransformContextPtr ctxt, const xmlChar *URI, int fromR)
{

struct Entries {
    const char *name;
    xmlXPathEvalFunc fun;
};

 struct Entries entries[] = {
     {"init", RXSLT_init},
     {"call", RXSLT_call},
     {"callI", RXSLT_callI},
     {"eval", RXSLT_eval},
     {"source", RXSLT_source},
     {"register", RXSLT_register},
     {"exists", RXSLT_exists},
     {"library", RXSLT_library},
     {"nullEval", RXSLT_nullEval},
     {"evalWithOutput", RXSLT_evalWithOutput},
     {"length", RXSLT_length},
     {"as", RXSLT_as},
     {"class", RXSLT_class}
  };
 int n = sizeof(entries)/sizeof(entries[0]), i;

 if(fromR || R_alreadyInitialized)
	 entries[0].fun = RXSLT_noop;

#ifdef XSLT_DEBUG
    fprintf(stderr, "registering %d functions for %s\n", (fromR ? n-1 : n), R_URI);fflush(stderr);
#endif

 for(i = 0 ; i < n; i++) {
#ifdef XSLT_DEBUG
    fprintf(stderr, "registering %s\n", entries[i].name);fflush(stderr);
#endif

    if(ctxt)
	xsltRegisterExtFunction(ctxt, entries[i].name, R_URI, entries[i].fun);
    else
        xsltRegisterExtModuleFunction((const xmlChar *) entries[i].name,
                                      (const xmlChar *) R_URI, entries[i].fun);
 }


 xsltRegisterExtElement(ctxt, "eval", R_URI, REvalFunctionDefn);

 return(n);
}


void
R_callInitializeExtensionFunc(xsltTransformContextPtr ctxt, const xmlChar *URI)
{
  SEXP e;
  int errorOccurred;

  if(R_initializeModuleFunction == NULL || R_initializeModuleFunction == R_NilValue)
     return;

  PROTECT(e = allocVector(LANGSXP, 3));
  SETCAR(e, R_initializeModuleFunction);
  SETCAR(CDR(e), mkString( (char *) URI));
  SETCAR(CDR(CDR(e)), R_MakeExternalPtr(ctxt, Rf_install("xsltTransformContextPtr"), R_NilValue));


  R_tryEval(e, R_GlobalEnv, &errorOccurred);

  UNPROTECT(1); 
}

#define R_REGISTER_FUNCTIONS
#ifdef R_REGISTER_FUNCTIONS

/*
 Define  a linked list of {name, R function} pairs in which to store
 the functions that the user explicitly registers.
 */
typedef struct _RXSLTFunction RXSLTFunction;

struct _RXSLTFunction 
{
    const char *name;
    USER_OBJECT_ fun;
    RXSLTFunction *next;   
};

static RXSLTFunction FunTable = {NULL, NULL, NULL};

void
RXSLT_addFunction(const char *name, USER_OBJECT_ fun)
{
    RXSLTFunction *ptr, *prev = NULL;
    ptr = &FunTable;
    while(ptr && ptr->name) {
        if(strcmp(ptr->name, name) == 0) {
	    break;
	}
        prev = ptr;
	ptr = ptr->next;
    } 

    if(!ptr) {
	ptr = (RXSLTFunction *) malloc(sizeof(RXSLTFunction));
        ptr->next = NULL;
        ptr->name = NULL;
        ptr->fun = NULL;

        if(prev)
	    prev->next = ptr;
    }

    if(fun != NULL_USER_OBJECT)
	R_PreserveObject(fun); 
    ptr->fun = fun;
    if(!ptr->name)
	ptr->name = strdup(name);

    return; 
}

USER_OBJECT_
RXSLT_findFunction(const char *name, Rboolean *hasEntry)
{
    RXSLTFunction *ptr = &FunTable;  
    while(ptr) {
        if(ptr->name && strcmp(ptr->name, name) == 0) {
#ifdef XSLT_DEBUG
    fprintf(stderr, "Found function %s\n",name);fflush(stderr);
#endif
            if(hasEntry) 
		*hasEntry = TRUE;
	    return(ptr->fun);
	}
	ptr = ptr->next;
    }

   if(hasEntry) 
       *hasEntry = FALSE;
    return(NULL);
}

void 
RXSLT_genericFunctionCall(xmlXPathParserContextPtr ctxt, int nargs)
{
  USER_OBJECT_ e, ans, tmp, fun;
  xmlXPathObjectPtr obj, *xpathArgs;
  int i, errorOccurred = 0, addContext = 0;
  Rboolean hasEntry;

    /* Count the arguments and store them for use in the very near future. 
       Note that we pop them off the stack and put them into a list in reverse order
       as the last argument in the call is on the top of the stack, etc. */
  xpathArgs = (xmlXPathObjectPtr*) malloc(nargs * sizeof(xmlXPathObjectPtr));
  for(i = nargs - 1; i >= 0; i--)
      xpathArgs[i] = valuePop(ctxt);

    /* Find the function. */
  ans = fun = RXSLT_findFunction(ctxt->context->function, &hasEntry);
  if(hasEntry == FALSE) {
      char buf[10000];
      snprintf(buf, sizeof(buf)/sizeof(buf[0]), "Can't find function %s\n", ctxt->context->function);
      free(xpathArgs);
      RXSLT_Error(ctxt, buf);
     return;
  } else {
#ifdef XSLT_DEBUG
	  fprintf(stderr, "Calling %s by name\n", ctxt->context->function);fflush(stderr);
#endif
        /* If we got the R value NULL back, then call by name! */
      if(ans == NULL || ans == NULL_USER_OBJECT) 
	  ans = fun = Rf_findFun(Rf_install(ctxt->context->function), R_GlobalEnv);

      addContext = OBJECT(fun) && R_isInstanceOf(fun, "XSLTContextFunction");
  }


    /* Now that we know the number of arguments, create the expression */
  PROTECT(e = allocVector(LANGSXP, nargs + 1 + addContext));

  SETCAR(e, fun);
  tmp = CDR(e);

  if(addContext) {
      SETCAR(tmp, RXSLT_exportPointer(ctxt, "XMLXPathParserContext"));
      tmp = CDR(tmp);
  }
  /* Put the XSL arguments into the R call, converting them from XSL to R as we go */

  for(i = 0 ; i < nargs; i++) {
    obj = xpathArgs[i]; 
    SETCAR(tmp, convertFromXPath(ctxt, obj));
    tmp = CDR(tmp);
  }

      /* perform the call to the R function */
  ans = R_tryEval(e, R_GlobalEnv, &errorOccurred);

  if(errorOccurred) {
      /* Throw an error! */    
      RXSLT_Error(ctxt, "error when evaluating call to R function");
  } else {
     xmlXPathObjectPtr  val;
     PROTECT(ans);
     val = convertToXPath(ctxt, ans);
     if(val)
       valuePush(ctxt, val);
     UNPROTECT(1);
  }

  free(xpathArgs);
  UNPROTECT(1);

  return;
}



USER_OBJECT_
RXSLT_registerFunction(USER_OBJECT_ name, USER_OBJECT_ fun, USER_OBJECT_ uri, USER_OBJECT_ symbol, 
                        USER_OBJECT_ context)
{
    xsltTransformContextPtr ctxt = NULL;
    xmlXPathEvalFunc sym;

    if(GET_LENGTH(context)) {
	ctxt = (xsltTransformContextPtr)  R_ExternalPtrAddr(context);
    } 

    if(!ctxt)
      ctxt  = getTransformCtxt();

    if(!ctxt) {
         PROBLEM "NULL value for xslTransformContext. One cannot register an R function with XSLT when not applying an XSL style sheet."
	 ERROR;
    }


    if(GET_LENGTH(symbol) < 1) {
	sym = RXSLT_genericFunctionCall;
    } else {
        sym = (xmlXPathEvalFunc) R_ExternalPtrAddr(symbol);
    }

    RXSLT_addFunction(CHAR_DEREF(STRING_ELT(name, 0)), fun); /* XXX check for memory leaks */
    /* Register the S function in a hashtable with this name and function. */
#ifdef XSLT_DEBUG
    fprintf(stderr, "Registering function (%s) %s with context %p\n",
               CHAR_DEREF(STRING_ELT(uri, 0)), CHAR_DEREF(STRING_ELT(name, 0)), ctxt);fflush(stderr);
#endif
    if(ctxt)
        xsltRegisterExtFunction(ctxt, CHAR_DEREF(STRING_ELT(name, 0)),
	   	  	           CHAR_DEREF(STRING_ELT(uri, 0)), 
                                   sym);
    else
        xsltRegisterExtModuleFunction((const xmlChar *) CHAR_DEREF(STRING_ELT(name, 0)),
                                      (const xmlChar *) CHAR_DEREF(STRING_ELT(uri, 0)), sym);

    return(NULL_USER_OBJECT);
}

#endif /* R_REGISTER_FUNCTIONS */



USER_OBJECT_
R_setXInclude(USER_OBJECT_ status)
{
   int oldValue = xsltGetXIncludeDefault();

   if(GET_LENGTH(status))
       xsltSetXIncludeDefault(INTEGER(status)[0]);

   return(ScalarInteger(oldValue));
}


typedef struct {
    int i;
    SEXP els;
} RXMLHashScannerInfo;

void
R_getKeyNames(void *el, void *data, xmlChar *name)
{
    RXMLHashScannerInfo *info = ( RXMLHashScannerInfo *) data;
    SET_STRING_ELT(info->els, info->i, COPY_TO_USER_STRING(name));
    info->i++;
}


SEXP
R_xslGetGlobalVariableNames(SEXP r_ctxt)
{
    xmlXPathParserContextPtr ctxt = NULL;
    xsltTransformContextPtr xslCtxt;
    int n;
    SEXP ans;
    RXMLHashScannerInfo data;

    ctxt = (xmlXPathParserContextPtr) R_ExternalPtrAddr(r_ctxt);
    xslCtxt = xsltXPathGetTransformContext(ctxt);

    if(!xslCtxt || !xslCtxt->globalVars) 
	return(NEW_CHARACTER(0));

    n = xmlHashSize(xslCtxt->globalVars);

    PROTECT(ans = NEW_CHARACTER(n));

    data.els = ans;
    data.i = 0;
    xmlHashScan(xslCtxt->globalVars, R_getKeyNames, &data);
    UNPROTECT(1);
    return(ans);
}

