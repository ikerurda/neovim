{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.moving;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.moving = {
    leap = mkEnableOption "visual enhancements";
    comment = mkEnableOption "enable vscode-like pictograms for lsp [lspkind]";
    surround = mkEnableOption "enable vscode-like pictograms for lsp [lspkind]";
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (addIf cfg.leap leap)
      (addIf cfg.comment comment)
      (addIf cfg.surround surround)
    ];

    vim.luaConfigRC = ''
    ${writeIf cfg.leap ''
      local leap = require("leap")
      leap.set_default_keymaps()
      leap.opts.highlight_unlabeled_phase_one_targets = true
    ''}
    ${writeIf cfg.comment ''
      require("Comment").setup({ ignore = "^$" })
    ''}
    ${writeIf cfg.surround ''
      require("surround").setup({
        mappings_style = "surround",
        map_insert_mode = false,
      })
    ''}
    '';
  };
}
