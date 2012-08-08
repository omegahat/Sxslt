mergeXSLTParams <-
  #
  # Merge the two groups of parameters from ... and .params
  # leaving those in ... unaltered if also in .params and
  # adding any in .params that are not also in ...
  # and then ensure that the values are quote correctly.
  #
function(..., .params = character(0))
{
  fix = function(x) {
       # worry about the case where the character vector has more than one element.

    is.log = sapply(x, is.logical)
    if(any(is.log))
       x[is.log] = as.integer(x[is.log])

    is.char = sapply(x, is.character)

    if(any(is.char))  
      x[is.char] = fixQuotes(unlist(x[is.char]))


    sapply(x, as.character)
  }
  
  tmp = args = list(...)  

  args = fix(args)
  .params = fix(.params)


  other <- setdiff(names(.params), names(args))
  if(length(other))
    args[other] <- .params[other]

  .params <- unlist(args)

      # check that all parameters have names.
  if(any(names(.params) == "")) 
    stop("invalid parameters: no name")
 
  .params
}  


fixQuotes =
   # Ensure that each string is enclosed with quotes
   # fixing those that have no quotes, and the others that start with or end with
   #  " or ' but don't have the corresponding one on the other end (start or finish).
   # Test:
   #   x = c(a = "abc", b = "'xyz", c = '"xyz', d = "fail'", e = 'fail"', f = "'ok'", g = '"okay"')
   # cat(fixQuotes(x), "\n")
   # Should return 'abc' 'xyz' "xyz" 'fail' "fail" 'ok' "okay" \
function(.params)
{

   # find the elements that have no quotes around them.
  noquotes = grep("^[^'\"].*[^'\"]$", .params) 

  if(length(noquotes)) {
     warning("adding surrounding quotes to  parameter(s) ", paste(names(.params)[noquotes], collapse = ", "))
     # add the quotes ' ' around these strings.
    .params[noquotes] = paste("'", .params[noquotes], "'", sep = "")
  }
  

   # check the quotation marks '' or "" around each one
   # are present AND match, if present.
  i = regexpr("^(['\"]).*\\1$", .params)

  if(any(i == -1)) {
    warning("quoting parameters ", paste(names(.params)[i == -1], collapse = ", "))
      # have to deal with the different cases here
      # beginning quote, but not ended
      # ending quote, but none at start

     v = .params[ i == -1]
     start = substring(v, 1, 1)
     tmp = start %in% c("'", '"')
     if(any(tmp)) {
        v[tmp] = paste(v[tmp], start[tmp], sep = "")
     }

    if(any(!tmp)) {
        end = substring(v[!tmp], nchar(v[!tmp]))
        v[!tmp] = paste(end, v[!tmp], sep = "")
     }

     .params[i == -1] = v
  }

  if(FALSE) {   # make certain all the elements are correct now!
     ok = grep("(^'.*'$|^\".*\"$)", .params)
     if(any(ok != seq(along = .params)))
	stop("error!")
  }

  .params
}  

