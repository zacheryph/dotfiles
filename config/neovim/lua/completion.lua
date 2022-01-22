-- lsp (language server) setup
local lspconf = require("lspconfig")

-- installer registration
require("nvim-lsp-installer").on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)

-- ruby
lspconf.solargraph.setup {
  cmd = { "bundle", "exec", "solargraph", "stdio" }
}

-- lua
lspconf.sumneko_lua.setup {}

-- rust
local rust_opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" }
      }
    }
  }
}

lspconf.rust_analyzer.setup{}
require("rust-tools").setup(rust_opts)

-- nvim-cmp configration
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      max_width = 50,
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buf]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          nvim_lua = "[Lua]",
        })[entry.source.name]
        return vim_item
      end,
    })
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" })
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
  }
})
