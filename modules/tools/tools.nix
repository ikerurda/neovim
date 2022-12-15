{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.tools;
in {
  options.vim.tools = {
    gitsigns = {
      enable = mkEnableOption "gitsigns";
      blame = mkOption {
        description = "Whether to enable git blame";
        type = types.bool;
      };
    };
    neogit = mkOption {
      description = "Whether to enable neogit";
      type = types.bool;
    };
    leap = mkOption {
      description = "Whether to enable leaping";
      type = types.bool;
    };
    comment = mkOption {
      description = "Whether to enable commenting";
      type = types.bool;
    };
    surround = mkOption {
      description = "Whether to enable surrounding";
      type = types.bool;
    };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
    ]
    ++ (optional cfg.gitsigns.enable gitsigns)
    ++ (optional cfg.neogit neogit)
    ++ (optional cfg.leap leap)
    ++ (optional cfg.comment comment)
    ++ (optional cfg.surround surround);

    vim.configRC = ''
    ${optionalString cfg.gitsigns.enable ''
      require("gitsigns").setup({ current_line_blame = ${boolToString cfg.gitsigns.blame} })
    ''}
    ${optionalString cfg.neogit ''
      require("neogit").setup({
        disable_builtin_notifications = true,
        disable_insert_on_commit = true,
      });
      vim.keymap.set("n", "<leader>g", function() require("neogit").open() end)
    ''}
    ${optionalString cfg.leap ''
      local leap = require("leap")
      leap.set_default_keymaps()
      leap.opts.highlight_unlabeled_phase_one_targets = true
    ''}
    ${optionalString cfg.comment ''
      require("Comment").setup({ ignore = "^$" })
    ''}
    ${optionalString cfg.surround ''
      require("nvim-surround").setup({
        keymaps = { insert = false, insert_line = false }
      })
    ''}
    '';
  };
}
