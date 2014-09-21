" vim plugin file
" Filename:     binedit.vim
" Maintainer:   janus_wel <janus.wel.3@gmail.com>
" License:      MIT License {{{1
"   See under URL.  Note that redistribution is permitted with LICENSE.
"   https://github.com/januswel/binedit.vim/blob/master/LICENSE

" preparations {{{1
" check if this plugin is already loaded or not
if exists('loaded_binedit')
    finish
endif
let loaded_binedit = 1

" check the system has the required command
if !executable('xxd')
    finish
endif

" reset the value of 'cpoptions' for portability
let s:save_cpoptions = &cpoptions
set cpoptions&vim

" main {{{1
" functions {{{2
" after reading binary file
function s:BinEditInitialization()
    if &binary
        call s:Convert2XXD()
        setlocal filetype=xxd
        setlocal nofoldenable
    endif
endfunction

" before writing binary file
function s:BinEditWritePre()
    if &binary && &filetype ==# 'xxd'
        call s:Convert2Binary()
    endif
endfunction

" after writing binary file
function s:BinEditWritePost()
    if &binary && &filetype ==# 'xxd'
        call s:Convert2XXD()

        " conversion is treaded as modifying operation
        set nomodified
    endif
endfunction

" convert into readable text
function s:Convert2XXD()
    silent %!xxd -g 1

    " for win32 environment
    silent %substitute/$//ge
endfunction

" convert into binary
function s:Convert2Binary()
    silent %!xxd -r
endfunction

" autocmds {{{2
augroup binedit
    autocmd! binedit

    autocmd BufReadPost  * call s:BinEditInitialization()
    autocmd BufWritePre  * call s:BinEditWritePre()
    autocmd BufWritePost * call s:BinEditWritePost()
augroup END

" post-processings {{{1
" restore the value of 'cpoptions'
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

" }}}1
" vim: ts=4 sw=4 sts=0 et fdm=marker fdc=3
