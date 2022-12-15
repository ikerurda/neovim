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
    lsp_handlers = mkDefault true;
  };
}
