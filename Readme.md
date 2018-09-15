# Memoization for the Red (prototype)

## Info:

[Memoization](https://en.wikipedia.org/wiki/Memoization) is
> or memoisation is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls

## Usage:
See the [tests directory](/tests).

## Structure of the cache:

The cache is stored in the block. Keys are `paren!` type and values can have any Red's type.  
The order of the call (`fun/baz/bar` vs `fun/bar/baz`) doesn't matter.   
Examples (function call -> key; `foo: func [a b /baz c /bar d][]`):  

`foo 1 2` -> `(1 2)`  
`foo/baz 1 2 3` -> `(1 2 /baz 3)`  
`foo/baz/bar 1 2 3 4` -> `(1 2 /baz 3 /bar 4)`  
`foo/bar/baz 1 2 3 4` -> `(1 2 /baz 4 /bar 3)`

## License:
See [license.md](/license.md).
