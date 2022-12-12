{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.moving;
in {
  options.vim.moving = {
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
    ++ (optional cfg.leap leap)
    ++ (optional cfg.comment comment)
    ++ (optional cfg.surround surround);

    vim.configRC = ''
    ${optionalString cfg.leap ''
      local leap = require("leap")
      leap.set_default_keymaps()
      leap.opts.highlight_unlabeled_phase_one_targets = true
    ''}
    ${optionalString cfg.comment ''
      require("Comment").setup({ ignore = "^$" })
    ''}
    ${optionalString cfg.surround ''
      require("surround").setup({
        mappings_style = "surround",
        map_insert_mode = false,
      })
    ''}
    '';
  };
}
