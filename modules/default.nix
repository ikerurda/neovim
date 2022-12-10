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
    ./autocommands
    ./lsp
    ./treesitter
    ./telescope
    ./git
  ];
}
