Red [
  author: "Nędza Darek"
  license: "Just point to the gist/github"
  version: 0.0.1
  subversion: 'alpha

]
get-params: function ['fun] [
  params: select parse-func-spec get fun 'params
  names: copy []
  foreach param params [
    append names param/name
  ]
  return names
]

get-refinements: function ['fun][
  refinements-spec: select parse-func-spec get fun 'refinements
  refinements: copy []
  foreach refinement refinements-spec [
    append refinements refinement/name

    append/only refinements copy []
    last-ref: last refinements
    foreach param refinement/params [
      append last-ref param/name
    ]
  ]
  return refinements
]
