{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    progress = mkOption {
      description = "Whether to enable progress indicators";
      type = types.bool;
    };
    formatOnSave = mkOption {
      description = "Whether to enable automatic formatting";
      type = types.bool;
    };
    languages = {
      nix = mkOption {
        description = "Whether to enable the nix language server";
        type = types.bool;
      };
      c = mkOption {
        description = "Whether to enable the c language server";
        type = types.bool;
      };
      ts = mkOption {
        description = "Whether to enable the typescript language server";
        type = types.bool;
      };
      py = mkOption {
        description = "Whether to enable the python language server";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      lspconfig
      null-ls
    ]
    ++ (optional config.vim.completion.enable cmp-lsp);

    vim.configRC = ''
      local attach_keymaps = function(client, bufnr)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = true })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = true })
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = true })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = true })
        vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = true })
        vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, { buffer = true })
        vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { buffer = true })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
        vim.keymap.set({ "n", "i" }, "<c-s>", vim.lsp.buf.signature_help, { buffer = true })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = true })
        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = true })
        vim.keymap.set("v", "<leader>cf", vim.lsp.buf.range_formatting, { buffer = true })
      end

      local null = require("null-ls")
      local null_helpers = require("null-ls.helpers")
      local null_methods = require("null-ls.methods")

      local ls_sources = {
      ${optionalString cfg.languages.nix ''
        null.builtins.formatting.alejandra.with({
          command = "${pkgs.alejandra}/bin/alejandra"
        }),
      ''}
      ${optionalString cfg.languages.py ''
        null.builtins.formatting.black.with({
          command = "${pkgs.black}/bin/black",
        }),
      ''}
      ${optionalString cfg.languages.ts ''
        null.builtins.diagnostics.eslint,
        null.builtins.formatting.prettier,
      ''}
      }

      format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            local params = require("vim.lsp.util").make_formatting_params({})
            client.request("textDocument/formatting", params, nil, bufnr)
          end
        })
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
      ${optionalString cfg.formatOnSave ''
        format_callback(client, bufnr)
      ''}
      end

      require("null-ls").setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
        on_attach = default_on_attach,
      })

      local lspconfig = require("lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
    ${optionalString config.vim.completion.enable ''
      capabilities = require("cmp_nvim_lsp").default_capabilities()
    ''}
    ${optionalString (config.vim.completion.enable && config.vim.completion.snippets) ''
      capabilities.textDocument.completion.completionItem.snippetSupport = true
    ''}

    ${optionalString cfg.languages.nix ''
      lspconfig.rnix.setup({
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
      })
    ''}

    ${optionalString cfg.languages.c ''
      vim.g.c_syntax_for_h = true
      lspconfig.ccls.setup({
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { "${pkgs.ccls}/bin/ccls" },
      })
    ''}

    ${optionalString cfg.languages.ts ''
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
      })
    ''}

    ${optionalString cfg.languages.py ''
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { "${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio" },
      })
    ''}
    '';
  };
}
