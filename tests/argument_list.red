Red [
  author: "Nędza Darek"
  license: "Just point to the gist/github"
  version: 0.0.1
  subversion: 'alpha

]

do %../argument_list.red
f: func [a b /foo c d /baz e f][]

params: get-params f
either params = [a b] [
  print "`get-params` - OK"
][
  print "`get-params`: "
  print "[a b] not equal: "
  probe params
]

refs: get-refinements f
either refs = [/foo [c d] /baz [e f]] [
  print "`get-refinements` - OK"
][
  print "`get-refinements`: "
  print "[/foo [c d] /baz [e f]] not equal: "
  probe params
]
