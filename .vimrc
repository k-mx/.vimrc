set nu
set spell spelllang =ru_ru,en 
set linebreak
set keywordprg      =perldoc\ -f
set shiftwidth      =2
set tabstop         =2
set expandtab

set cursorline

"nnoremap ,, :call NewPerlPackage() <cr> 

autocmd BufNewFile *.pl :call NewPerlScript()
autocmd BufNewFile *.pm :call NewPerlPackage()

"kill empty lines with spaces and spaces at the end of line
autocmd BufWritePre *.pl,*.pm,*.js,*.c :silent :%s/\s\+$//g

"check perl source syntax
nmap <C-c> :!clear; perl -cw % <cr>

function NewPerlPackage()
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

function NewPerlScript()

	call setline( line('$'), '#!/usr/bin/env perl' )
	call append( line('$'), ['', 'use strict;'] )
	call append( line('$'), [ 'use warnings;','','' ] )

	call cursor( line('$'), 0 )

	call feedkeys('i')
endfunction

"customise colorscheme
autocmd ColorScheme * :hi CursorLineNR ctermfg=White cterm=bold | :hi CursorLine cterm=NONE

colorscheme desert

set noruler
set laststatus=2

function CustomStatusline()

  return "%F\ %=col:\ %-3.v"
endfunction

set statusline=%!CustomStatusline()
