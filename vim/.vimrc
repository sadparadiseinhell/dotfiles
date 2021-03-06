set nocompatible

call plug#begin('~/.vim/plugged')
	
	Plug 'chrisbra/Colorizer'
	Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'jiangmiao/auto-pairs'
	
	" Colorschemes
	Plug 'morhetz/gruvbox'

call plug#end()

syntax enable
filetype on
set t_Co=256
set hidden
set showcmd
set mousehide

set encoding=utf-8
set nolazyredraw
set smartcase
set ignorecase

set number
set ruler
set mouse=a
set wrap
set hlsearch
set incsearch

set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab

set nobackup
set noswapfile
set nowritebackup

" Colorscheme
"colorscheme gruvbox
"let g:gruvbox_contrast_dark = 'hard'
"set background=dark
"highlight Normal ctermfg=white ctermbg=black

" Colorizer
:let g:colorizer_auto_color = 1
:let g:colorizer_colornames = 1
:let g:colorizer_auto_filetype='css,html'

" mappings
map <C-n> :NERDTreeToggle<CR>
map <C-c> :ColorToggle<CR>
