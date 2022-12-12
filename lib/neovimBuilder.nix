{
  pkgs,
  lib ? pkgs.lib,
  ...
}: {config}:
with builtins;
let
  myNeovimUnwrapped = pkgs.neovim-unwrapped;
  vimOptions = lib.evalModules {
    modules = [{imports = [../modules];} config];
    specialArgs = {inherit pkgs;};
  };
  neovimPlugins = pkgs.neovimPlugins;
  vim = vimOptions.config.vim;
in
  pkgs.wrapNeovim myNeovimUnwrapped {
    viAlias = vim.viAlias;
    vimAlias = vim.vimAlias;
    configure = {
      customRC = vim.finalRC;
      packages.myVimPackage = with neovimPlugins; {
        start = filter (f: f != null) vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  }
