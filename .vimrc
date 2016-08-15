se hlsearch
se nu 
se expandtab
se tabstop=2
se shiftwidth=2
se laststatus=2
se statusline=%F\ %=%c
se shiftwidth=2
color desert

set listchars=eol:$,space:·
:hi SpecialKey ctermfg=7 guifg=gray

nnoremap ,, :call Package() <cr>
function! Package()
    call inputsave()
    let root = input('Which part of the path I must remove? ',expand('%:h'))
    call inputrestore()
    let package = substitute(expand('%:p'), (root.'\(.*\)\.pm'), 'package \1;', 'g')
    call append( 0, [ substitute(package, '/','::','g') ] )
    call append( line('$'), 'use strict;' )
    call append( line('$'), [ 'use warnings;','','','' ] )
    call append(line('$'), '1')
   
    call cursor( line('$') - 2, 0 )

    call feedkeys('i')
endfunction
