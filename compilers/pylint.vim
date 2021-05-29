if exists('current_compiler')
  finish
endif

let current_compiler = 'pylint'

if !exists('g:pylint_onwrite')
    let g:pylint_onwrite = 1
endif

if !exists('g:pylint_show_rate')
    let g:pylint_show_rate = 1
endif

if !exists('g:pylint_cwindow')
    let g:pylint_cwindow = 1
endif

if exists(':Pylint') != 2
    command Pylint :call Pylint(0)
endif

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=(echo\ '[%]';\ pylint\ -r\ y\ %)

CompilerSet efm=%+P[%f],%t:\ %#%l:%m,%Z,%+IYour\ code%m,%Z,%-G%.%#

if g:pylint_onwrite
    augroup python
        au!
        au BufWritePost * call Pylint(1)
    augroup end
endif

function! Pylint(writing)
    if !a:writing && &modified
        write
    endif	

    if has('win32') || has('win16') || has('win95') || has('win64')
        setlocal sp=>%s
    else
        setlocal sp=>%s\ 2>&1
    endif

    if !a:writing
        silent make
    else
        silent make!
    endif

    if g:pylint_cwindow
        cwindow
    endif

    call PylintEvaluation()

    if g:pylint_show_rate
        echon 'code rate: ' b:pylint_rate ', prev: ' b:pylint_prev_rate
    endif
endfunction

function! PylintEvaluation()
    let l:list = getqflist()
    let b:pylint_rate = '0.00'
    let b:pylint_prev_rate = '0.00'
    for l:item in l:list
        if l:item.type == 'I' && l:item.text =~ 'Your code has been rated'
            let l:re_rate = '\(-\?[0-9]\{1,2\}\.[0-9]\{2\}\)/'
            let b:pylint_rate = substitute(l:item.text, '.*rated at '.l:re_rate.'.*', '\1', 'g')
            " Only if there is information about previous run
            if l:item.text =~ 'previous run: '
                let b:pylint_prev_rate = substitute(l:item.text, '.*previous run: '.l:re_rate.'.*', '\1', 'g')
            endif    
        endif
    endfor
endfunction
