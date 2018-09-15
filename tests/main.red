Red [
  author: "Nędza Darek"
  license: "Just point to the gist/github"
  version: 0.0.1
  subversion: 'alpha

]
do %../main.red

f42: func [a b /foo c d /baz g h][
  wait 2
  return reduce [
    'a a
    'b b

    'foo foo
    'c c
    'd d

    'baz baz
    'g g
    'h h
  ]
]
memoize f42
time1: now/time
return-value1: f42 1 2
time2: now/time
return-value2: f42 1 2
time3: now/time

either return-value1 = return-value2 [
  print "#### ^/ You should see 2 lines: "
  print {"NOT in the cache"}
  print "and"
  print {"In the cache"}

  print ""
  print "I'm making a not-yet-cached function wait ~2 seconds"
  print "A cached version should run very fast"
  either all [
    2 = to-integer round to-float (time2 - time1)
    0.5 > to-integer round to-float (time3 - time2)
  ][
    print "The cached version runs slower - as expected"
  ][
    print "There is something wrong with the time: "
    print "Before"
    print time1
    print "After a non-cached function: "
    print time2
    print "After a cached function: "
    print time3
  ]
][
  print "Return values are different: "
  print "1st: "
  probe return-value1
  print "2nd: "
  probe return-value2
]
