{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./core.nix];
  config.vim = {
    viAlias = mkDefault true;
    vimAlias = mkDefault true;
    startConfigRC = mkDefault "";
    configRC = mkDefault "";
    startPlugins = mkDefault [];
    optPlugins = mkDefault [];
  };
}
