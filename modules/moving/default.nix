{ pkgs
, config
, lib
, ...
}:
with lib; {
  imports = [./moving.nix];
  config.vim.moving = {
    leap = mkDefault true;
    comment = mkDefault true;
    surround = mkDefault true;
  };
}
