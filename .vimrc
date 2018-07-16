:filetype on
:autocmd BufNewFile,BufRead *.inc set filetype=cpp

:autocmd FileType python retab! 4|set tabstop=2
:autocmd BufWritePre *.py set expandtab|set tabstop=4|retab!|set tabstop=2|set noexpandtab
:autocmd BufWritePost *.py retab! 4|set tabstop=2

