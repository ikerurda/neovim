{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./telescope.nix];
  config = {
    vim.telescope = {
      enable = true;
      file-browser = true;
      project = true;
      ui-select = true;
      symbols = true;
    };
  };
}
