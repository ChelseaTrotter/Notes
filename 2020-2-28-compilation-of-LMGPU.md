---
author: Chelsea Trotter
title: Compilation of LMGPU
date: Feb 28, 2020
---

# Background
- Performing LM Genome Scan for BXD populations.
- Speed up techniques.
  - reformulate to matrix multiplication.
  - Multithreaded libraries and operations.
  - Use element wise operations
  - Floating point precisions
  - Reduce output size using Maximum.

# Limitations and Next Steps
- Limitations:
  - Works one df genome scans
  - No missing data in phenotypes.
  - Data IO could be and issue
- Next steps:
  - Permutaions for LMM
  - eQTL scans with LMM

# Why?
- Julia compilation is long.
  - First Julia call includes compilation and execution time.
  - JIT compiler of Julia
  <!-- - People come to julia for the speed, but quickly discover that first plot takes close to a minute to compile. That's because the first Julia call is doing both compilation and running the command. The second call will just be a fraction of second. -->
  <!-- - However, if provide a command line interface without precompiled binary, which starts up a fresh julia, run the command, and exit julia. Every call will be an empty canvas, with no compilation results cached, julia will compile the source code every time. This is very time consuming and not efficient for a server envirnment. -->
- Command line interface is more secure for a server environment.

# Challenges
- Compiling Julia's source code rely on a package called PackageCompiler, which was under active development.
  - The compilation is not ship with Julia.
  - PackageCompiler is under development
  <!-- - In theory it should be easy to compile because it uses LLVM, the same compiler infrastructure of C++. But such functionality is not shipped with the language, so julia designer developed a package called PackageCompiler fill in the void. -->
  <!-- - This package is under active development during my progress of compiling to binary. Therefore it broke often. Luckily julia developer released a working version. However, there were major changes to how to use this package. -->
  - Relocatability.
    - Reqires code itself is relocatable, meaning there is not abusolute path and required library is in expected place.

# How to compile

# structure:
```shell
shell> tree
.
├── build-bin.jl
├── MyApp
│   ├── Manifest.toml
│   ├── precompile_app.jl
│   ├── Project.toml
│   └── src
│       └── MyApp.jl
```

# How to generate Project.toml and Manifest.toml
```julia
# This will generate a package with Project.toml (with name, uuid, author and version information) and all related package dev structure.
Pkg.generate("MyApp")
# activate the project environment at MyApp directory.
Pkg.activate("MyApp")
# This will add DelimitedFiles to Project.toml, and add it's dependencies to Manifest.toml
Pkg.add("DelimitedFiles")
# Add more dep packages.
```

# Inside MyApp.jl
```julia
module MyApp

using LMGPU
using DelimitedFiles

function julia_main()
    main()
    return 0
end

function main()
  # your main functions.
end

end #module
```


# Other options.
- Precompilation
  - Having the required packages baked in with Julia image.
  - Precompile julia functions.
  - Drawback: if the precompiled julia function is not used because of multiple dispatch, precompilation gets invalidated and julia need to compile the functions again, which takes longer.
