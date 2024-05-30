{ pkgs, ... }: {
  home.packages = with pkgs; [
    # utility
    fd
    go-task
    ripgrep
    shellcheck
    jq
    yq-go

    # rust
    rustup
    cargo-audit
    cargo-bloat
    cargo-edit
    cargo-expand
    # cargo-geiger
    cargo-generate
    cargo-outdated
    cargo-sweep
    cargo-udeps
    # cargo-watch
    # wasm-pack

    # scm
    gh
    gh-dash
    git-lfs
    gitAndTools.git-extras
    gitAndTools.gitflow
    gitAndTools.pre-commit
  ];

  programs.git = {
    enable = true;
    userName = "Zachery Hostens";
    # LOCAL: userEmail = "";
    # LOCAL: signing.key = "";
    signing.signByDefault = true;

    aliases = {
      co = "checkout";
      st = "status";
      ci = "commit -s";
      b = "branch -v -a";
      lb = "branch -v";
      mb = "merge-base";
      cp = "cherry-pick";
      l = "log --graph --decorate";
      ru = "remote update --prune";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
    };

    ignores = [
      "*~"
      "*.swp"
      "._*"
      "*.example"
      "*.sample"

      # Apple Specific
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      ".Spotlight-V100"
      ".Trashes"
    ];

    extraConfig = {
      # git settings
      help.autocorrect = 2;
      init.defaultBranch = "main";
      log.date = "iso";
      merge.conflictstyle = "zdiff3";
      merge.log = true;
      pull.ff = "only";
      push.default = "current";
      rebase.autostash = true;
      rerere.enabled = true;

      core = {
        packedGitLimit = "50m";
        quotePath = false;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };

      color = {
        branch = true;
        diff = true;
        editor = "nvim";
        status = true;
      };

      credentials = {
        # TODO: OS specific
        helper = "osxkeychain";

        "https://git-codecommit.us-east-2.amazonaws.com" = {
          helper = [ "" "!aws codecommit credential-helper $@" ];
          useHttpPath = true;
        };
      };

      diff = {
        algorithm = "histogram";
        renames = "copies";
        sopsdiffer.textconv = "sops -d --config /dev/null";
      };

      url = {
        "https://github.com/" = {
          insteadOf = "hub:";
          pushInsteadOf = "hub:";
        };

        "https://gitlab.com/" = {
          insteadOf = "lab:";
          pushInsteadOf = "lab:";
        };

        "https://git.zro.io/" = {
          insteadOf = "zro:";
          pushInsteadOf = "zro:";
        };
      };

      lfs = {
        repositoryformatversion = 0;
      };

      filter = {
        "lfs" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };

  programs.vim = {
    enable = false;
    plugins = with pkgs.vimPlugins; [
      ctrlp-vim
      delimitMate
      editorconfig-vim
      nord-vim
      rust-vim
      typescript-vim
      vim-abolish
      vim-airline
      vim-better-whitespace
      vim-closetag
      vim-endwise
      vim-fugitive
      vim-go
      vim-javascript
      vim-jsx-pretty
      vim-nix
      vim-rails
      vim-repeat
      vim-ruby
      vim-sensible
      vim-surround
      vim-toml
    ];

    settings = {
      copyindent = true;
      expandtab = true;
      hidden = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      smartcase = true;
      tabstop = 2;
    };

    extraConfig = ''
      " let there be nord
      colorscheme nord
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1

      " general terminal settings
      set nocompatible
      set wildmenu
      set lazyredraw
      set ttyfast
      set showmatch
      set scrolloff=5
      set ls=2 " status bar

      " leader bindings
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

      " key bindings
      nnoremap <C-H> :bp<CR>
      nnoremap <C-L> :bn<CR>

      nnoremap <C-R> :CtrlPFunky<CR>

      " cant get this to work with alacritty
      " if has('osx')
      "   set clipboard=unnamed
      " endif

      " copy/pasta without headaches
      let &t_SI .= "\<Esc>[?2004h"
      let &t_EI .= "\<Esc>[?2004l"

      inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

      function! XTermPasteBegin()
        set pastetoggle=<Esc>[201~
        set paste
        return ""
      endfunction

      " spacing
      set softtabstop=2
      set shiftwidth=2
      set smartindent
      set shiftround
      set nowrap

      " searching
      set hlsearch
      set ignorecase

      set updatetime=2000

      set gdefault

      nnoremap <leader><space> :nohlsearch<CR>

      cnoreabbrev ag Ack
      let g:ackprg = 'ag --vimgrep'

      " folding
      set foldenable
      set foldlevelstart=10
      set foldnestmax=10
      set foldmethod=syntax

      nnoremap <space> za

      " ctrl-p searching
      let g:ctrlp_open_multiple_files = '1jr'

      let g:ctrlp_line_prefix = '> '
      let g:ctrlp_user_command = {
        \ 'types': {
        \   1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
        \ },
        \ 'fallback': 'ag %s -l --nocolor --hidden --ignore .git --ignore tmp -g ""',
        \ }

      let g:ctrlp_abbrev = {
        \ 'gmode': 'i',
        \ 'abbrevs': [
        \   {
        \     'pattern': ' ',
        \     'expanded': '''''',
        \     'mode': 'pfrz',
        \   },
        \ ]
        \ }

      let g:ctrlp_funky_go_types = 1
      let g:ctrlp_funky_syntax_highlight = 1
      let g:ctrlp_funky_nolim = 1

      " autocomplete
      let g:neocomplete#enable_at_startup = 1
      let g:neocomplete#enable_smart_case = 1
      let g:neocomplete#sources#syntax#min_keyword_length = 3
      inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
      let g:omni_sql_no_default_maps = 1

      " language client
      let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ }

      nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
      nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
      nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

      " file handling
      set modelines=1

      set autowrite
      set nobackup
      set nowritebackup
      set noswapfile

      au BufWritePre * StripWhitespace

      " file types
      au filetype rust nmap <leader>b <Plug>(CargoBuild)
      au filetype rust nmap <leader>d <Plug>(CargoDoc)
      au filetype rust nmap <leader>r <Plug>(CargoRun)
      au filetype rust nmap <leader>t <Plug>(CargoTest)

      let g:jsx_ext_required = 0

      augroup filetypedetect
        au BufRead,BufNewFile PKGBUILD set ft=sh
      augroup END

      let g:rustfmt_autosave = 1

      let g:closetag_filenames = "*.erb,*.js,*.jsx,*.vue"
      let g:closetag_xhtml_filenames = "*.erb,*.js,*.jsx,*.vue"
      let g:closetag_emptyTags_caseSensitive = 1

      au filetype xml,js,vue let b:delimitMate_matchpairs = "(:),[:],{:}"
    '';
  };
}
