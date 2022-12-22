{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./core.nix];
  config.vim = {
    viAlias = mkDefault false;
    vimAlias = mkDefault true;
    startConfigRC = mkDefault "";
    configRC = mkDefault "";
    startPlugins = mkDefault [];
    optPlugins = mkDefault [];
  };
}
