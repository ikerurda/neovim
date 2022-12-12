{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let
  cfg = config.vim;
  luaBool = cond:
    if cond
    then "true"
    else "false";
in {
  options.vim = {
    mouse = mkOption {
      description = "Enable mouse support";
      type = types.bool;
    };
    clipboard = mkOption {
      description = "Enable system clipboard integration";
      type = types.bool;
    };
    ignoreCase = mkOption {
      description = "Ignore case in search patterns";
      type = types.bool;
    };
    smartCase = mkOption {
      description = "Override the 'ignoreCase' option if the search pattern contains upper case characters";
      type = types.bool;
    };
    number = mkOption {
      description = "Print the line number in front of each line";
      type = types.bool;
    };
    relativeNumber = mkOption {
      description = "Show the line number relative to the line with the cursor in front of each line";
      type = types.bool;
    };
    scrolloff = mkOption {
      description = "Minimal number of screen lines or columns to keep around the cursor";
      type = types.int;
    };
    expandTab = mkOption {
      description = "Use the appropriate number of spaces to insert a <Tab>";
      type = types.bool;
    };
    tabWidth = mkOption {
      description = "Number of spaces that a <tab> in the file counts for";
      type = types.int;
    };
    wrap = mkOption {
      description = "When on, lines longer than the width of the window will wrap and displaying continues on the next line";
      type = types.bool;
    };
    cursorLine = mkOption {
      description = "Highlight the text line of the cursor";
      type = types.bool;
    };
    disableBuiltins = mkOption {
      description = "Whether to disable unnecessary builtins";
      type = types.bool;
    };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [plenary impatient];

    vim.startLuaConfigRC = ''
    ${optionalString cfg.mouse ''
      vim.opt.mouse = "a"
    ''}
    ${optionalString cfg.clipboard ''
      vim.opt.clipboard = "unnamedplus"
    ''}
      vim.opt.termguicolors = true

      vim.opt.showmode = false
      vim.opt.shortmess:append("asc")
      vim.opt.formatoptions = "njcrql"
      vim.opt.showcmd = true
      vim.opt.cmdheight = 1

      vim.opt.inccommand = "split"
      vim.opt.incsearch = true
      vim.opt.hlsearch = false
      vim.opt.ignorecase = ${luaBool cfg.ignoreCase}
      vim.opt.smartcase = ${luaBool cfg.smartCase}

      vim.opt.signcolumn = "yes"
      vim.opt.number = ${luaBool cfg.number}
      vim.opt.relativenumber = ${luaBool cfg.relativeNumber}

      vim.opt.scrolloff = ${toString cfg.scrolloff}
      vim.opt.sidescrolloff = ${toString cfg.scrolloff}

      vim.opt.expandtab = ${luaBool cfg.expandTab}
      vim.opt.tabstop = ${toString cfg.tabWidth}
      vim.opt.shiftwidth = 0
      vim.opt.softtabstop = -1
      vim.opt.autoindent = true

      vim.opt.wrap = ${luaBool cfg.wrap}
      vim.opt.linebreak = true
      vim.opt.breakindent = true
      vim.opt.cursorline = ${luaBool cfg.cursorLine}

      vim.opt.winbar = "%t%M"
      vim.opt.showtabline = 0

      vim.opt.equalalways = false
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      vim.opt.undofile = true

    ${optionalString cfg.disableBuiltins ''
      vim.g.loaded_gzip = true
      vim.g.loaded_zip = true
      vim.g.loaded_zipPlugin = true
      vim.g.loaded_tar = true
      vim.g.loaded_tarPlugin = true
      vim.g.loaded_getscript = true
      vim.g.loaded_getscriptPlugin = true
      vim.g.loaded_vimball = true
      vim.g.loaded_vimballPlugin = true
      vim.g.loaded_2html_plugin = true
      vim.g.loaded_matchit = true
      vim.g.loaded_matchparen = true
      vim.g.loaded_logiPat = true
      vim.g.loaded_rrhelper = true
      vim.g.loaded_netrw = true
      vim.g.loaded_netrwPlugin = true
      vim.g.loaded_netrwSettings = true
    ''}
    '';
  };
}
