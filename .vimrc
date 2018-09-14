
" /usr/share/vim/vimfiles/archlinux.vim for defaults
runtime! archlinux.vim


"Keybinds
"=============================

"meta-key = space
let mapleader=" "

"refresh config = meta + s
map <leader>s :source ~/dotfiles/vim/vimrc<CR>

"=============================


"syntax highlighting (needs theme)
filetype on
syntax on
set number
filetype indent on
set nowrap
set smartindent
set autoindent
set clipboard=unnamedplus

