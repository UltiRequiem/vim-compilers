compiler rubber

if exists('g:rubber_make_on_save') && g:rubber_make_on_save
    autocmd BufWritePost *.tex :make
endif
