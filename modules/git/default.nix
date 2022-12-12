{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./git.nix];
  config.vim.git = {
    signs = mkDefault true;
    neogit = mkDefault true;
  };
}
