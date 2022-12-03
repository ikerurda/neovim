{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.statusline;
  toBool = cond:
    if cond
    then "true"
    else "false";
in {
  options.vim.statusline = {
    enable = mkEnableOption "lualine";

    sectionSeparator = mkOption {
      type = types.str;
      description = "Section separator";
    };

    componentSeparator = mkOption {
      type = types.str;
      description = "Component separator";
    };

    section = {
      a = mkOption {
        type = types.str;
        description = "Section config for: | (A) | B | C       X | Y | Z |";
      };

      b = mkOption {
        type = types.str;
        description = "Section config for: | A | (B) | C       X | Y | Z |";
      };

      c = mkOption {
        type = types.str;
        description = "Section config for: | A | B | (C)       X | Y | Z |";
      };

      x = mkOption {
        type = types.str;
        description = "Section config for: | A | B | C       (X) | Y | Z |";
      };

      y = mkOption {
        type = types.str;
        description = "Section config for: | A | B | C       X | (Y) | Z |";
      };

      z = mkOption {
        type = types.str;
        description = "Section config for: | A | B | C       X | Y | (Z) |";
      };
    };

    global = mkEnableOption "global statusline";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [lualine];
    vim.luaConfigRC = ''
      require'lualine'.setup {
        options = {
          theme = "auto",
          component_separators = "${cfg.componentSeparator}",
          section_separators = "${cfg.sectionSeparator}",
          globalstatus = ${toBool cfg.global},
        },
        sections = {
          lualine_a = ${cfg.section.a},
          lualine_b = ${cfg.section.b},
          lualine_c = ${cfg.section.c},
          lualine_x = ${cfg.section.x},
          lualine_y = ${cfg.section.y},
          lualine_z = ${cfg.section.z},
        },
      }
    '';
  };
}
