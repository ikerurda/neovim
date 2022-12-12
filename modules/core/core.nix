{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let cfg = config.vim;
in {
  options.vim = {
    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
    };
    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
    };
    startConfigRC = mkOption {
      description = "Start of vim lua config";
      type = types.lines;
    };
    configRC = mkOption {
      description = "Vim lua config";
      type = types.lines;
    };
    finalRC = mkOption {
      description = "Final vim lua config used by the builder";
      type = types.lines;
    };
    startPlugins = mkOption {
      description = "List of plugins to startup";
      type = with types; listOf package;
    };
    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      type = with types; listOf package;
    };
  };

  config = {
    vim.finalRC = ''
      lua << EOF
      ${cfg.startConfigRC}
      ${cfg.configRC}
      EOF
    '';
  };
}
