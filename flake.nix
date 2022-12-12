{
  description = "NeoVim config by @keros";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Dependencies
    impatient = {
      url = "github:lewis6991/impatient.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };

    # LSP
    lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=v0.1.3";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };

    # Autocomplete
    cmp = {
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
    cmp-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-lsp-signature = {
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
    autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    # Treesitter
    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    treesitter-refactor = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor";
      flake = false;
    };
    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
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

    # Tools
    neogit = {
      url = "github:TimUntersberger/neogit";
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

    # Statusline
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    # Themes
    base16 = {
      url = "github:RRethy/nvim-base16";
      flake = false;
    };

    # Visuals
    cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
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
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";

    # Plugin must be same as input name
    plugins = [
      "impatient"
      "plenary"
      "repeat"
      "lspconfig"
      "null-ls"
      "lsp-signature"
      "code-action-menu"
      "cmp"
      "cmp-buffer"
      "cmp-path"
      "cmp-lsp"
      "cmp-lsp-signature"
      "cmp-calc"
      "cmp-spell"
      "cmp-digraphs"
      "cmp-luasnip"
      "luasnip"
      "friendly-snippets"
      "lspkind"
      "autopairs"
      "treesitter"
      "treesitter-refactor"
      "treesitter-textobjects"
      "treesitter-context"
      "telescope"
      "telescope-file-browser"
      "telescope-project"
      "telescope-ui-select"
      "telescope-symbols"
      "neogit"
      "comment"
      "leap"
      "surround"
      "lualine"
      "base16"
      "cursorline"
      "indent-blankline"
      "gitsigns"
      "dressing"
      "colorizer"
    ];

    pluginOverlay = lib.buildPluginOverlay;

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [ pluginOverlay ];
    };

    lib = import ./lib {inherit pkgs inputs plugins;};

    neovimBuilder = lib.neovimBuilder;

    configBuilder = isMaximal: {
      config = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
          formatOnSave = false;
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
