{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./lsp.nix
    ./nvim-code-action-menu.nix
    ./lsp-signature.nix
    ./lightbulb.nix
  ];
}
