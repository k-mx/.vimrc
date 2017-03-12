set nu
set spell spelllang =ru_ru,en
set linebreak
set keywordprg      =perldoc\ -f
set shiftwidth      =2
set tabstop         =2
set expandtab
set smartindent

set cursorline

" nnoremap ,, :call NewPerlPackage() <cr>

" :help autocmd-groups
aug vimrc | au!

autocmd BufNewFile *.pl :call NewPerlScript()
autocmd BufNewFile *.pm :call NewPerlPackage()

autocmd BufReadPost  *.p[ml] :call CheckPerlSyntax()
autocmd BufWritePost *.p[ml] :call CheckPerlSyntax()

augroup END

" kill trailing spaces
autocmd vimrc BufWritePre *.pl,*.pm,*.js,*.c,*.vimrc :call KillSpaces()

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

colorscheme desert

set noruler
set laststatus=2

function! CustomStatusline()


  let l:statusline = "%F %=col: %-3.v line: %l/%L/%P"
  if exists("b:synChkStatus")

    if b:synChkStatus != 0
      let l:statusline.= " %#Error#SYTAX ERROR!"
    endif
  endif

  return statusline
endfunction

setl statusline =%!CustomStatusline()

" hide garbage files in netrw
let g:netrw_list_hide= '.*\.swp$,\~$,\.orig$'

" for project related vimrc's
set exrc
set secure
