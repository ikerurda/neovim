{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./completion.nix];
  config.vim.completion = {
    enable = mkDefault true;
    snippets = mkDefault true;
    autopairs = mkDefault true;
  };
}
