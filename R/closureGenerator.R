closureGenerator =
  #
  #
  #
  #
function(..., .funs = list(...), .vars = list(), .env = new.env())  
{
 f = function(env = .env, .variables = .vars) {
        sapply(names(.variables),
                function(id) {
                  x = .variables[[id]]
                  if(is.function(x))
                    environment(x) = env
                  assign(id, x, env)
                })

        
        ans = lapply(names(.funs),
                      function(id) {
                        x = .funs[[id]]
                        environment(x) <- env
                                        # put the function into its own environment.                 
                        assign(id, x, env)
                        x
                      })

        names(ans) = names(.funs)
        ans
     }

 class(f) = "ClosureGenerator"

 f
}
