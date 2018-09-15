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
    par: to-paren copy []
  ]

  ; get normal arguments
  foreach param params [
    append cache-checks [append par]
    append cache-checks param
  ]

  ; get refinements + its arguments
  foreach [ref args] refs [
    ; append to `par` only if you call refinement
    append cache-checks 'if
    append cache-checks to-get-word ref
    append/only cache-checks copy []
    last-refinement-check: last cache-checks

    append last-refinement-check [append par]
    append last-refinement-check ref

    ; refinement's arguments
    foreach arg args [
      append last-refinement-check [append par]
      append last-refinement-check arg
    ]
  ]

  ; makes word `cache` holds... cache
  append cache-checks [cache]

  ; checks if result is in the cache
  append cache-checks [
    ; for debug purpose: print whenever or not result is in the cache
    either cache/(par) [
      print "In the cache"
      ; I've changed `return`, so `old-return` is Red's `return`
      old-return cache/(par)
    ][
      ; new `return` updates the cache from within the code
      ; so this is for debug purpose
      print "NOT in the cache"
    ]
  ]

  set fun
    func
      spec-of get fun
      bind  head
              insert
                (body-of get fun)
                cache-checks
            context [
              par: none
              cache: copy []
              old-return: :system/words/return
              return: func [val] [
                ; sadly we cannot set cache/:par: val directly
                append/only cache par
                append/only cache val

                ; just normal return here:
                old-return val
              ]
            ]

]
