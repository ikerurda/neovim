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
    progress = mkDefault true;
    formatOnSave = mkDefault false;
    lightbulb = {
      enable = mkDefault true;
      text = "A";
    };
    languages = {
      nix = mkDefault true;
      c = mkDefault true;
      ts = mkDefault true;
      py = mkDefault true;
    };
  };
}
