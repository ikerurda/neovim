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
    signs = mkEnableOption "[gitsigns]";
    neogit = mkEnableOption "[neogit]";
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins;
    (optional cfg.signs gitsigns)
    ++ (optional cfg.neogit neogit);

    vim.luaConfigRC = ''
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
