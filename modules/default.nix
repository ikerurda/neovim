{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./completion
    ./theme
    ./core
    ./basic
    ./statusline
    ./visuals
    ./moving
    ./lsp
    ./treesitter
    ./telescope
    ./git
  ];
}
