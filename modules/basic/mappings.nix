{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim;
in {
  options.vim = {
    leaderMapping = mkOption {
      description = "Set the <leader> mapping";
      type = types.str;
    };
    timeoutLen = mkOption {
      description = "Time in milliseconds to wait for a mapped sequence to complete";
      type = types.int;
    };
    mapMoveLine = mkOption {
      description = "Map movng lines up <K> or down <J> in visual mode";
      type = types.bool;
    };
    mapChangeWordDotRepeat = mkOption {
      description = "Map <cn> and <cN> to change word and enable dot-repeat in the next occurrence";
      type = types.bool;
    };
    mapCDtoGitOrCurrent = mkOption {
      description = "Map <C-t> to changing the cwd to the git root or the current file if not in a repo";
      type = types.bool;
    };
    mapWincmdToCtrl = mkOption {
      description = "Map <C> to <C-w> for window commands";
      type = types.bool;
    };
  };

  config = {
    vim.startConfigRC = ''
      vim.g.mapleader = "${cfg.leaderMapping}"
      vim.opt.timeoutlen = ${toString cfg.timeoutLen}

      vim.keymap.set("n", "<tab>", "<cmd>bn<cr>")
      vim.keymap.set("n", "<bs>", "<cmd>bp<cr>")
      vim.keymap.set("n", "H", "^")
      vim.keymap.set("n", "L", "$")

      vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
      vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

      vim.keymap.set("n", "J", "mzJ`z")
      vim.keymap.set("n", "<c-d>", "<c-d>zzzv")
      vim.keymap.set("n", "<c-u>", "<c-u>zzzv")
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")

      vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
      vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

    ${optionalString (!config.vim.sysClipboard) ''
      vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
      vim.keymap.set("n", "<leader>Y", [["+Y]])
      vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
    ''}

    ${optionalString cfg.mapMoveLine ''
      vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
      vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
    ''}

    ${optionalString cfg.mapChangeWordDotRepeat ''
      vim.keymap.set("n", "cn", "*``cgn")
      vim.keymap.set("n", "cN", "*``cgN")
    ''}

    ${optionalString cfg.mapCDtoGitOrCurrent ''
      vim.keymap.set("n", "<c-t>", function()
        local folder = vim.fn.expand("%:h", true, false)
        local out = vim.fn.system("git -C " .. folder .. " rev-parse --show-toplevel")
        vim.cmd("cd " .. (vim.v.shell_error == 0 and out or folder))
      end)
    ''}

    ${optionalString cfg.mapWincmdToCtrl ''
      vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<cr>")
      vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<cr>")
      vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<cr>")
      vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<cr>")
    ''}
    '';
  };
}
