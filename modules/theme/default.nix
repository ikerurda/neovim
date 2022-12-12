{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./theme.nix];
  config.vim.theme = {
    enable = mkDefault true;
    name = mkDefault "custom";
    style = mkDefault "default-dark";
    extraConfig = mkDefault "";
  };
}
