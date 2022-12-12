{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./core
    ./basic
    ./completion
    ./git
    ./lsp
    ./moving
    ./statusline
    ./telescope
    ./theme
    ./treesitter
    ./visuals
  ];
}
