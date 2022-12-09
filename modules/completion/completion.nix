{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.completion;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  addIf = cond: pkg:
    if cond
    then pkg
    else null;
in {
  options.vim.completion = {
    enable = mkEnableOption "completion";
    snippets = mkEnableOption "snippets";
    autopairs = mkEnableOption "autopairing";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-spell
      cmp-digraphs
      (addIf config.vim.lsp.enable cmp-nvim-lsp)
      (addIf config.vim.lsp.enable cmp-nvim-lsp-signature)
      (addIf cfg.snippets luasnip)
      (addIf cfg.snippets friendly-snippets)
      (addIf cfg.snippets cmp-luasnip)
      (addIf cfg.autopairs nvim-autopairs)
    ];

    vim.luaConfigRC = ''
      local cmp = require "cmp"
    ${writeIf config.vim.visuals.lspkind.enable ''
      local kind = require "lspkind"
    ''}
    ${writeIf cfg.snippets ''
      local lsnip = require "luasnip"
    ''}
      cmp.setup {
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
        ${writeIf config.vim.lsp.enable ''
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
        ''}
        ${writeIf cfg.snippets ''
          { name = "luasnip" },
        ''}
          { name = "buffer", keyword_lenght = 5 },
          { name = "path" },
          { name = "digraphs" },
          { name = "calc" },
          { name = "spell" },
        },
        formatting = {
          format = ${writeIf config.vim.visuals.lspkind.enable ''require"lspkind".cmp_format''} {
            with_text = true,
            menu = {
            ${writeIf config.vim.lsp.enable ''
              nvim_lsp = "[LSP]",
              nvim_lsp_signature_help = "[LSP]",
            ''}
            ${writeIf cfg.snippets ''
              luasnip = "[snip]",
            ''}
              buffer = "[buf]",
              path = "[path]",
              digraphs = "[dig]",
              calc = "[calc]",
              spell = "[spell]",
            },
          },
        },
      ${writeIf cfg.snippets ''
        snippet = {
          expand = function(args)
            lsnip.lsp_expand(args.body)
          end,
        },
      ''}
        experimental = { ghost_text = true },
      }

    ${writeIf cfg.snippets ''
      lsnip.config.set_config {
        history = true,
        update_events = "TextChanged,TextChangedI",
      }

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
      lsnip.add_snippets("lua", {
        snp(
          "req",
          fmt('local {} = require "{}"', {
            fun(function(name)
              local parts = vim.split(name[1][1], ".", true)
              return parts[#parts] or ""
            end, { 1 }),
            ins(1),
          })
        ),
        snp("todo", fmt("{}", { cho(1, { txt "-- TODO: ", txt "-- FIXME: " }) })),
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

    ${writeIf cfg.autopairs ''
      local pairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", pairs.on_confirm_done { map_char = { tex = "" } })
      require("nvim-autopairs").setup {
        ${writeIf config.vim.treesitter.enable ''check_ts = true,''}
        enable_moveright = false,
        fast_wrap = {},
      }
    ''}
    '';
  };
}
