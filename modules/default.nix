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
    ./snippets
    ./markdown
    ./telescope
    ./git
  ];
}
