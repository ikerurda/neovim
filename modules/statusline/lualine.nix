{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let cfg = config.vim.statusline;
in {
  options.vim.statusline = {
    enable = mkEnableOption "lualine";
    global = mkOption {
      description = "Whether to enable global statusline";
      type = types.bool;
    };
    theme = mkOption {
      description = "Statusline theme";
      type = types.str;
    };
    sectionSeparator = mkOption {
      description = "Statusline section separator";
      type = types.str;
    };
    componentSeparator = mkOption {
      description = "Statusline component separator";
      type = types.str;
    };
    section = {
      a = mkOption {
        description = "Section config for: |(A)|B|C   X|Y|Z|";
        type = types.str;
      };
      b = mkOption {
        description = "Section config for: |A|(B)|C   X|Y|Z|";
        type = types.str;
      };
      c = mkOption {
        description = "Section config for: |A|B|(C)   X|Y|Z|";
        type = types.str;
      };
      x = mkOption {
        description = "Section config for: |A|B|C   (X)|Y|Z|";
        type = types.str;
      };
      y = mkOption {
        description = "Section config for: |A|B|C   X|(Y)|Z|";
        type = types.str;
      };
      z = mkOption {
        description = "Section config for: |A|B|C   X|Y|(Z)|";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      lualine
    ]
    ++ (optional config.vim.lsp.progress lsp-progress);

    vim.configRC = ''
      require"lualine".setup({
        options = {
          globalstatus = ${boolToString cfg.global},
          theme = "${cfg.theme}",
          component_separators = "${cfg.componentSeparator}",
          section_separators = "${cfg.sectionSeparator}",
        },
        sections = {
          lualine_a = ${cfg.section.a},
          lualine_b = ${cfg.section.b},
          lualine_c = ${cfg.section.c},
          lualine_x = ${cfg.section.x},
          lualine_y = ${cfg.section.y},
          lualine_z = ${cfg.section.z},
        },
      })
    '';
  };
}
