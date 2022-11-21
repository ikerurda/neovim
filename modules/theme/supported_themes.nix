{
  github-theme = {
    setup = {style ? "dark_default"}: ''
      require("github-theme").setup {
        theme_style = "${style}",
        hide_inactive_statusline = false,
        dev = true,
        overrides = override,
      }
    '';
    styles = ["dark_default"];
  };
}
