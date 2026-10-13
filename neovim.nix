{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # No remote plugin hosts needed; everything here is Lua
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    plugins = with pkgs.vimPlugins; [
      # Server definitions for the built-in LSP client
      nvim-lspconfig
      # Autocomplete
      blink-cmp
      # Auto-insert closing brackets and quotes
      nvim-autopairs
      # Colorscheme
      monokai-pro-nvim
      # Syntax highlighting
      (nvim-treesitter.withPlugins
        (p: with p; [ rust python nix toml lua markdown bash json yaml ]))
    ];

    # Appended to nvim's PATH, so a project-local version takes priority
    extraPackages = with pkgs; [
      # Python LSP
      basedpyright
      # Python linter and formatter
      ruff
    ];

    # rust-analyzer is referenced by store path rather than put on PATH,
    # because rustup's rust-analyzer proxy in ~/.cargo/bin shadows it and
    # fails when the rustup component is not installed.
    initLua = ''
      vim.g.nix_rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer"
    '' + builtins.readFile ./to-symlink/nvim/init.lua;
  };
}
