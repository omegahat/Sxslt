# Added for case when used as a .Rprofile.
library(Sxslt)

Summary <-
function(nodes, both= FALSE, digits = options("digits"))
{
  dataName <- nodes[1]$attributes["data"]

  vars <- unlist(sapply(1:nodes[1]$length,  function(i) {
                          nodes[1]$children[[i]]$attributes["name"]
                        }))

    # load and attach the dataset. No need to attach. 
  data(list=dataName)
  data = get(dataName)

    # create a dataframe from the subset of variables
    # identified by the <var> elements.
  df <- data[, vars]

    # Now compute the statistics.

  makeRow <- function(x, before="", after="") {
    if(before != "")
      before <- paste("<th>",before,"</th>", sep="")
    if(after != "")
      after <- paste("<th>", after,"</th>", sep="")

    if(is.numeric(x)) {
      x <- round(x, digits = 2)
      header <- "<th align='right'>"      
    } else
      header <- "<th>"

    paste(before, paste(header, x,"</th>", collapse=""), after, collapse="")
  }
  
  corTxt <- apply(cor(df), 1, makeRow)
  corTxt <- paste(paste("<th>", vars,"</th>"), corTxt)
  txt <- c(makeRow(sapply(df, mean), "Mean"),  makeRow(sapply(df, var), "Variance"))
  
  txt <- paste("<tr>",c(makeRow(c("",vars)), corTxt, "", txt), "</tr>", sep="", collapse="\n")

  txt
}  

registerXSLFunction("summary", Summary)


showData =
function(name)
{
  if(inherits(name, "XPathNodeSet"))
    name <- name[1]$children[[1]]$value
    
  obj <- get(name)
  library(R2HTML)
  con = textConnection(".SxsltHTML", "w")
  on.exit(close(con))
  HTML(obj, file = con)

  paste(.SxsltHTML, collapse = "\n")
}

registerXSLFunction("showData", showData)

