Red [
  author: "Nędza Darek"
  license: "Just point to the gist/github"
  version: 0.0.2
  subversion: 'alpha

]
do %../main_insert_return.red

fib: func [n] [
     either  n < 2 [
        return n
    ] [
        return ( (fib (n - 2) ) + (fib (n - 1) ) )
    ]  
]
fib: memoize fib

test-fib: function [n /extern fib] [
    start-fib-first-run: now/time/precise 
    first-value: fib n
    end-fib-first-run: now/time/precise 
    first-run-time: end-fib-first-run - start-fib-first-run
    
    start-fib-second-run: now/time/precise 
    second-value: fib n
    end-fib-second-run: now/time/precise 
    second-run-time: end-fib-second-run - start-fib-second-run
    
    ret: #()
    ret/n: n
    ret/first-run: #()
    ret/first-run/value: first-value
    ret/first-run/time: first-run-time
    
    ret/second-run: #()
    ret/second-run/value: second-value 
    ret/second-run/time: second-run-time
    
    ret
    
]
compare-runs: func [run] [
    either all [
       ; 
       (take/part to-string fibonacci-numbers-few/(run/n) 12) = (take/part to-string run/first-run/value 12) 
       run/first-run/value = run/second-run/value
       
       ; memoized version should run faster
       (run/first-run/time > run/second-run/time)
       ; but for small nubmers time is very small or 0; HOW TO TEST IT?
       or (run/first-run/time = 0:00:00)
    ][
        print ["Fibonnaci " run/n " - OK!"]
    ][
        print ["Fibonacci " run/n " - BAD!!!"]
    ]
]

; http://www.fullbooks.com/The-first-1001-Fibonacci-Numbers.html
fibonacci-numbers-few: #(
    10 55
    100.0 354224848179261915075.0
    300.0 222232244629420445529739893461909967206666939096499764990979600.0
    600.0 110433070572952242346432246767718285942590237357555606380008891875277701705731473925618404421867819924194229142447517901959200.0
)
fib10: test-fib 10
compare-runs fib10
probe fib10

; the Red doesn't have "Big numbers" so I'm using `float!` - might not be very precise
fib100: test-fib 100.0
fib100: test-fib 100.0
compare-runs fib100
probe fib100

fib300: test-fib 300.0
compare-runs fib300
probe fib300

fib600: test-fib 600.0
compare-runs fib600
probe fib600

; print "Reset fibbonacci function"
; BROKEN ON THE STABLE 0.6.4 - console crush
; SEEMS TO WORK ON `Red 0.6.4 for Windows built 19-Jan-2019/13:54:56+01:00 commit #4880ddb`
fib: func [n] [
     either  n < 2 [
        return n
    ] [
        return ( (fib (n - 2) ) + (fib (n - 1) ) )
    ]  
]
fib: memoize fib
fib600: test-fib 600.0
compare-runs fib600
probe fib600

