set nocompatible
syntax on
filetype plugin indent on

set backspace=indent,eol,start
set number " Show line numbers

" Folding *********************************************************************

set foldenable
set foldmethod=syntax
set foldlevelstart=99

" Tabs ************************************************************************
" Use 2 spaces
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

" Searching *******************************************************************
set incsearch  " incremental search, search as you type

" Status Line *****************************************************************
set showcmd
set ruler " Show ruler

" Directories *****************************************************************
" Setup backup location and enable
set backupdir=~/.vim/backup
set backup
 
" Set Swap directory
set directory=~/.vim/backup/swap

"custom commands

command W w

"Brian likes to escape with fd
"But Brian realized that ssh keys and api keys and pod rids and all sorts of
"randomly generated stuff occasionally has 'fd' in it, so he's just gonna act
"like this never happened...(shhhhhhh)
":imap fd <Esc>
