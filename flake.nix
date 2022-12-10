{
  description = "NeoVim config by @keros";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Dependencies
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # LSP
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=v0.1.3";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-refactor = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor";
      flake = false;
    };
    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };

    # Autocomplete
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-nvim-lsp-signature = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };
    cmp-calc = {
      url = "github:hrsh7th/cmp-calc";
      flake = false;
    };
    cmp-spell = {
      url = "github:f3fora/cmp-spell";
      flake = false;
    };
    cmp-digraphs = {
      url = "github:dmitmel/cmp-digraphs";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    leap = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    surround = {
      url = "github:ur4ltz/surround.nvim";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-file-browser = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };
    telescope-project = {
      url = "github:ikerurda/telescope-project.nvim";
      flake = false;
    };
    telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    telescope-symbols = {
      url = "github:nvim-telescope/telescope-symbols.nvim";
      flake = false;
    };

    # Statusline
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    # Themes
    github-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };
    base16 = {
      url = "github:RRethy/nvim-base16";
      flake = false;
    };

    # Visuals
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    neogit = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";

    # Plugin must be same as input name
    plugins = [
      "plenary-nvim"
      "nvim-lspconfig"
      "nvim-treesitter"
      "nvim-treesitter-refactor"
      "nvim-treesitter-textobjects"
      "nvim-treesitter-context"
      "nvim-lightbulb"
      "nvim-code-action-menu"
      "lsp-signature"
      "null-ls"
      "sqls-nvim"
      "telescope"
      "telescope-file-browser"
      "telescope-project"
      "telescope-ui-select"
      "telescope-symbols"
      "lualine"
      "nvim-cmp"
      "cmp-buffer"
      "cmp-nvim-lsp"
      "cmp-nvim-lsp-signature"
      "cmp-path"
      "cmp-calc"
      "cmp-spell"
      "cmp-digraphs"
      "cmp-luasnip"
      "luasnip"
      "friendly-snippets"
      "lspkind"
      "nvim-autopairs"
      "comment"
      "leap"
      "surround"
      "dressing"
      "colorizer"
      "github-theme"
      "base16"
      "nvim-cursorline"
      "indent-blankline"
      "gitsigns-nvim"
      "neogit"
      "glow-nvim"
    ];

    pluginOverlay = lib.buildPluginOverlay;

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [ pluginOverlay ];
    };

    lib =
      import
      ./lib
      {inherit pkgs inputs plugins;};

    neovimBuilder = lib.neovimBuilder;

    configBuilder = isMaximal: {
      config = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
          formatOnSave = false;
          lightbulb.enable = true;
          nvimCodeActionMenu.enable = true;
          lspSignature.enable = true;
          nix = true;
          python = isMaximal;
          clang.enable = isMaximal;
          sql = isMaximal;
          ts = isMaximal;
        };
        vim.visuals = {
          enable = true;
          lspkind = true;
          guides = {
            enable = true;
            listChar = "│";
            fillChar = "";
            eolChar = "↴";
            hiContext = true;
          };
        };
        vim.statusline = {
          enable = true;
          theme = "base16";
        };
        vim.theme = {
          enable = true;
          name = "custom";
        };
        vim.completion = {
          enable = true;
          autopairs = true;
        };
        vim.treesitter = {
          enable = true;
        };
        vim.telescope = {
          enable = true;
          file-browser = true;
          project = true;
          ui-select = true;
          symbols = true;
        };
        vim.git = {
          enable = true;
          signs = true;
          neogit = true;
        };
      };
    };
  in rec {
    # $ nix run
    apps.${system} = rec {
      nvim = {
        type = "app";
        program = "${packages.${system}.default}/bin/nvim";
      };
      default = nvim;
    };

    # $ nix develop
    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = [(neovimBuilder (configBuilder false))];
      };
    };

    overlays.default = final: prev: {
      inherit neovimBuilder;
      neovimKR = packages.${system}.neovimKR;
      neovimPlugins = pkgs.neovimPlugins;
    };

    packages.${system} = rec {
      default = neovimKR;
      neovimKR = neovimBuilder (configBuilder true);
    };
  };
}
