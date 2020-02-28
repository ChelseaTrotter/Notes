#!/bin/bash

pandoc -t revealjs -s -o presentation.html $1 -V revealjs-url=https://revealjs.com

