{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
in {
  options.vim = {
    highlightOnYank = mkOption {
      description = "Highlight yanked area";
      type = types.bool;
    };
  };

  config = {
    vim.luaConfigRC = ''
      local user = vim.api.nvim_create_augroup("user", { clear = true })
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
    ${writeIf cfg.highlightOnYank ''
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank { higroup = "IncSearch" }
        end,
        group = user,
      })
    ''}
    '';
  };
}
