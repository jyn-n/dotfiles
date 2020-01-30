filetype on

autocmd BufNewFile,BufRead *.inc set filetype=cpp
autocmd BufNewFile,BufRead *.zsh-theme set filetype=sh


autocmd FileType python retab! 4|set tabstop=2
autocmd BufWritePre *.py set expandtab|set tabstop=4|retab!|set tabstop=2|set noexpandtab
autocmd BufWritePost *.py retab! 4|set tabstop=2


autocmd FileType yaml retab! 2|set tabstop=2
autocmd BufWritePre *.yaml set expandtab|set tabstop=2|retab!|set tabstop=2|set noexpandtab
autocmd BufWritePost *.yaml retab! 2|set tabstop=2


function ToggleNetrw()
	if !exists('t:netrw_on')
		let t:netrw_on = 0
	endif
	if t:netrw_on
		let t:netrw_on = 0
		q
	else
		let t:netrw_on = 1
		Vexplore
	endif
endfunction

nnoremap <silent> <C-N> :call ToggleNetrw()<Return>
nnoremap <silent> \ J

autocmd FileType netrw nmap <silent> h <CR>
autocmd FileType netrw nmap <silent> l <CR>

let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 3
let g:netrw_winsize = 25
let g:netrw_liststyle = 3

packadd minpac

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('dermusikman/sonicpi.vim')

packloadall
