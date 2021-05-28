" Vim compiler file
" Compiler: pdf creator out of LaTeX files using rubber
if exists("current_compiler")
    finish
endif

let current_compiler = "rubber"
CompilerSet makeprg=rubber\ -d\ %
"CompilerSet efm=%f:%l:\ [%t]%m,%f:%l:%m
