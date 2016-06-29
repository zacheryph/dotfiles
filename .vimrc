" Zachery Hostens
" Bootstrap {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'danro/rename.vim'
Plug 'konfekt/fastfold'
Plug 'ntpeters/vim-better-whitespace'
Plug 'raimondi/delimitmate'
Plug 'shougo/neocomplete.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

Plug 'fatih/vim-go'

" colorschemes
Plug 'baskerville/bubblegum'
Plug 'chriskempson/base16-vim'
Plug 'fatih/molokai'
Plug 'gummesson/stereokai.vim'
Plug 'hhsnopek/vim-firewatch'
Plug 'joshdick/onedark.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'nlknguyen/papercolor-theme'
Plug 'notpratheek/vim-luna'

call plug#end()
" }}}
" Terminal {{{
set t_ti= t_te=
set t_Co=256

set nocompatible
set encoding=utf8
set number
set wildmenu
set lazyredraw
set ttyfast
set ttymouse=xterm
set showmatch
set scrolloff=5
set ls=2 " status bar

filetype indent on
filetype plugin on

syntax on
" }}}
" Colors {{{
set background=dark
let g:airline_theme = 'bubblegum'
colorscheme bubblegum-256-dark
" }}}
" Leader {{{
let mapleader = ","
" }}}
" Key Bindings {{{
nnoremap <C-H> :bp<CR>
nnoremap <C-L> :bn<CR>
" }}}
" Spaces and Tabs {{{
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set copyindent
set shiftround
set hidden
set nowrap

set backspace=indent,eol,start
" }}}
" Searching {{{
set incsearch
set hlsearch
set smartcase
set ignorecase

set updatetime=2000

set gdefault

nnoremap <leader><space> :nohlsearch<CR>
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

nnoremap <space> za
" }}}
" CtrlP {{{
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

let g:ctrlp_abbrev = {
  \ 'gmode': 'i',
  \ 'abbrevs': [
  \   {
  \     'pattern': ' ',
  \     'expanded': '',
  \     'mode': 'pfrz',
  \   },
  \ ]
  \ }
" }}}
" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" }}}
" Neocomplete {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" }}}
" File Handling {{{
set modelines=1

set nobackup
set nowritebackup
set noswapfile

au BufWritePre * StripWhitespace
" }}}
" Type Specifics {{{
au filetype go setlocal noexpandtab
" }}}

" vim:foldmethod=marker:foldlevel=0
