" Zachery Hostens
" Bootstrap {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Other Dependencies:
"   NVIM: pip3 install neovim
" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'danro/rename.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'irrationalistic/vim-tasks'
Plug 'konfekt/fastfold'
Plug 'majutsushi/tagbar'
Plug 'ntpeters/vim-better-whitespace'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tacahiroy/ctrlp-funky'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if has('nvim')
  function! DeopleteDoRemote(arg)
    UpdateRemotePlugins
  endfunction

  Plug 'shougo/deoplete.nvim', { 'do': function('DeopleteDoRemote') }
  Plug 'zchee/deoplete-go', { 'do': 'make' }
else
  Plug 'shougo/neocomplete.vim'
endif

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

Plug 'fatih/vim-go'

Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'baskerville/bubblegum'
Plug 'fatih/molokai'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'nlknguyen/papercolor-theme'
Plug 'notpratheek/vim-luna'
Plug 'tyrannicaltoucan/vim-deep-space'

call plug#end()
" }}}
" Terminal {{{
set shell=/bin/bash

set t_te= t_ti= t_ut=
set t_Co=256

if !has('nvim')
  set encoding=utf-8
  set ttymouse=xterm
endif

set nocompatible
set number
set wildmenu
set lazyredraw
set ttyfast
set showmatch
set scrolloff=5
set ls=2 " status bar

filetype indent on
filetype plugin on

syntax on
" }}}
" Colors {{{
set background=dark

" use truecolor
if empty($TMUX_SET_STATUSLINE)
  if has('termguicolors')
    set termguicolors
  endif
endif

" let g:airline_theme = 'bubblegum'
" colorscheme bubblegum-256-dark

" let g:airline_theme = 'solarized'
" let g:solarized_bold= 0
" let g:solarized_underline = 0
" colorscheme solarized

" let g:airline_theme = 'deep_space'
" colorscheme deep-space

let g:airline_theme = "hybrid"
colorscheme hybrid_material
" }}}
" Leader {{{
let mapleader = ","

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gvdiff<CR>
" }}}
" Key Bindings {{{
nnoremap <C-H> :bp<CR>
nnoremap <C-L> :bn<CR>

nnoremap <C-R> :CtrlPFunky

if has('osx')
  set clipboard=unnamed
endif
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

if empty($TMUX_SET_STATUSLINE)
  let g:airline#extensions#tmuxline#enabled = 0
else
  let g:airline#extensions#tmuxline#enabled = 1
endif
" }}}
" Autocomplete {{{
if has('nvim')
  let g:deoplete#enable_at_startup = 1
else
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3
endif

inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
" }}}
" NERDCommenter {{{
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
" }}}
" Vim Go {{{
let g:go_highlight_functions = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = 'goimports'
let g:go_fmt_autosave = 1

if has('nvim')
  let g:deoplete#sources#go#cgo = 1
  let g:deoplete#sources#go#cgo#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
endif
" }}}
" File Handling {{{
set modelines=1

set autowrite
set nobackup
set nowritebackup
set noswapfile

au BufWritePre * StripWhitespace
" }}}
" Type Specifics {{{
au filetype go setlocal noexpandtab

au filetype go nmap <leader>b <Plug>(go-build)
au filetype go nmap <leader>r <Plug>(go-run)
" }}}

" vim:foldmethod=marker:foldlevel=0
