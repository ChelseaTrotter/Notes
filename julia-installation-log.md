# Julia Installation Notes
This note logs my trial and errors of compiling Julia from source on Penguin machine. The reason for source build julia is I need to enable CUDA in Julia, which requires source build. Since I do not have root priviledge on Penguin, I use Guix package manager to install necessary tools for building Julia.

* First clone into Julia from github by

```
git clone git://github.com/JuliaLang/julia.git
cd julia
git checkout v0.6.0
```
Then run `make`.

## Errors and Solutions
In this section, I am recording all the errors in the sequence that I encountered. Each item is and error with corresponding solution. Now the solution here is immediate solution to the error, which may not be the best solution to reach my ultimate goal: source build Julia. I will update the best solution, if any, when I  successfully build Julia.

1. The first error I run into is `gcc` version.  Penguin uses `gcc 4.6`, Julia requires at least `gcc 4.7`. I installed `gcc` in Guix by this command
`guix package -i gcc@4.9`
  * The `-i` flag is equivalant to `--install=$package-name`
  * The `@` symbol specifies which version of the software you want to install. If version number is not provided, Guix will install the latest version.

2. Now I have the correct version of `gcc`, I run into linking error, see error message below:
```
/usr/bin/ld: /home/xiaoqihu/.guix-profile/lib/crt1.o(.text+0x26): unresolvable R_X86_64_32 	relocation against symbol `__libc_start_main@@GLIBC_2.2.5'
/usr/bin/ld: BFD (GNU Binutils for Ubuntu) 2.22 internal error, aborting at ../../bfd/reloc.c line 443 in bfd_get_reloc_size
/usr/bin/ld: Please report this bug.
collect2: error: ld returned 1 exit status
```
I installed linker in Guix by `guix package -i ld-wrapper`. Now I can compile a simple hello world program using `gcc`.

3. Now the linker is fixed, the assembler is throwing errors. See error message below:
```
/tmp/cc4Wl4m5.s: Assembler messages:
/tmp/cc4Wl4m5.s:1956: Error: expecting string instruction after `rep'
/tmp/cc4Wl4m5.s:4693: Error: expecting string instruction after `rep'
```
A quick search points me to [this stack overflow page](https://stackoverflow.com/questions/23561136/casablanca-assembly-error-gcc-4-8-1-on-linux-centos). I realized I need to install package `Binutils`. I used this command: `guix package -i binutils`. And that solved the problem.

4. Then I run into this problem:
```
llvm-tblgen: error while loading shared libraries: libz.so.1:
cannot open shared object file: No such file or directory
```
[This post](https://stackoverflow.com/questions/21256866/libz-so-1-cannot-open-shared-object-file) makes me believe that the error is caused by missing zlib. So I try to install it by: `guix package -i zlib`. But I have conflict according to guix output, see below.
```
The following package will be installed:
   	zlib	1.2.11	/gnu/store/9hd38bkw8bq8gq6lcv6vd8xjpcsbyzlm-zlib-1.2.11

	guix package: error: profile contains conflicting entries for zlib
	guix package: error:   first entry: zlib@1.2.11 /gnu/store/9hd38bkw8bq8gq6lcv6vd8xjpcsbyzlm-zlib-1.2.11
	guix package: error:   second entry: zlib@1.2.11 /gnu/store/navpkpm1jf6zf8zmi54wl5w3b2ddv1sw-zlib-1.2.11
	guix package: error:    ... propagated from gnutls@3.5.13
	guix package: error:    ... propagated from guix@0.14.0-1.ad4953b
	hint: Try upgrading both `zlib' and `guix', or remove one of them from the profile.
```
So I did `guix pull` to update guix with newest package.
But I still have the same problem.
It can not find the zlib.
I did search on zlib using `find ~/.guix_packages/lib -name libz*`.
It returned 2 results. one is `/gnu/store/9hd38bkw8bq8gq6lcv6vd8xjpcsbyzlm-zlib-1.2.11`, and the other `/gnu/store/navpkpm1jf6zf8zmi54wl5w3b2ddv1sw-zlib-1.2.11`. I thought if I search my entire home folder by `find ~/ -name libz*`, it would find more results. Interestingly, this `find` returned nothing. I wonder if `find` does not go into hidden folders where `.guix_packages` is.

   Anyway, I did `export LD_LIBRARY_PATH=/usr/local/lib`. In that folder, there is zlib. So it found it successfully.

5. But then, it gives errors: some of your library is available in link time but not available in run time... see detailed error message below:
```
	checking run-time libs availability... failed
	configure: error: one or more libs available at link-time are not available run-time. Libs used at link-time: -lssh2
	make[1]: *** [scratch/curl-7.56.0/build-configured] Error 1
	make: *** [julia-deps] Error 2
```

   I did `export LD_LIBRARY_PATH=/usr/local/lib`, then nothing works in command line anymore (I tried to do `ls` and got error `illegal instruction, core dump`). So I had to roll back and set it as empty. Then I did `export LIBRARY_PATH=/home/xiaoqihu/.guix-profile/lib/` to find zlib.

I am trying to solve the error " one or more libs available at link-time are not available run-time. Libs used at link-time: -lssh2"
