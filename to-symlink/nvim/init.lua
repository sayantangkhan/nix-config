-- Managed by nix (see neovim.nix). Plugins are installed by nix as well.

-- Editor options
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.mouse = "a"

-- Colorscheme: the "classic" filter is the original Monokai palette
vim.opt.termguicolors = true
require("monokai-pro").setup({ filter = "classic" })
vim.cmd.colorscheme("monokai-pro")

-- Show diagnostics inline
vim.diagnostic.config({ virtual_text = true, severity_sort = true })

-- Syntax highlighting via treesitter, for filetypes with a parser installed
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Autocomplete
-- C-space: open menu, C-n/C-p: select, C-y: accept, C-e: dismiss
require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = { documentation = { auto_show = true } },
  signature = { enabled = true },
})

-- LSP
-- Rust
vim.lsp.config("rust_analyzer", {
  cmd = { vim.g.nix_rust_analyzer },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
})

-- Python: use the project's .venv (e.g. one made by uv) if there is one
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = { typeCheckingMode = "standard" },
    },
  },
  before_init = function(_, config)
    if not config.root_dir then
      return
    end
    local python = config.root_dir .. "/.venv/bin/python"
    if vim.uv.fs_stat(python) then
      config.settings.python = { pythonPath = python }
    end
  end,
})

vim.lsp.enable({ "rust_analyzer", "basedpyright", "ruff" })

-- Neovim's default LSP keys: K (hover), grn (rename), gra (code action),
-- grr (references), gri (implementation), gO (symbols), [d and ]d
-- (diagnostics), C-o (jump back), gq (format).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
  end,
})

-- Format on save: python with ruff, rust with rustfmt (via rust-analyzer)
local format_on_save = { python = "ruff", rust = "rust_analyzer" }
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local name = format_on_save[vim.bo[args.buf].filetype]
    if name and #vim.lsp.get_clients({ bufnr = args.buf, name = name }) > 0 then
      vim.lsp.buf.format({ bufnr = args.buf, name = name, timeout_ms = 2000 })
    end
  end,
})
