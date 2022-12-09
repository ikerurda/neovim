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
    ./lsp
    ./treesitter
    ./markdown
    ./telescope
    ./git
  ];
}
