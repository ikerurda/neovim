{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkEnableOption "treesitter";
    fold = mkOption {
      description = "Whether to enable treesitter folding";
      type = types.bool;
    };
    refactor = mkOption {
      description = "Whether to enable treesitter refactoring";
      type = types.bool;
    };
    textobjects = mkOption {
      description = "Whether to enable treesitter textobjects";
      type = types.bool;
    };
    context = mkOption {
      description = "Whether to enable treesitter context";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      treesitter
      (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
    ]
    ++ (optional cfg.refactor treesitter-refactor)
    ++ (optional cfg.textobjects treesitter-textobjects)
    ++ (optional cfg.context treesitter-context);

    vim.configRC = ''
    ${optionalString cfg.fold ''
      vim.g.foldmethod = "expr"
      vim.g.foldexpr = "nvim_treesitter#foldexpr()"
      vim.g.foldable = false
    ''}
      require("nvim-treesitter.configs").setup({
        indent = { enable = true },
        highlight = { enable = true },
      ${optionalString cfg.refactor ''
        refactor = {
          smart_rename = { enable = true, keymaps = { smart_rename = "gr" } },
          highlight_definitions = { enable = true },
        },
      ''}
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            scope_incremental = "<nop>",
            node_incremental = "<c-j>",
            node_decremental = "<c-k>",
          },
        },
      ${optionalString cfg.textobjects ''
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
      ''}
      })
    ${optionalString cfg.context ''
      require("treesitter-context").setup({
        enable = true,
        throttle = true,
        max_lines = 0
      })
    ''}
    '';
  };
}
