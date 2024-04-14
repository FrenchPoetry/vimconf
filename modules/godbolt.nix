{ pkgs, dsl, ... }:
with dsl; {
  plugins = with pkgs; [
    godbolt-nvim
  ];

  lua = ''
  -- default configuration
  require("godbolt").setup({
    languages = {
      cpp = { compiler = "g122", options = {} },
      c = { compiler = "cg122", options = {} },
      rust = { compiler = "r1650", options = {} }
    },
    quickfix = {
      enable = false,
      auto_open = false
    },
    url = "https://godbolt.org"
  })
  '';
}
