{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Color scheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
        transparent_background = false;
      };
    };

    # General options
    opts = {
      number = true;
      relativenumber = true;

      # Tabs and indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;

      # Search settings
      ignorecase = true;
      smartcase = true;
      hlsearch = true;

      # Appearance
      termguicolors = true;
      signcolumn = "yes";
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;

      # Behavior
      mouse = "a";
      clipboard = "unnamedplus";
      splitright = true;
      splitbelow = true;
      undofile = true;
      swapfile = false;
      backup = false;
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Key mappings
    keymaps = [
      # Better window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }

      # Resize windows
      { mode = "n"; key = "<C-Up>"; action = ":resize -2<CR>"; options.desc = "Resize window up"; }
      { mode = "n"; key = "<C-Down>"; action = ":resize +2<CR>"; options.desc = "Resize window down"; }
      { mode = "n"; key = "<C-Left>"; action = ":vertical resize -2<CR>"; options.desc = "Resize window left"; }
      { mode = "n"; key = "<C-Right>"; action = ":vertical resize +2<CR>"; options.desc = "Resize window right"; }

      # Buffer navigation
      { mode = "n"; key = "<S-h>"; action = ":bprevious<CR>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<S-l>"; action = ":bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<leader>bd"; action = ":bdelete<CR>"; options.desc = "Delete buffer"; }

      # Better indenting
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }

      # Move text up and down
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }

      # Clear search highlighting
      { mode = "n"; key = "<leader>h"; action = ":nohlsearch<CR>"; options.desc = "Clear search highlight"; }

      # Telescope
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Live grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Find buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "Help tags"; }
      { mode = "n"; key = "<leader>fo"; action = "<cmd>Telescope oldfiles<cr>"; options.desc = "Recent files"; }

      # Neo-tree
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; options.desc = "Toggle file explorer"; }

      # LSP
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<cr>"; options.desc = "Go to definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<cr>"; options.desc = "Go to references"; }
      { mode = "n"; key = "gI"; action = "<cmd>lua vim.lsp.buf.implementation()<cr>"; options.desc = "Go to implementation"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; options.desc = "Hover documentation"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>"; options.desc = "Code action"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; options.desc = "Rename"; }

      # Trouble
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<cr>"; options.desc = "Toggle diagnostics"; }
      { mode = "n"; key = "<leader>xd"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"; options.desc = "Buffer diagnostics"; }

      # Git
      { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGit<cr>"; options.desc = "LazyGit"; }
    ];

    plugins = {
      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
        };
      };

      # Snippets
      luasnip.enable = true;

      # Telescope - fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };

      # Neo-tree - file explorer
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            auto_expand_width = false;
          };
        };
      };

      # Lualine - statusline
      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            theme = "catppuccin";
            component_separators = "|";
            section_separators = { left = ""; right = ""; };
          };
        };
      };

      # Bufferline - buffer tabs
      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          separator_style = "slant";
          offsets = [
            {
              filetype = "neo-tree";
              text = "File Explorer";
              highlight = "Directory";
              text_align = "left";
            }
          ];
        };
      };

      # Which-key - show keybindings
      which-key = {
        enable = true;
        settings.spec = [
          { __unkeyed-1 = "<leader>f"; group = "Find"; }
          { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
          { __unkeyed-1 = "<leader>c"; group = "Code"; }
          { __unkeyed-1 = "<leader>g"; group = "Git"; }
          { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; }
        ];
      };

      # Git signs - show git changes in gutter
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };

      # Indent blankline - show indent guides
      indent-blankline = {
        enable = true;
        settings.scope.enabled = true;
      };

      # Auto-pairs
      nvim-autopairs.enable = true;

      # Comment
      comment.enable = true;

      # Trouble - diagnostics list
      trouble.enable = true;

      # Dashboard
      alpha = {
        enable = true;
        settings.layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = [
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "  Find file";
                on_press = { __raw = "function() vim.cmd[[Telescope find_files]] end"; };
                opts = {
                  keymap = [ "n" "ff" ":Telescope find_files <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "ff";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Recent files";
                on_press = { __raw = "function() vim.cmd[[Telescope oldfiles]] end"; };
                opts = {
                  keymap = [ "n" "fo" ":Telescope oldfiles <CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "fo";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = "  Quit";
                on_press = { __raw = "function() vim.cmd[[qa]] end"; };
                opts = {
                  keymap = [ "n" "q" ":qa<CR>" { noremap = true; silent = true; nowait = true; } ];
                  shortcut = "q";
                  position = "center";
                  cursor = 3;
                  width = 38;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
            ];
          }
        ];
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
        };
      };

      # Lazygit integration
      lazygit.enable = true;

      # Todo comments
      todo-comments.enable = true;

      # Webdev icons
      web-devicons.enable = true;
    };

    # Extra packages needed
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nixd

      # Formatters
      stylua
      nixfmt-rfc-style
      nodePackages.prettier

      # Tools
      ripgrep
      fd
      lazygit
    ];
  };
}
