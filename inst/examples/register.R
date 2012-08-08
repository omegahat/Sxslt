print("In register.R")
  registerXSLFunction("foo", function(x) { cat("in foo\n"); print(x) ; x*2})
  registerXSLFunction("bar", function(x,y) { cat("in bar\n"); print(x) ; print(y) ; nchar(x) + nchar(y)})

