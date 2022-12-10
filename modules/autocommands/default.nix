{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [./autocommands.nix];
  config.vim.autocommands = {
    yankHi = mkDefault true;
    termMappings = mkDefault true;
    formatoptions = mkDefault true;
  };
}
