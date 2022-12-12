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
    signs = mkOption {
      description = "Whether to enable git signs";
      type = types.bool;
    };
    neogit = mkOption {
      description = "Whether to enable neogit";
      type = types.bool;
    };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
    ]
    ++ (optional cfg.signs gitsigns)
    ++ (optional cfg.neogit neogit);

    vim.configRC = ''
    ${optionalString cfg.signs ''
      require("gitsigns").setup({ keymaps = {} })
    ''}
    ${optionalString cfg.neogit ''
      vim.keymap.set("n", "<leader>g", function()
        require("neogit").open({ cwd = vim.fn.expand("%:h", true, false) })
      end)
    ''}
    '';
  };
}
