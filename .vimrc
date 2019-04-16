set nu
set spell spelllang =ru_ru,en
set linebreak
set keywordprg      =perldoc\ -f
set shiftwidth      =4
set tabstop         =4
set expandtab
set smartindent
set nowrap

set cursorline

" nnoremap ,, :call NewPerlPackage() <cr>
" set cwd for current window to dir where file located
nmap <F5> :execute "lcd " . expand("%:p:h") <CR>

" save current date and time to register x
nmap <F4> :call setreg('d', strftime('%F %T')) <CR>

" pass visually selected snippet through perltidy on ctrl+r
vmap <C-R> !perltidy <CR>

" :help autocmd-groups
aug vimrc | au!

autocmd BufNewFile *.pl :call NewPerlScript()
autocmd BufNewFile *.pm :call NewPerlPackage()

autocmd BufReadPost  *.p[ml],*.js,*.json,*.c,*.vimrc,*.conf,*.psgi,*.tt,*.t :call NoSpell()
autocmd BufWinEnter  * :setl statusline =%!CustomStatusline()
augroup END

" kill trailing spaces
autocmd vimrc BufWritePre *.pl,*.pm,*.js,*.c,*.vimrc :call KillSpaces()

function! NoSpell()
  :set nospell
endfunction

function! KillSpaces()

  let undoTree = undotree()

  " fix for E790,
  " prevent call of undojoin after undo operation
  if undoTree["seq_last"] == undoTree["seq_cur"]
    undojoin
  endif

  let pos = getpos('.')

  :silent
  :%s/\s*$//g

  call setpos('.', pos )

endfunction

" check perl source syntax
nmap <C-c> :call SynCheckStatus() <cr>

function! CheckPerlSyntax()
  let filePath       = shellescape( expand('%:p') )
  let b:synChkResult = system('perl -cw ' . filePath )
  let b:synChkStatus = v:shell_error
endfunction

function! SynCheckStatus()
  if exists("b:synChkResult")
    echo b:synChkResult
  endif
endfunction

function! NewPerlPackage()
    if !exists("g:root")
        call inputsave()
    let root = expand('%:p')
    let root = substitute(root, (expand('%:t').'$'), '', 'g')

        let root = input('Which part of the path I must remove? ', root )
        call inputrestore()
    else
        let root = g:root
    end
    let package = substitute(expand('%:p'), (root.'/\?\(.*\)\.pm'), 'package \1;', 'g')
    call append( 0, [ substitute(package, '/','::','g') ] )
    call append( line('$'), 'use strict;' )
    call append( line('$'), [ 'use warnings;','','','' ] )
    call append(line('$'), '1')

    call cursor( line('$') - 2, 0 )

    call feedkeys('i')
endfunction

function! NewPerlScript()

    call setline( line('$'), '#!/usr/bin/env perl' )
    call append( line('$'), ['', 'use strict;'] )
    call append( line('$'), [ 'use warnings;','','' ] )

    call cursor( line('$'), 0 )

    call feedkeys('i')
endfunction

" customise colorscheme
autocmd ColorScheme * :hi CursorLineNR ctermfg=White cterm=bold | :hi CursorLine cterm=NONE

colorscheme murphy

" transparent verical line on column 100
" should warn against too logn lines
set colorcolumn =100
hi  ColorColumn ctermbg=14 ctermfg=4

set noruler
set laststatus=2

function! CustomStatusline()


  let l:statusline = "%F %=col: %-3.v line: %l/%L/%P"
  return statusline
endfunction

function! Rindent()
" we have text:
"
"          foo
"barbaz
" thud
"
" select it visually and call function:
"          foo
"       barbaz
"         thud

  let pattern_pos =  matchstrpos(getline("'<"), "\\w\\>")
  let indent_size = pattern_pos[1] +1
  '<,'>s/^\s*//g

  let i = line("'<")

  while i <= line("'>")

    let line = getline(i)
    let pattern_pos =  matchstrpos(line, "\\S\\+")

    if pattern_pos[2] > 0
      let t = indent_size - pattern_pos[2]
      call setline(i, printf("%". t ."S%S", "", line))
    endif

    let i+= 1

  endwhile

endfunction

" hide garbage files in netrw
let g:netrw_list_hide = '.*\.swp$,\~$,\.orig$'
" tree style listing
let g:netrw_liststyle =3
let g:netrw_banner    =0

" for project related vimrc's
set exrc
set secure

setlocal cm   =blowfish2

set backupdir =~/.vim/backup
set undodir   =~/.vim/backup
set dir       =~/.vim/backup
execute pathogen#infect()
