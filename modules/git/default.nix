{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./git.nix];
  config.vim.git = {
    signs = {
      enable = mkDefault true;
      blame = mkDefault true;
    };
    neogit = mkDefault true;
  };
}
