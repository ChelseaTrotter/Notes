# Julia Installation Notes
This note logs my trial and errors of compiling Julia from source on Penguin machine. The reason for source build julia is I need to enable CUDA in Julia, which requires source build. Since I do not have root priviledge on Penguin, I use Guix package manager to install necessary tools for building Julia.

First clone into Julia from github by

```
git clone git://github.com/JuliaLang/julia.git
cd julia
git checkout v0.6.0
```
Then run `make`.
The first error I run into is `gcc` version.  Penguin uses `gcc 4.6`, Julia requires at least `gcc 4.7`. I installed `gcc` in Guix by this command
`guix package -i gcc@4.9`

The `-i` flag is equivalant to `--install=$package-name`

The `@` symbol specifies which version of the software you want to install. If version number is not provided, Guix will install the latest version.
