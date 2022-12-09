{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [./completion.nix];
  config = {
    vim.completion = {
      enable = mkDefault false;
      snippets = mkDefault true;
      autopairs = mkDefault true;
    };
  };
}
