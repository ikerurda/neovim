{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    lspkind = mkOption {
      description = "Whether to enable lspkind icons";
      type = types.bool;
    };
    colorize = mkOption {
      description = "Whether to enable colorizing";
      type = types.bool;
    };
    guides = {
      enable = mkEnableOption "indentation guides";
      listChar = mkOption {
        description = "Character for indentation line";
        type = types.str;
      };
      fillChar = mkOption {
        description = "Character to fill indents";
        type = types.str;
      };
      eolChar = mkOption {
        description = "Character at end of line";
        type = types.str;
      };
      hiContext = mkOption {
        description = "Highlight current context with treesitter";
        type = types.bool;
      };
    };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
    ]
    ++ (optional cfg.lspkind lspkind)
    ++ (optional cfg.guides.enable indent-blankline)
    ++ (optional cfg.colorize colorizer);

    vim.configRC = ''
    ${optionalString cfg.lspkind ''
      require("lspkind").init()
    ''}
    ${optionalString cfg.guides.enable ''
      vim.wo.colorcolumn = "99999"
      vim.opt.list = true

    ${optionalString (cfg.guides.eolChar != "") ''
      vim.opt.listchars:append({ eol = "${cfg.guides.eolChar}" })
    ''}

    ${optionalString (cfg.guides.fillChar != "") ''
      vim.opt.listchars:append({ space = "${cfg.guides.fillChar}" })
    ''}

      require("indent_blankline").setup({
        filetype_exclude = { "help", "man" },
        buftype_exclude = { "terminal" },
        bufname_exclude = { "Untitled" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        show_end_of_line = true,
        char = "${cfg.guides.listChar}",
        show_current_context = ${boolToString cfg.guides.hiContext},
        use_treesitter = ${boolToString config.vim.treesitter.enable},
      })
    ''}

    ${optionalString cfg.colorize ''
      require("colorizer").setup({}, { mode = "foreground" })
    ''}
    '';
  };
}
