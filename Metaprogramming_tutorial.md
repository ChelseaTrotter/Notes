# Metaprogramming in Julia:

Programming is a very creative task, but there are also some of tedious tasks in programming. Sometimes, you need a function that can operate on different data types. You end up with a bunch of functions that looks almost identical, but with different data types. Wouldn't it be nice if the program can generate the code for these repetitive code? If you need to write soemthing twice, think twice. The answer is metaprogramming.

Julia, influenced by Lisp, has a strong metaprogramming orientation. So in this tutorial, I will use Julia to demonstrate metaprogramming. You are welcome to try the demo code in Julia.

## Macro
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
The colon operator constructs an expression, which, if evaluated, will produce results.
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
This will produce the same result as `:()`.

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

Another useful function for macro is `esc()`.
This makes sure the expression or symbol you pass in, "escape" the current context, meaning it is not evaluated immediately in the macro definition context, and is only evaluated at calling context.
Take a look at this piece of code:
I used `macroexpand()` to see the result of macro expansion.
```
julia> n = 1

julia> macro esc_example(a)
    quote
        n = 3
        println(n)
        println($(esc(:n)))
    end
end

julia> @esc_example(n)
3
1

julia> macroexpand(:(@esc_example(n)))
quote  # REPL[83], line 3:
    #56#n = 3 # REPL[83], line 4:
    (Main.println)(#56#n) # REPL[83], line 5:
    (Main.println)(n)
end
```
Remember that `esc()` takes an expression or symbol. So use `:` to turn n into an expression, unless it is already and expression.


Lastly, let's take a look at a macro definition used in Julia, the first macro mentioned in the article, `@time`.
```
macro time(ex)
    quote
        local stats = gc_num()
        local elapsedtime = time_ns()
        local val = $(esc(ex))
        elapsedtime = time_ns() - elapsedtime
        local diff = GC_Diff(gc_num(), stats)
        time_print(elapsedtime, diff.allocd, diff.total_time,
                   gc_alloc_count(diff))
        println()
        val
    end
end
```
It should be straight forward to understand after understanding the previous examples.

## Code generation
Since julia is homoiconic, which means the language itself is represented in its data structure.
This feature allows us to manipulate source code before it is compiled.
An important macro for metaprogramming is `@eval`.
`@eval` allow you to evaluate and expression.
And in that expression, you can splice in some value that are outside of the epxression, in this case, we are splicing in the symbols.

Let's try to solve the problem mentioned in the begining - writing a function that can generate code for different data types.
Say I want to write a function that tells me what data type is the argument, Float64, String, or Int64.
I need to define three functions, each with a different argument type.
But they have the same function name and prints out the result.
Rather than copy and pasting the same code and only change the argument type, we can use Julia to generate the functions:
```
julia> for datatype in [:Float64, :String, :Int64]
          @eval function $(Symbol(string("which_datatype")))(data::$datatype)
            println(data, " is a ", $(string(datatype)))
          end
       end
julia> which_datatype(64.33)
64.33 is a Float64

help?> which_datatype
search:

  No documentation found.

  which_datatype is a Function.

  # 3 methods for generic function "which_datatype":
  which_datatype(data::Int64) in Main at REPL[14]:3
  which_datatype(data::String) in Main at REPL[14]:3
  which_datatype(data::Float64) in Main at REPL[14]:3
```
To search for a function, just type `?` in julia REPL and it will change to help mode `help?>`.
The search result shows that we have defined three methods with the name `which_datatype`, each with a different datatype.

It is a very simple form of metaprogramming, but it shows the infinite possibilities.
Next time when you need to write boiler plate functions, don't copy and paste, use metaprogramming.
Because sometimes, lazy is a virtual. :)

If you would like to explore further on metaprogramming in Julia.
Here are some good resources:
Julia's official Metaprogramming documentation: [here](https://docs.julialang.org/en/v0.6.1/manual/metaprogramming/)
Intruducing Julia Metaprogramming: [here](https://en.wikibooks.org/wiki/Introducing_Julia/Metaprogramming)  
To learn more about `@eval` notation: [here](https://docs.julialang.org/en/stable/manual/metaprogramming/#Metaprogramming-1).
