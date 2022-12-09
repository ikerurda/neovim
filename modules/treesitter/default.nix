{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [./treesitter.nix];
  config = {
    vim.treesitter = {
      enable = mkDefault false;
      fold = mkDefault true;
      refactor = mkDefault true;
      textobjects = mkDefault true;
      context = mkDefault true;
    };
  };
}
