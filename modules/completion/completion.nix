{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.strings;
let cfg = config.vim.completion;
in {
  options.vim.completion = {
    enable = mkEnableOption "completion";
    snippets = mkOption {
      description = "Whether to enable snippets completion";
      type = types.bool;
    };
    autopairs = mkOption {
      description = "Whether to enable autopairing";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      cmp
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-spell
    ]
    ++ (optionals config.vim.lsp.enable [cmp-lsp cmp-lsp-signature])
    ++ (optionals cfg.snippets [luasnip friendly-snippets cmp-luasnip])
    ++ (optional cfg.autopairs autopairs);

    vim.configRC = ''
      local cmp = require("cmp")
    ${optionalString config.vim.visuals.lspkind ''
      local kind = require("lspkind")
    ''}
    ${optionalString cfg.snippets ''
      local lsnip = require("luasnip")
    ''}
      cmp.setup({
        mapping = {
          ["<c-space>"] = cmp.mapping.complete(),
          ["<c-c>"] = cmp.mapping.close(),
          ["<c-n>"] = cmp.mapping.select_next_item(),
          ["<c-p>"] = cmp.mapping.select_prev_item(),
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
          ["<cr>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          },
        },
        sources = {
        ${optionalString config.vim.lsp.enable ''
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
        ''}
        ${optionalString cfg.snippets ''
          { name = "luasnip" },
        ''}
          { name = "buffer", keyword_lenght = 5 },
          { name = "path" },
          { name = "calc" },
          { name = "spell" },
        },
        formatting = {
          format = ${optionalString config.vim.visuals.lspkind ''require("lspkind").cmp_format''} {
            with_text = true,
            menu = {
            ${optionalString config.vim.lsp.enable ''
              nvim_lsp = "[LSP]",
              nvim_lsp_signature_help = "[LSP]",
            ''}
            ${optionalString cfg.snippets ''
              luasnip = "[snip]",
            ''}
              buffer = "[buf]",
              path = "[path]",
              calc = "[calc]",
              spell = "[spell]",
            },
          },
        },
      ${optionalString cfg.snippets ''
        snippet = {
          expand = function(args)
            lsnip.lsp_expand(args.body)
          end,
        },
      ''}
        experimental = { ghost_text = true },
      })

    ${optionalString cfg.snippets ''
      lsnip.config.set_config({
        history = true,
        update_events = "TextChanged,TextChangedI",
      })

      local snp, ins = lsnip.snippet, lsnip.insert_node
      local fmt = require("luasnip.extras.fmt").fmt
      local fun, cho, txt = lsnip.function_node, lsnip.choice_node, lsnip.text_node
      local rep = require("luasnip.extras").rep
      require("luasnip.loaders.from_vscode").lazy_load()
      lsnip.filetype_extend("javascript", { "javascriptreact" })
      lsnip.filetype_extend("javascript", { "html" })
      lsnip.filetype_extend("php", { "html" })
      lsnip.add_snippets("all", {
        snp(
          "curtime",
          fun(function()
            return os.date "%D - %H:%M"
          end)
        ),
      })

      local map = vim.keymap.set
      map({ "i", "s" }, "<c-j>", function()
        if lsnip.expand_or_jumpable() then
          lsnip.expand_or_jump()
        end
      end)
      map({ "i", "s" }, "<c-k>", function()
        if lsnip.jumpable(-1) then
          lsnip.jump(-1)
        end
      end)
      map({ "i", "s" }, "<c-l>", function()
        if lsnip.choice_active() then
          lsnip.change_choice(1)
        end
      end)
    ''}

    ${optionalString cfg.autopairs ''
      local pairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", pairs.on_confirm_done({ map_char = { tex = "" } }))
      require("nvim-autopairs").setup({
      ${optionalString config.vim.treesitter.enable ''
        check_ts = true,
      ''}
        enable_moveright = false,
        fast_wrap = {},
      })
    ''}
    '';
  };
}
