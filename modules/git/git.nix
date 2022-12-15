{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.git;
in {
  options.vim.git = {
    signs = {
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
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
    ]
    ++ (optional cfg.signs.enable gitsigns)
    ++ (optional cfg.neogit neogit);

    vim.configRC = ''
    ${optionalString cfg.signs.enable ''
      require("gitsigns").setup({ current_line_blame = ${boolToString cfg.signs.blame} })
    ''}
    ${optionalString cfg.neogit ''
      require("neogit").setup({
        disable_builtin_notifications = true;
      });
      vim.keymap.set("n", "<leader>g", function()
        require("neogit").open({ cwd = vim.fn.expand("%:h", true, false) })
      end)
    ''}
    '';
  };
}
