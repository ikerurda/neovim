{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./lsp.nix];
  config.vim.lsp = {
    enable = mkDefault true;
    signature = mkDefault true;
    progress = mkDefault true;
    formatOnSave = mkDefault false;
    languages = {
      nix = mkDefault true;
      c = mkDefault true;
      ts = mkDefault true;
      py = mkDefault true;
    };
  };
}
