{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    formatOnSave = mkEnableOption "Format on save";
    nix = mkEnableOption "Nix LSP";
    python = mkEnableOption "Python LSP";
    clang = {
      enable = mkEnableOption "C language LSP";
      c_header = mkEnableOption "C syntax header files";
      cclsOpts = mkOption {
        type = types.str;
        default = "";
      };
    };
    sql = mkEnableOption "SQL Language LSP";
    ts = mkEnableOption "TS language LSP";
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins;
        [
          lspconfig
          null-ls
          (
            if (config.vim.completion.enable)
            then cmp-lsp
            else null
          )
        ];

      vim.configRC = ''
        ${
          if cfg.nix
          then ''
            autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
          ''
          else ""
        }

        ${
          if cfg.clang.c_header
          then ''
            " c syntax for header (otherwise breaks treesitter highlighting)
            " https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
            let g:c_syntax_for_h = 1
          ''
          else ""
        }
      '';
      vim.luaConfigRC = ''

        local attach_keymaps = function(client, bufnr)
          local opts = { noremap=true, silent=true }

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        end

        local null_ls = require("null-ls")
        local null_helpers = require("null-ls.helpers")
        local null_methods = require("null-ls.methods")

        local ls_sources = {
          ${writeIf cfg.python
          ''
            null_ls.builtins.formatting.black.with({
              command = "${pkgs.black}/bin/black",
            }),
          ''}
          -- Commented out for now
          --${writeIf (config.vim.git.enable && config.vim.git.signs) ''
          --  null_ls.builtins.code_actions.gitsigns,
          --''}
          ${writeIf cfg.sql
          ''
            null_helpers.make_builtin({
              method = null_methods.internal.FORMATTING,
              filetypes = { "sql" },
              generator_opts = {
                to_stdin = true,
                ignore_stderr = true,
                suppress_errors = true,
                command = "${pkgs.sqlfluff}/bin/sqlfluff",
                args = {
                  "fix",
                  "-",
                },
              },
              factory = null_helpers.formatter_factory,
            }),

            null_ls.builtins.diagnostics.sqlfluff.with({
              command = "${pkgs.sqlfluff}/bin/sqlfluff",
              extra_args = {"--dialect", "postgres"}
            }),
          ''}
          ${writeIf cfg.nix
          ''
            null_ls.builtins.formatting.alejandra.with({
              command = "${pkgs.alejandra}/bin/alejandra"
            }),
          ''}

          ${writeIf cfg.ts
          ''
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.prettier,
          ''}
        }

        vim.g.formatsave = ${
          if cfg.formatOnSave
          then "true"
          else "false"
        };

        -- Enable formatting
        format_callback = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.formatsave then
                  local params = require'vim.lsp.util'.make_formatting_params({})
                  client.request('textDocument/formatting', params, nil, bufnr)
              end
            end
          })
        end

        default_on_attach = function(client, bufnr)
          attach_keymaps(client, bufnr)
          format_callback(client, bufnr)
        end

        -- Enable null-ls
        require('null-ls').setup({
          diagnostics_format = "[#{m}] #{s} (#{c})",
          debounce = 250,
          default_timeout = 5000,
          sources = ls_sources,
          on_attach=default_on_attach
        })

        -- Enable lspconfig
        local lspconfig = require('lspconfig')

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        ${writeIf config.vim.completion.enable ''
          capabilities = require('cmp_nvim_lsp').default_capabilities()
	'' }

        ${writeIf cfg.python ''
          -- Python config
          lspconfig.pyright.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
          }
        ''}

        ${writeIf cfg.nix ''
          -- Nix config
          lspconfig.rnix.setup{
            capabilities = capabilities;
            on_attach = function(client, bufnr)
              attach_keymaps(client, bufnr)
            end,
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
          }
        ''}

        ${writeIf cfg.clang.enable ''
          -- CCLS (clang) config
          lspconfig.ccls.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.ccls}/bin/ccls"};
            ${
            if cfg.clang.cclsOpts == ""
            then ""
            else "init_options = ${cfg.clang.cclsOpts}"
          }
          }
        ''}

        ${writeIf cfg.ts ''
          -- TS config
          lspconfig.tsserver.setup {
            capabilities = capabilities;
            on_attach = function(client, bufnr)
              attach_keymaps(client, bufnr)
            end,
            cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
          }
        ''}
      '';
    }
  );
}
