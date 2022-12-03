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
      default = "base16";
    };

    style = mkOption {
      description = "Specific style for theme if it supports it";
      type = with types; enum supported_themes.${cfg.name}.styles;
      default = "default-dark";
    };

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = with types; lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [supported_themes.${cfg.name}.pkg];
    vim.startLuaConfigRC =
      cfg.extraConfig
      + supported_themes.${cfg.name}.setup {inherit (cfg) style;};
  };
}
