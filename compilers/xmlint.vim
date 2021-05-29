if exists("current_compiler")
  finish
endif

let current_compiler = "xmllint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=xmllint\ --noout\ %

CompilerSet errorformat=%E%f:%l:\ error:\ %m,
		    \%W%f:%l:\ warning:\ %m,
		    \%E%f:%l:\ validity\ error:\ %m,
		    \%W%f:%l:\ validity\ warning:\ %m,
		    \%E%f:%l:\ error\ :\ %m,
		    \%W%f:%l:\ warning\ :\ %m,
		    \%E%f:%l:\ parser\ error\ :\ %m,
		    \%W%f:%l:\ parser\ warning\ :\ %m,
		    \%E%f:%l:\ validity\ error\ :\ %m,
		    \%W%f:%l:\ validity\ warning\ :\ %m,
		    \%-Z%p^,
		    \%-G%.%#
let &cpo = s:cpo_save
unlet s:cpo_save
