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
    comment = mkDefault true;
    surround = mkDefault true;
  };
}
