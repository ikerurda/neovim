{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.telescope;
in {
  options.vim.telescope = {
    enable = mkEnableOption "telescope";
    file-browser = mkOption {
      description = "Whether to enable telescope file browser";
      type = types.bool;
    };
    project = mkOption {
      description = "Whether to enable telescope project";
      type = types.bool;
    };
    ui-select = mkOption {
      description = "Whether to enable telescope ui select";
      type = types.bool;
    };
    symbols = mkOption {
      description = "Whether to enable telescope symbols";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      telescope
    ]
    ++ (optional cfg.file-browser telescope-file-browser)
    ++ (optional cfg.project telescope-project)
    ++ (optional cfg.ui-select telescope-ui-select)
    ++ (optional cfg.symbols telescope-symbols);

    vim.luaConfigRC = ''
    ${optionalString cfg.file-browser ''
      local action_state = require("telescope.actions.state")
      local builtin = require("telescope.builtin")
      local open_in = function(finder)
        return function()
          local entry_path = action_state.get_selected_entry().Path
          local path = entry_path:is_dir() and entry_path:absolute()
              or entry_path:parent():absolute()
          finder({ cwd = path })
        end
      end
      local open_in_fb = function()
        local Path = require "plenary.path"
        local fb = require("telescope").extensions.file_browser.file_browser
        local entry_path = Path:new(action_state.get_selected_entry()[1])
        local path = entry_path:parent():absolute()
        fb({ path = path })
      end
    ''}

      local actions = require("telescope.actions")
      local layout_actions = require("telescope.actions.layout")
      local telescope = require("telescope")
      telescope.setup({
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
        ${optionalString cfg.file-browser ''
          oldfiles = { mappings = { i = { ["<a-e>"] = open_in_fb } } },
          find_files = { mappings = { i = { ["<a-e>"] = open_in_fb } } },
        ''}
        ${optionalString config.vim.lsp.enable ''
          diagnostics = { theme = "cursor", previewer = false },
        ''}
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
            mappings = { i = { ["<c-d>"] = "delete_buffer" } },
          },
        },
        extensions = {
        ${optionalString cfg.file-browser ''
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
        ${optionalString cfg.project ''
          project = { theme = "dropdown", browse_by_default = true },
        ''}
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles)
      vim.keymap.set('n', '<leader>ft', builtin.resume)
      vim.keymap.set('n', '<leader>fb', builtin.buffers)
      vim.keymap.set('n', '<leader>ff', builtin.find_files)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep)
      vim.keymap.set('n', '<leader>fs', builtin.grep_string)
      vim.keymap.set('n', '<leader>fg', builtin.help_tags)
      vim.keymap.set('n', '<leader>fm', builtin.man_pages)

      local extensions = require("telescope").extensions
    ${optionalString cfg.symbols ''
      vim.keymap.set("n", "<leader>fv", builtin.symbols)
    ''}
    ${optionalString config.vim.lsp.enable ''
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
    ''}
    ${optionalString cfg.file-browser ''
      telescope.load_extension("file_browser")
      vim.keymap.set("n", "<leader>fe", extensions.file_browser.file_browser)
    ''}
    ${optionalString cfg.project ''
      telescope.load_extension("project")
      vim.keymap.set("n", "<leader>fj", extensions.project.project)
    ''}
    ${optionalString cfg.ui-select ''
      telescope.load_extension("ui-select")
    ''}
    '';
  };
}
