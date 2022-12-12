{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./telescope.nix];
  config.vim.telescope = {
    enable = mkDefault true;
    file-browser = mkDefault true;
    project = mkDefault true;
    ui-select = mkDefault true;
    symbols = mkDefault true;
  };
}
