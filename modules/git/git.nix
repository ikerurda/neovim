{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.git = {
    enable = mkEnableOption "Enable git plugins";
    signs = mkEnableOption "Enable git options";
    neogit = mkEnableOption "Enable git options";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (addIf (cfg.signs) gitsigns)
      (addIf (cfg.neogit) neogit)
    ];

    vim.luaConfigRC = ''
    ${writeIf (cfg.signs) ''
      require("gitsigns").setup({ keymaps = {} })
    ''}
    ${writeIf (cfg.neogit) ''
      vim.keymap.set("n", "<leader>g", function()
        require("neogit").open({ cwd = vim.fn.expand("%:h", true, false) })
      end)
    ''}
    '';
  };
}
