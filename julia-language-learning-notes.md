This is a note book that records my julia language learning process.

I am exploring FaSTLMM gpu implementation using Julia.

$: String interpolation operator

### Compilation stages of Julia
Reference: [1](https://juliacomputing.com/blog/2016/02/09/static-julia.html),
           [2](http://blog.leahhanson.us/post/julia/julia-introspects.html),
           [3](https://juliacomputing.com/blog/2016/02/09/static-julia.html),


Learning Julia CUDA implementation: wrappers for CUDA
It uses `ccall` to call CUDA library. More about [ccall](https://docs.julialang.org/en/stable/stdlib/c/#C-Interface-1)

Julia code is internally represented as a data structure that is accessible from the language itself.

The meaning of colon (:) in Julia language: it is unevaluated or quoted symbols. Think of quotes sometimes in English refers to 'copper' as the word, rather than the metal. Similar in Julia, `:x` means look at x itself, rather than what x represents.

### Understand Module, Import, and Using in Julia.
I will try to express my understanding of these key concepts. It is a summary of these documentations:
[reference 1](https://en.wikibooks.org/wiki/Introducing_Julia/Modules_and_packages)

1. `Module`: Related functions and other definitions can be grouped together and stored in modules. (like an object?)
2. `import`: control which variable is visible to this module.(you can only import variables that are exported by that module)
3. `export`: and and specify which of your names are intended to be public (via exporting).
4. `using` : when a variable cannot be resolved, the system will search the `using` libs/modules and import if it exists there.
5. Difference between `import` and `using`: import operates one name at a time, rather than `using` the entire library(add the module to be searched by system). But, you can only extend the function if it is `import`ed.
6.



### What does colon (:) mean in Julia
So what is a symbol, really? The answer lies in something that Julia and Lisp have in common – the ability to represent the language's code as a data structure in the language itself.
A good [explaination](https://stackoverflow.com/questions/23480722/what-is-a-symbol-in-julia) for Symbol in Julia
```
Example:
julia> eval(op)
+ (generic function with 1 method)

julia> op = :+
:+

julia> eval(op)
+ (generic function with 1 method)
```
