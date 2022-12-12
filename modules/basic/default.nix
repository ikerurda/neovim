{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [./basic.nix ./au.nix ./map.nix];
  config.vim = {
    leaderMapping = mkDefault " ";
    timeoutLen = mkDefault 1000;
    mouse = mkDefault true;
    clipboard = mkDefault true;
    ignoreCase = mkDefault true;
    smartCase = mkDefault true;
    number = mkDefault true;
    relativeNumber = mkDefault true;
    scrolloff = mkDefault 5;
    expandTab = mkDefault true;
    tabWidth = mkDefault 2;
    wrap = mkDefault false;
    cursorLine = mkDefault true;
    disableBuiltins = mkDefault true;
    mapMoveLine = mkDefault true;
    mapChangeWordDotRepeat = mkDefault true;
    mapCDtoGitOrCurrent = mkDefault true;
    highlightOnYank = mkDefault true;
  };
}
