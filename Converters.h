#ifndef R_XSLT_CONVERTERS_H
#define R_XSLT_CONVERTERS_H

#ifndef XSL_IN_R_ONLY
#include <libxslt/libxslt.h>
#include <libxslt/xsltInternals.h>
#endif

#include <libxml/tree.h>
#include <libxml/xpath.h>

#include "RSCommon.h"

xmlXPathObjectPtr convertToXPath(xmlXPathParserContextPtr ctxt, USER_OBJECT_ ans);
USER_OBJECT_ convertFromXPath(xmlXPathParserContextPtr ctxt, xmlXPathObjectPtr val);
USER_OBJECT_ RXSLT_exportNode(xmlNodePtr val);
USER_OBJECT_ RXSLT_exportPointer(void *val, const char *className);

void RXSLT_Error(xmlXPathParserContextPtr ctxt, const char *msg, ...);

USER_OBJECT_ RXSLT_exportNodeSet_direct(xmlNodeSetPtr val);
USER_OBJECT_ R_createBasicXMLDocRef(xmlDocPtr doc);

void RXSLT_Warning(xmlXPathParserContextPtr ctxt, const char *msg);
#endif
