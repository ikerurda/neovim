{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements";
    lspkind = mkEnableOption "enable vscode-like pictograms for lsp [lspkind]";
    colorize = mkEnableOption "enable vscode-like pictograms for lsp [lspkind]";
    dressing = mkEnableOption "enable vscode-like pictograms for lsp [lspkind]";
    wordline = {
      enable = mkEnableOption "enable word and delayed line highlight [nvim-cursorline]";
      timeout = mkOption {
        type = types.int;
        description = "time in milliseconds for cursorline to appear";
      };
    };
    guides = {
      enable = mkEnableOption "enable indentation guides [indent-blankline]";
      listChar = mkOption {
        type = types.str;
        description = "Character for indentation line";
      };
      fillChar = mkOption {
        type = types.str;
        description = "Character to fill indents";
      };
      eolChar = mkOption {
        type = types.str;
        description = "Character at end of line";
      };
      hiContext = mkOption {
        type = types.bool;
        description = "Highlight current context from treesitter";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (addIf cfg.lspkind pkgs.neovimPlugins.lspkind)
      (addIf cfg.wordline.enable cursorline)
      (addIf cfg.guides.enable indent-blankline)
      (addIf cfg.colorize colorizer)
      (addIf cfg.dressing dressing)
    ];

    vim.luaConfigRC = ''
    ${writeIf cfg.lspkind ''
      require("lspkind").init()
    ''}
    ${writeIf cfg.guides.enable ''
      -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
      vim.wo.colorcolumn = "99999"
      vim.opt.list = true

    ${writeIf (cfg.guides.eolChar != "") ''
      vim.opt.listchars:append({ eol = "${cfg.guides.eolChar}" })
    ''}

    ${writeIf (cfg.guides.fillChar != "") ''
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
      ${writeIf config.vim.treesitter.enable ''
        use_treesitter = true,
      ''}
      })
    ''}

    ${writeIf cfg.wordline.enable ''
      vim.g.cursorline_timeout = ${toString cfg.wordline.timeout}
    ''}

    ${writeIf cfg.colorize ''
      require("colorizer").setup({}, { mode = "foreground" })
    ''}

    ${writeIf cfg.dressing ''
      require("dressing").setup {}
    ''}
    '';
  };
}
