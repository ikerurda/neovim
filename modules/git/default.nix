{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [./git.nix];
  config = {
    vim.git = {
      enable = mkDefault true;
      signs = mkDefault true;
      neogit = mkDefault true;
    };
  };
}
