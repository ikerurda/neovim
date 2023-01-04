{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [./options.nix ./autocommands.nix ./mappings.nix];
  config.vim = {
    mouse = mkDefault "a";
    sysClipboard = mkDefault false;
    updatetime = mkDefault 800;
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
    leaderMapping = mkDefault " ";
    timeoutLen = mkDefault 1000;
    mapMoveLine = mkDefault true;
    mapChangeWordDotRepeat = mkDefault true;
    mapCDtoGitOrCurrent = mkDefault true;
    mapWincmdToCtrl = mkDefault true;
    highlightOnYank = mkDefault true;
  };
}
