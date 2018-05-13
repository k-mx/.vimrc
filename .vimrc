set nu
set spell spelllang =ru_ru,en
set linebreak
set keywordprg      =perldoc\ -f
set shiftwidth      =2
set tabstop         =2
set expandtab
set smartindent
set nowrap

set cursorline

" nnoremap ,, :call NewPerlPackage() <cr>
" set cwd for current window to dir where file located
nmap <F5> :execute "lcd " . expand("%:p:h") <CR>

" :help autocmd-groups
aug vimrc | au!

autocmd BufNewFile *.pl :call NewPerlScript()
autocmd BufNewFile *.pm :call NewPerlPackage()

autocmd BufReadPost  *.p[ml],*.js,*.json,*.c,*.vimrc,*.conf :call NoSpell()
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

set noruler
set laststatus=2

function! CustomStatusline()


  let l:statusline = "%F %=col: %-3.v line: %l/%L/%P"
  return statusline
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
