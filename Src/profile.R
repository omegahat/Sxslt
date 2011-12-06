readXSLProfileData =
  #
  # This is called by some internal C code to convert 
  # the XML document giving the profile information.
  # It is easiest to write the code in R to extract that information
  # and put it in a data frame.
  # We find out how many nodes there are and create a 
function(doc)
{
  profile = xmlRoot(doc)
  n = xmlSize(profile)
  ans = data.frame(rank = integer(n),
                   match = character(n),
                   name = character(n),
                   mode = character(n),
                   calls = integer(n),
                   time = integer(n),
                   stringsAsFactors = FALSE
                  )

  xmlSApply(profile,
            function(node) {
              a = xmlAttrs(node)
              i = as.integer(a["rank"])
              
              ans[i, c("rank", "calls", "time")] <<- c(i, as.integer(a[c("calls", "time")]))
              ans[i, c("match", "name", "mode")] <<- a[c("match", "name", "mode")]
            })
  ans
}  

readXSLProfileResults =
  #
  # This doesn't seem to be used anymore.
  #
  #
function(fileName)
{
  txt = readLines(fileName)
  n = length(txt)
  txt = gsub("^ *", "", txt[-c(1, 2, n - 1, n) ])
  ans = strsplit(txt, " +")
  
  class(ans) = "XSLProfileResults"
  ans
}  
