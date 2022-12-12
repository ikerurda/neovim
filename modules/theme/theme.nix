{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.attrsets;
let
  cfg = config.vim.theme;
  supported_themes = import ./supported_themes.nix {inherit pkgs;};
in {
  options.vim.theme = {
    enable = mkEnableOption "theming";
    name = mkOption {
      description = "Supported themes can be found in `supported_themes.nix`";
      type = types.enum (attrNames supported_themes);
    };
    style = mkOption {
      description = "Specific style for theme if it supports it";
      type = types.enum supported_themes.${cfg.name}.styles;
    };
    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = types.lines;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [supported_themes.${cfg.name}.pkg];

    vim.luaConfigRC =
      cfg.extraConfig
      + supported_themes.${cfg.name}.setup {inherit (cfg) style;};
  };
}
