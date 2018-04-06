" Zachery Hostens
" Bootstrap {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" NVIM Specific Dependencies:
"   pip3 install neovim
"   gem install neovim
" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')

" functionality
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'danro/rename.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'irrationalistic/vim-tasks'
Plug 'junegunn/vim-easy-align'
Plug 'konfekt/fastfold'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
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

" syntax
Plug 'fatih/vim-go'
Plug 'fatih/vim-hclfmt'
Plug 'hashivim/vim-terraform'
Plug 'mxw/vim-jsx'
Plug 'rhysd/vim-crystal'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'

" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'baskerville/bubblegum'
Plug 'fatih/molokai'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'notpratheek/vim-luna'
Plug 'tyrannicaltoucan/vim-deep-space'

call plug#end()
" }}}
" Terminal {{{
set shell=/bin/bash

if !has('nvim')
  set encoding=utf-8
  set ttymouse=xterm
endif

set nocompatible
set number
set rnu
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

function! SetTheme(name, airline, ...)
  if a:0 > 0
    if has('termguicolors')
      set termguicolors

      " see :help xterm-true-color
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
  endif

  exec 'colorscheme '.a:name
  let g:airline_theme = a:airline
endfunction

" call SetTheme('bubblegum-256-dark', 'bubblegum', 1)
" call SetTheme('deep-space', 'deep_space', 1)
" call SetTheme('gruvbox', 'gruvbox')
" call SetTheme('hybrid_material', 'hybrid', 1)
" call SetTheme('luna', 'luna', 1)
call SetTheme('OceanicNext', 'oceanicnext', 1)

" let g:solarized_bold= 0
" let g:solarized_underline = 0
" call SetTheme('solarized', 'solarized')

" }}}
" Leader {{{
let mapleader = ","

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gvdiff<CR>

" macro faster
nnoremap <leader>m qt0
vnoremap <leader>m :'<,'> norm @t<CR>

nnoremap <leader>t :e ~/src/TASKS.todo<CR>

" align markdown tables
au filetype markdown vmap <leader><bslash> :EasyAlign*<bar><Enter>

" Faster ag
nnoremap <leader>f <C-r><C-w><CR>
" }}}
" Key Bindings {{{
nnoremap <C-H> :bp<CR>
nnoremap <C-L> :bn<CR>

nnoremap <C-R> :CtrlPFunky<CR>

if has('osx')
  set clipboard=unnamed
endif

if has('nvim')
  " ensure mouse does nothing
  set mouse=
  set clipboard=unnamedplus
endif

" never do this again --> :set paste <ctrl-v> :set no paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
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

cnoreabbrev ag Ack
let g:ackprg = 'ag --vimgrep'
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

nnoremap <space> za
" }}}
" CtrlP {{{
let g:ctrlp_open_multiple_files = '1jr'

let g:ctrlp_line_prefix = '> '
let g:ctrlp_user_command = {
  \ 'types': {
  \   1: ['.git', 'cd %s && git ls-files'],
  \ },
  \ 'fallback': 'ag %s -l --nocolor --hidden -g ""',
  \ }

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

let g:ctrlp_funky_go_types = 1
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_funky_nolim = 1
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
let g:go_highlight_methods = 1
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
" }}}
" Type Specifics {{{
au filetype go setlocal noexpandtab

au filetype go nmap <leader>i <Plug>(go-import)
au filetype go nmap <leader>b <Plug>(go-build)
au filetype go nmap <leader>r <Plug>(go-run)

let g:jsx_ext_required = 0

augroup filetypedetect
  au BufRead,BufNewFile *.arb set ft=ruby
augroup END
" }}}

" vim:foldmethod=marker:foldlevel=0
