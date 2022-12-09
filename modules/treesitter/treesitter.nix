{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.treesitter = {
    enable = mkEnableOption "nvim-treesitter";
    fold = mkEnableOption "fold with tree-sitter";
    refactor = mkEnableOption "refactor with tree-sitter";
    textobjects = mkEnableOption "tree-sitter's textobjects";
    context = mkEnableOption "tree-sitter's context";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-treesitter
      (addIf cfg.refactor nvim-treesitter-refactor)
      (addIf cfg.textobjects nvim-treesitter-textobjects)
      (addIf cfg.context nvim-treesitter-context)
    ];

    vim.luaConfigRC = ''
    ${writeIf cfg.fold ''
      vim.g.foldmethod = "expr"
      vim.g.foldexpr = "nvim_treesitter#foldexpr()"
      vim.g.foldable = false
    ''}
      require"nvim-treesitter.configs".setup {
        ensure_installed = "all",
        indent = { enable = true },
        highlight = { enable = true },
        refactor = {
          smart_rename = { enable = true, keymaps = { smart_rename = "gr" } },
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = false },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            scope_incremental = "<nop>",
            node_incremental = "<c-j>",
            node_decremental = "<c-k>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<c-n>"] = "@parameter.inner" },
            swap_previous = { ["<c-p>"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["gf"] = "@function.outer",
              ["ga"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["gF"] = "@function.outer",
              ["gA"] = "@parameter.inner",
            },
          },
        },
      }
    ${writeIf cfg.context ''
      require"treesitter-context".setup {
        enable = true,
        throttle = true,
        max_lines = 0
      }
    ''}
    '';
  };
}
