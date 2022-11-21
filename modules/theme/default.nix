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
  supported_themes = import ./supported_themes.nix;
in {
  options.vim.theme = {
    enable = mkEnableOption "[Theming]";

    name = mkOption {
      description = "Supported themes can be found in `supported_themes.nix`";
      type = types.enum (attrNames supported_themes);
      default = "github-theme";
    };

    style = mkOption {
      description = "Specific style for theme if it supports it";
      type = with types; enum supported_themes.${cfg.name}.styles;
      default = "dark_default";
    };

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = with types; lines;
      default = ''
        local override = function(c)
          return {
            VertSplit = { fg = c.fg_dark },
            ColorColumn = { bg = c.bg_highlight },
            GitSignsAdd = { fg = c.green },
            GitSignsChange = { fg = c.magenta },
            GitSignsDelete = { fg = c.red },
            LeapMatch = { fg = c.red, style = "underline,bold" },
            LeapLabelPrimary = { bg = c.red, fg = c.bg },
            LeapLabelSecondary = { fg = c.blue },
            LeapBackdrop = { fg = c.syntax.comment, bg = c.bg },
            FidgetTitle = { fg = c.syntax.comment, bg = c.bg },
            TelescopePromptCounter = { fg = c.syntax.comment, bg = c.bg },
          }
        end
      '';
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [pkgs.neovimPlugins.${cfg.name}];
    vim.luaConfigRC =
      cfg.extraConfig
      + supported_themes.${cfg.name}.setup {style = cfg.style;};
  };
}
