Red [
  author: "Nędza Darek"
  license: "Just point to the gist/github"
  version: 0.0.1
  subversion: 'alpha

]
do %argument_list.red
memoize: function ['fun][
  unless any-function? get fun [
    make error! "<fun> is not an <any-function!>"
  ]

  params: get-params        :fun
  refs:   get-refinements   :fun

  cache-checks: copy [
    ; cache is indexed by paren! - to make it visually stand out
    ; e.g. cache: [ (1 2 /foo 3 4)   42]
    ; cache/(to-paren [1 2 /foo 3 4]) ; 42

    ; `par` will word holds argument/refinement list
    append/only par to-paren clear copy []
  ]

  ; get normal arguments
  foreach param params [
    append cache-checks [append last par]
    append cache-checks param
  ]

  ; get refinements + its arguments
  foreach [ref args] refs [
    ; append to `par` only if you call refinement
    append cache-checks 'if
    append cache-checks to-get-word ref
    append/only cache-checks copy []
    last-refinement-check: last cache-checks

    append last-refinement-check [append last par]
    append last-refinement-check ref

    ; refinement's arguments
    foreach arg args [
      append last-refinement-check [append last par]
      append last-refinement-check arg
    ]
  ]

  ; makes word `cache` holds... cache
  append cache-checks [cache print ['par] probe par "********"]

  ; checks if result is in the cache
  append cache-checks [
    ; for debug purpose: print whenever or not result is in the cache
    either cache/(last par) [
      print "In the cache"
      ; I've changed `return`, so `old-return` is Red's `return`
      old-return cache/(last par)
    ][
      ; new `return` updates the cache from within the code
      ; so this is for debug purpose
      print "NOT in the cache"
      print ['cache mold cache]
    ]
  ]
    
  append cache-checks [print "START OF THE FUNCTION:"]
  set fun
    func
      spec-of get fun
      bind  head
              insert
                (body-of get fun)
                cache-checks
            context [
              par: copy []
              cache: copy []
              old-return: :system/words/return
              return: func [val] [
                ; sadly we cannot set cache/:par: val directly
                ; PAR IS NOT CHANGED TO 2+ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                print "FUNCTION: return CACHE: +>>>>>"
                                    
                    print 'par probe par
                    print 'val probe val 

                unless cache/(last par) [

                    
                    append/only cache last par
                    append/only cache val
                    print 'cache probe cache

                ]
                print ["par before remove" mold par]
                remove back tail probe par
                print ["par after remove" mold par]
                print "*********"
                
                ; just normal return here:
                old-return val
              ]
            ]

]
