se nu
se spell spelllang = ru_ru,en 
se linebreak
set keywordprg     = perldoc\ -f
set shiftwidth     = 2
set tabstop        = 2
set expandtab

colorscheme desert

nnoremap ,, :call Package() <cr> 
function! Package()
	if !exists("g:root")
		call inputsave()
		let root = input('Which part of the path I must remove? ',expand('%:h'))
		call inputrestore()
	else
		let root = g:root
	end
	let package = substitute(expand('%:p'), (root.'\(.*\)\.pm'), 'package \1;', 'g')
	call append( 0, [ substitute(package, '/','::','g') ] )
	call append( line('$'), 'use strict;' )
	call append( line('$'), [ 'use warnings;','','','' ] )
	call append(line('$'), '1')
	
	call cursor( line('$') - 3, 0 )

	call feedkeys('i')
endfunction

