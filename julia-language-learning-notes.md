This is a note book that records my julia language learning process.

I am exploring FaSTLMM gpu implementation using Julia.

$: String interpolation operator

### Compilation stages of Julia
Reference: [1](https://juliacomputing.com/blog/2016/02/09/static-julia.html),
           [2](http://blog.leahhanson.us/post/julia/julia-introspects.html),
           [3](https://juliacomputing.com/blog/2016/02/09/static-julia.html),
### Metaprogramming:

Programming is a very creative task, but there are also some of tedious tasks in programming. Sometimes, you need a function that can operate on different data types. You end up with a bunch of functions that looks almost identical, but with different data types. Wouldn't it be nice if the program can generate the code for these repetitive code? The answer is metaprogramming. And Julia, influenced by Lisp, has a strong metaprogramming orientation. So in this tutorial, I will use Julia to demonstrate metaprogramming. You are welcome to try the demo code in Julia.

For many people, the most familiar form of metaprogramming, is using macro.
You might be already using macro in Julia. For exmaple, `@time` is a macro that measures the running time and memory allocations of a function.

```
julia> @time 2^30
  0.001808 seconds (211 allocations: 13.809 KiB)
1073741824
```
`@` indicates that you are using a macro. So now, like most programming lanaugage's first lesson, let's write a hello world macro.

```
macro helloWorld()
  return :(println("Hello World"))
end

julia> @helloWorld()
Hello World
```
Notice the return statement starts with a `:` and is wrapped with parenthesis?
In julia, `:` is quote symbol, referred to as "the colon operator".
To make an analogy with English language, when we want to use the word itself, rather than the meaning of the word, we usually wrap the word in quotes.
Example: "Cat" spells C-A-T.

If you have multiple lines of code to quote, rather than using `:`, you can use `quote ... end` keyword to construct an expression.

```
macro helloWorld()
  quote
    println("Hello World")
  end
end
```
This will produce the same result as above example.

If you want to replace a string with variable, use `$` for string interpolation:

```
macro hello(name)
  quote
    println("Hello ", $name)
  end
end

julia> @hello("America!")
Hello America!
```

Lastly, let's construct a more complicated macro:
```
macro dotimes(n, body)
    quote
        for i = 1:$(esc(n))
            $(esc(body))
        end
    end
end
```


## Code generation



Let's try to solve the above mentioned task - writing a function that can generate code for different data types. Julia is the language used in this example.



Examples:
Usage:
Important syntax/symbols/functions and their meaning and usage:
1. quote or :
2. eval() and @eval
3. dump
4. $
5. macro , macroexpand()
6. fieldnames()
7. esc()
Important characteristics of Julia metaprogramming:
           1. hygienic macros.



Sometimes, Lazy is a virtual. It drives human to invent, and to be more efficient.

If you need to write something twice, think twice.

Metaprogramming helps you with those tedious tasks.
Metaprogramming is writting a program that generate code.
It is like writing a template for the function.
Here is an example to writing a

Metaprogramming is one way to take programming one step further to be more lazy :)


If we are already programming to automate tasks, why not take a step furthur to


Metaprogramming is writing a program that can write a program.

Metaprogramming



Metaprogramming is writing a program that can generate code.



Introduction on Metaprogramming: [link](https://www.ibm.com/developerworks/library/l-metaprog1/)

To learn more about @eval notation, click [here](https://docs.julialang.org/en/stable/manual/metaprogramming/#Metaprogramming-1).

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
