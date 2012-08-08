#include "RSCommon.h"

#include <libxml/xpath.h>

#include "Converters.h"

USER_OBJECT_ RSXSLT_getNodeValue(xmlNodePtr node);

xmlNodeSetPtr
R_getNodeSetPtr(USER_OBJECT_ sns)
{
    USER_OBJECT_ tmp = GET_SLOT(sns, Rf_install("ref"));
    xmlNodeSetPtr ns;
    ns = (xmlNodeSetPtr) R_ExternalPtrAddr(tmp);	
    return(ns);
}


USER_OBJECT_
RXSLT_getNodeSetLength(USER_OBJECT_ sns)
{
    USER_OBJECT_ ans;
    xmlNodeSetPtr ns;
    ns = R_getNodeSetPtr(sns);

    ans = NEW_INTEGER(1);
    INTEGER_DATA(ans)[0] = xmlXPathNodeSetGetLength(ns);

    return(ans);
}

USER_OBJECT_
RXSLT_getNodeSetElement(USER_OBJECT_ nodeSet, USER_OBJECT_ el)
{
    xmlNodeSetPtr ns;
    xmlNodePtr ptr;
    ns = R_getNodeSetPtr(nodeSet);

    if(ns->nodeTab == NULL)
	return(NULL_USER_OBJECT);

    ptr = ns->nodeTab[INTEGER_DATA(el)[0]];

    if(ptr == NULL)
	return(NULL_USER_OBJECT);

    return(RXSLT_exportNode(ptr));
}

enum {
    NODE_NAME = 1,
    NODE_LENGTH,
    NODE_CHILDREN,
    NODE_DOC,
    NODE_ATTRIBUTES,
    NODE_NAMESPACE,
    NODE_NAMESPACE_DEFS,
    NODE_SIBLING,
    NODE_PARENT,
    NODE_VALUE
};

USER_OBJECT_
RXSLT_getNodeAttribute(USER_OBJECT_ el, USER_OBJECT_ which)
{
    USER_OBJECT_ ans = NULL_USER_OBJECT;
    xmlNodePtr ptr;
    ptr = (xmlNodePtr) R_ExternalPtrAddr(el);

    switch(INTEGER_DATA(which)[0]) {
        case NODE_NAME:
	  PROTECT(ans = NEW_CHARACTER(1));
          SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(ptr->name));
          UNPROTECT(1);
	break;
        case NODE_NAMESPACE:
	  PROTECT(ans = NEW_CHARACTER(1));
          if(ptr->ns && ptr->ns->prefix)
	      SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(ptr->ns->prefix));
          UNPROTECT(1);
	break;
        case NODE_LENGTH:
	  ans = NEW_INTEGER(1);
	  {
	      int n = 0;
	      xmlNodePtr c = ptr->children;
	      while(c) {
		  c = c->next;
		  n++;
	      }
              INTEGER_DATA(ans)[0] = n;
	  }
	break;
        case NODE_DOC:
            ans = RXSLT_exportPointer(ptr->doc, "XMLDoc");
	    break;
        case NODE_CHILDREN:
            ans = RXSLT_exportPointer(ptr->children, "XMLChildren");
	    break;
        case NODE_SIBLING:
            ans = RXSLT_exportNode(ptr->next);
	    break;
        case NODE_PARENT:
            ans = RXSLT_exportNode(ptr->parent);
	    break;
        case NODE_ATTRIBUTES:
	    /*  ans = RXSLT_exportPointer(ptr->properties, "XMLAttributes"); */
            ans = RXSLT_exportPointer(ptr, "XMLAttributes"); /* Note this is the node itself,
                                                                not ptr->properties. */
	    break;

        case NODE_VALUE:
            ans = RSXSLT_getNodeValue(ptr);
	    break;
    default:
         PROBLEM "No such attribute"
	     ERROR;
    }

    return(ans);
}

USER_OBJECT_
RXSLT_getAttribute(USER_OBJECT_ attrs, USER_OBJECT_ names)
{
    int n, i, ctr = 0;
    xmlNodePtr node;
    USER_OBJECT_ ans;

    node = (xmlNodePtr) R_ExternalPtrAddr(attrs);
    n = GET_LENGTH(names);
  
    PROTECT(ans = NEW_CHARACTER(n));
    for(i = 0; i < n ; i++) {
	xmlChar *val;
        val = xmlGetProp(node, CHAR_DEREF(STRING_ELT(names, i)));
        if(val && val[0]) {
	    SET_STRING_ELT(ans, i, COPY_TO_USER_STRING(val));
            ctr++;
	}
    }

    if(ctr == 0) {
	ans = NEW_CHARACTER(0);
    } else
	SET_NAMES(ans, names);
    UNPROTECT(1);
    return(ans);
}

USER_OBJECT_
RXSLT_getAttributeNames(USER_OBJECT_ snode)
{
    int n, i;
    xmlAttrPtr ptr;
    xmlNodePtr node;
    USER_OBJECT_ ans;

    node = (xmlNodePtr) R_ExternalPtrAddr(snode);
    ptr = node ->properties;
    n = 0;
    while(ptr) {
        n++;
	ptr = ptr->next;
    }

    if(n == 0)
	return(NULL_USER_OBJECT);

    PROTECT(ans = NEW_CHARACTER(n));
    for(ptr= node->properties, i = 0; i < n; i++) {
	SET_STRING_ELT(ans, i, COPY_TO_USER_STRING(ptr->name));
        ptr = ptr->next;
    }
    UNPROTECT(1);
    return(ans);
}


USER_OBJECT_
RXSLT_getChildren(USER_OBJECT_ snode, USER_OBJECT_ which)
{
    int n = GET_LENGTH(which), i, numKids = 0;
    USER_OBJECT_ ans;
    xmlNodePtr tmp;
    xmlNodePtr node = (xmlNodePtr) R_ExternalPtrAddr(snode);

    tmp = node;
    while(tmp) {
        tmp = tmp->next;
	numKids++;
    }

    PROTECT(ans = NEW_LIST(n));
    for(i = 0; i < n ; i++) {
  	/* Get the i-th child element. */
        int j, k=0;
        j = INTEGER_DATA(which)[i];
        if(j > -1 && j < numKids) {
            tmp = node;
            while(k < j) {
		tmp = tmp->next;
                k++;
	    }
	    SET_VECTOR_ELT(ans, i, RXSLT_exportNode(tmp));
	}
    }
    UNPROTECT(1);
    return(ans);
}


/**
 This is intended to to get a string representation of the node.
 But doesn't currently give the correct value back.
 */
USER_OBJECT_
RSXSLT_getNodeValue(xmlNodePtr node)
{
    xmlChar *mem;
    USER_OBJECT_ ans;
    PROTECT(ans = NEW_CHARACTER(1));

#if 0
#if DUMP_WITH_ENCODING
    xmlDocDumpFormatMemoryEnc(doc, &mem, &size, NULL, 1);
#else
    xmlDocDumpMemory(node->doc, &mem, &size);
#endif
#else
    mem = xmlNodeListGetString(node->doc, node, 1);
#endif

  if(mem) {
#ifdef XSLT_DEBUG
      fprintf(stderr, "node name %s: %s\n", node->name, mem);fflush(stderr); 
#endif
      SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING(mem));
  }
  xmlFree(mem);

  UNPROTECT(1);
  return(ans);
}



