{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./treesitter.nix];
  config.vim.treesitter = {
    enable = mkDefault true;
    fold = mkDefault true;
    refactor = mkDefault true;
    textobjects = mkDefault true;
    context = mkDefault true;
  };
}
