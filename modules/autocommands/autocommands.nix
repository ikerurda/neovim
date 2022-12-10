{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.autocommands;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.autocommands = {
    yankHi = mkEnableOption "fold with tree-sitter";
    termMappings = mkEnableOption "refactor with tree-sitter";
    formatoptions = mkEnableOption "tree-sitter's textobjects";
  };

  config = {
    vim.luaConfigRC = ''
    ${writeIf cfg.yankHi ''
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank { higroup = "IncSearch" }
        end,
        group = user,
      })
    ''}
    ${writeIf cfg.termMappings ''
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.cmd "startinsert"
          vim.opt_local.signcolumn = "no"
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { buffer = true })
        end,
        group = user,
      })
    ''}
    ${writeIf cfg.formatoptions ''
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          vim.opt_local.formatoptions = "njcrql"
        end,
        group = user,
      })
    ''}
    '';
  };
}
