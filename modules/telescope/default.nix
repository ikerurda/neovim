{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.telescope;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";
    file-browser = mkEnableOption "enable telescope-file-browser";
    project = mkEnableOption "enable telescope-project";
    ui-select = mkEnableOption "enable telescope-ui-select";
    symbols = mkEnableOption "enable telescope-symbols";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      telescope
      (addIf cfg.file-browser telescope-file-browser)
      (addIf cfg.project telescope-project)
      (addIf cfg.ui-select telescope-ui-select)
      (addIf cfg.symbols telescope-symbols)
    ];

    vim.luaConfigRC = ''
    ${writeIf cfg.file-browser ''
      local action_state = require "telescope.actions.state"
      local builtin = require "telescope.builtin"
      local open_in = function(finder)
        return function()
          local entry_path = action_state.get_selected_entry().Path
          local path = entry_path:is_dir() and entry_path:absolute()
              or entry_path:parent():absolute()
          finder { cwd = path }
        end
      end
      local open_in_fb = function()
        local Path = require "plenary.path"
        local fb = require("telescope").extensions.file_browser.file_browser
        local entry_path = Path:new(action_state.get_selected_entry()[1])
        local path = entry_path:parent():absolute()
        fb { path = path }
      end
    ''}

      local actions = require "telescope.actions"
      local layout_actions = require "telescope.actions.layout"
      local tl = require "telescope"
      tl.setup {
        defaults = {
          prompt_prefix = " ",
          selection_caret = "  ",
          multi_icon = "• ",
          path_display = { ["truncate"] = 3 },
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              prompt_position = "top",
              mirror = true,
              preview_cutoff = 30,
            },
          },
          mappings = { i = {
            ["<c-space>"] = layout_actions.toggle_preview,
            ["<esc>"] = actions.close
          }},
        },
        pickers = {
        ${writeIf cfg.file-browser ''
          oldfiles = { mappings = { i = { ["<a-e>"] = open_in_fb } } },
          find_files = { mappings = { i = { ["<a-e>"] = open_in_fb } } },
        ''}
          diagnostics = { theme = "cursor", previewer = false },
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
            mappings = { i = { ["<c-d>"] = "delete_buffer" } },
          },
        },
        extensions = {
        ${writeIf cfg.file-browser ''
          file_browser = {
            dir_icon = "=",
            grouped = true,
            hide_parent_dir = true,
            cwd_to_path = true,
            select_buffer = true,
            respect_gitignore = false,
            hijack_netrw = true,
            mappings = {
              i = {
                ["<a-f>"] = open_in(builtin.find_files),
                ["<a-g>"] = open_in(builtin.live_grep),
              },
            },
          },
        ''}
        ${writeIf cfg.project ''
          project = { theme = "dropdown", browse_by_default = true },
        ''}
        },
      }
      ${writeIf cfg.file-browser ''tl.load_extension "file_browser"''}
      ${writeIf cfg.project ''tl.load_extension "project"''}
      ${writeIf cfg.ui-select ''tl.load_extension "ui-select"''}
    '';

    vim.nnoremap = {
      "<leader>fr" = "<cmd>Telescope oldfiles<cr>";
      "<leader>ft" = "<cmd>Telescope resume<cr>";
      "<leader>fb" = "<cmd>Telescope buffers<cr>";
      "<leader>ff" = "<cmd>Telescope find_files<cr>";
      "<leader>fg" = "<cmd>Telescope live_grep<cr>";
      "<leader>fs" = "<cmd>Telescope grep_string<cr>";
      "<leader>fa" = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      "<leader>fh" = "<cmd>Telescope help_tags<cr>";
      "<leader>fm" = "<cmd>Telescope man_pages<cr>";
    }
    // (
      if cfg.file-browser
      then {"<leader>fe" = "<cmd>Telescope file_browser<CR>";}
      else {}
    )
    // (
      if cfg.project
      then {"<leader>fj" = "<cmd>Telescope project<CR>";}
      else {}
    )
    // (
      if cfg.symbols
      then {"<leader>fv" = "<cmd>Telescope symbols<CR>";}
      else {}
    )
    // (
      if config.vim.lsp.enable
      then {"<leader>fd" = "<cmd>Telescope diagnostics<CR>";}
      else {}
    );
  };
}
