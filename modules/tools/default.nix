{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./tools.nix];
  config.vim.tools = {
    gitsigns = {
      enable = mkDefault true;
      blame = mkDefault true;
    };
    neogit = mkDefault true;
    undotree = mkDefault true;
    leap = mkDefault true;
    comment = mkDefault true;
    surround = mkDefault true;
  };
}
