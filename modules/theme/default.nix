{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.attrsets;
with builtins; let
  cfg = config.vim.theme;
  supported_themes = import ./supported_themes.nix {inherit pkgs;};
in {
  options.vim.theme = {
    enable = mkEnableOption "[Theming]";

    name = mkOption {
      description = "Supported themes can be found in `supported_themes.nix`";
      type = types.enum (attrNames supported_themes);
      default = "custom";
    };

    style = mkOption {
      description = "Specific style for theme if it supports it";
      type = with types; enum supported_themes.${cfg.name}.styles;
    };

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = with types; lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [supported_themes.${cfg.name}.pkg];
    vim.luaConfigRC =
      cfg.extraConfig
      + supported_themes.${cfg.name}.setup {style = cfg.style;};
  };
}