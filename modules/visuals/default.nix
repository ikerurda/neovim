{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./visuals.nix];
  config.vim.visuals = {
    lspkind = mkDefault true;
    colorize = mkDefault true;
    guides = {
      enable = mkDefault true;
      listChar = mkDefault "│";
      fillChar = mkDefault "";
      eolChar = mkDefault "↴";
      hiContext = mkDefault true;
    };
  };
}
