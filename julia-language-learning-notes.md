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

Lastly, let's take a look at a real macro definition, the first macro mentioned in the article, `@time`.
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
The syntax is straight forward.
But notice there is a new expression: $(esc(ex)).
This makes sure the code you pass in, "escape" the current context, meaning it is not evaluated immediately in the macro definition context, and is only evaluated at calling context.
When to use $(esc())?
When you



At the end of each line in the expansion, it shows which source file the macro is in and on which line.
The local variables are assigned a number in the name to make sure it does not accidentally collide with the expression that you are passing in.
In `@time` macro, it first takes the memory allocation status, then the begining time.
Then evaluates 2^30, and

#### When should you write a macro rather than function?



## Code generation
You don't need to use macro to do metaprogramming.
Since julia is homoiconic, which means the language itself is represented in its data structure.
This feature allows us to manipulate source code before it is compiled.
An important macro for metaprogramming is `@eval`.
`@eval` allow you to evaluate and expression.
In that expression, you can splice in some value that are outside of the epxression, in this case, we are splicing in the symbols.
The good things is that no matter how many functions you have, the complexity is the same.

Let's try to solve the problem mentioned in the begining - writing a function that can generate code for different data types. Say I want to write a function that tells me what data type is the argument, Float64, String, or Int64.
I need to define three functions, each with a different argument type, but have the same function name and prints out the result.
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
Next time when you need to write boiler plate functions, don't copy and paste, use metaprogramming!








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


## confusion about Julia macro.
I am trying to understand how does the $(esc(ex)) work in macro definitions.
I read the following source to learn about this matter.
[Source1](https://en.wikibooks.org/wiki/Introducing_Julia/Metaprogramming),
[Source2](https://docs.julialang.org/en/v0.6.1/manual/metaprogramming/).

My understanding is that in order to keep macro hygien, we need to use `esc` to keep global space variables seperate from local variables.
For example, we have an n defined in Main, and argument of Macro, and locally defined inside macro.
```
macro esc_example(n, a)
  quote
      n = 3
      println(n, " I am n in the macro local space.")
      println($n, " I am dollar n from Main.")
      println($(esc(n)), " I am escape n in macro argument.")
      println()

      println(a, " I am a in the macro argument.")
      println($a, " I am dollar a in the macro argument.")
      println($(esc(a)), " I am escape a in Main.")
  end
end
```

In this example, n should refer to the locally defined n, $n should be the string interpolation of n, which is bassically, replace n with it's value. Lastly the $(esc(ex)) should refer to the variable in Main.

Here is what I got from macroexpand():
```
macroexpand(:(@esc_example(n,n)))
quote  # REPL[15], line 3:
    #8#n = 3 # REPL[15], line 4:
    (Main.println)(#8#n, " I am n in the macro local space.") # REPL[15], line 5:
    (Main.println)(#8#n, " I am dollar n from Main.") # REPL[15], line 6:
    (Main.println)(n, " I am escape n in macro argument.") # REPL[15], line 7:
    (Main.println)() # REPL[15], line 9:
    #9#a = 4 # REPL[15], line 10:
    (Main.println)(#9#a, " I am a in the macro argument.") # REPL[15], line 11:
    (Main.println)(#8#n, " I am dollar a in the macro argument.") # REPL[15], line 12:
    (Main.println)(n, " I am escape a in Main.")
end
```
I am trying to distingish the use of n, $n, and $(esc(n)). 
Clearly, n refers to the local n, which name was transformed to #8#n.
$n should be the string intepolation of n, which was 3 in local space, or 1 in Main space. But instead, REPL thinks it is the local n.
Third, using escape leaves n just before the evaluation.
So, $(esc(ex)) refer to a global variable.
For example:

julia> n = 1
1

macro esc_example(n, a)
    quote
        n = 3
        println(n, " I am n in the macro local space.")
        println($n, " I am dollar n from Main.")
        println($(esc(n)), " I am escape n in macro argument.")
        println()

        a = 4
        println(a, " I am a in the macro argument.")
        println($a, " I am dollar a in the macro argument.")
        println($(esc(a)), " I am escape a in Main.")
    end
end

julia> @esc_example(n,a)
3 I am n in the macro local space.
3 I am n dollar sign n.
1 I am n in Main.

1 I am a in the macro argument.
1 I am dollar a in the macro argument.
1 I am escape a in Main.

n in Main space is 1, in macro is 3, I am also passing in an integer just to compare.
