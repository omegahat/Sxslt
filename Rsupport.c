#include "Rsupport.h"

#if 0

typedef struct {
    USER_OBJECT_ expression;
    USER_OBJECT_ val;
} ProtectedEvalData;

void
protectedEval(void *d)
{
    ProtectedEvalData *data = (ProtectedEvalData *)d;

    data->val = eval(data->expression, R_GlobalEnv); 
    PROTECT(data->val);
}


USER_OBJECT_
tryEval(USER_OBJECT_ e, int *ErrorOccurred)
{
 Rboolean ok;
 ProtectedEvalData data;

 data.expression = e;
 data.val = NULL;

 ok = R_ToplevelExec(protectedEval, &data);
 if(ErrorOccurred) {
     *ErrorOccurred = (ok == FALSE);
 }
 if(ok == FALSE)
     data.val = NULL;
 else
     UNPROTECT(1);

 return(data.val);
}
#endif

Rboolean
R_isInstanceOf(USER_OBJECT_ obj, const char *klass)
{

    USER_OBJECT_ klasses;
    int n, i;
    SEXP e, r_ans;
    Rboolean ans;

    klasses = GET_CLASS(obj);
    n = GET_LENGTH(klasses);
    for(i = 0; i < n ; i++) {
	if(strcmp(CHAR_DEREF(STRING_ELT(klasses, i)), klass) == 0)
	    return(TRUE);
    }

    PROTECT(e = allocVector(LANGSXP, 3));
    SETCAR(e, Rf_install("is"));
    SETCAR(CDR(e), obj);
    SETCAR(CDR(CDR(e)), mkString(klass));

    r_ans = Rf_eval(e, R_GlobalEnv);
    ans = LOGICAL(r_ans)[0];
    UNPROTECT(1);


    return(ans);
}
