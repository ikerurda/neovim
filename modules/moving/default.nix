{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./moving.nix];
  config.vim.moving = {
    leap = mkDefault true;
    comment = mkDefault false;
    surround = mkDefault false;
  };
}
