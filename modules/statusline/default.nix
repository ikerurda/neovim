{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings; {
  imports = [./lualine.nix];
  config.vim.statusline = {
    enable = mkDefault true;
    theme = mkDefault "base16";
    global = mkDefault true;
    sectionSeparator = mkDefault "";
    componentSeparator = mkDefault "";
    section = {
      a = mkDefault ''{ "mode" }'';
      b = mkDefault ''
        {
          {
            "filename",
            file_status = true,
            path = 1,
            shorting_target = 50,
            symbols = { modified = ",+", readonly = ",-" },
          },
        }
      '';
      c = mkDefault ''
        {
          "branch",
          {
            "diff",
            colored = false,
            symbols = { added = "+", modified = "~", removed = "-" },
          },
        }
      '';
      x = mkDefault ''
        {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn", "info", "hint" },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            colored = false,
            update_in_insert = false,
            always_visible = false,
          },
        ${optionalString config.vim.lsp.progress ''
          {
            "lsp_progress",
            display_components = {"percentage"},
          },
        ''}
        }
      '';
      y = mkDefault ''{ "progress" }'';
      z = mkDefault ''{ "%l/%L:%c" }'';
    };
  };
}
