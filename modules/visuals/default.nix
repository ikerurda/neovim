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
    wordline = {
      enable = mkDefault true;
      timeout = mkDefault 500;
    };
    guides = {
      enable = mkDefault true;
      listChar = mkDefault "│";
      fillChar = mkDefault "";
      eolChar = mkDefault "↴";
      hiContext = mkDefault true;
    };
  };
}
