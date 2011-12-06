#ifndef R_SUPPORT_H
#define R_SUPPORT_H


#include "RSCommon.h"

USER_OBJECT_ tryEval(USER_OBJECT_ e, int *ErrorOccurred);
Rboolean R_isInstanceOf(USER_OBJECT_ obj, const char *klass);

int loadXSLPackage(void);
void registerRModule(int fromR);
#endif
