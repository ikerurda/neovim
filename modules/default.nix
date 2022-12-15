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
    ./lsp
    ./tools
    ./statusline
    ./telescope
    ./theme
    ./treesitter
    ./visuals
  ];
}
