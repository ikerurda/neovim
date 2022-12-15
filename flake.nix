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
    lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
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
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    # Snippets
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
    telescope-lsp-handlers = {
      url = "github:slotos/telescope-lsp-handlers.nvim";
      flake = false;
    };

    # Tools
    neogit = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
    leap = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    # Statusline
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    lsp-progress = {
      url = "github:arkav/lualine-lsp-progress";
      flake = false;
    };

    # Themes
    base16 = {
      url = "github:RRethy/nvim-base16";
      flake = false;
    };

    # Visuals
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs:
  with builtins;
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [lib.buildPluginOverlay];
    };

    plugins = filter (input: input != "nixpkgs") (attrNames inputs);
    lib = import ./lib {inherit pkgs inputs plugins;};

    inherit (lib) neovimBuilder;
    configBuilder = { config = {}; };
  in rec {
    # $ nix run
    apps.${system} = {
      default = {
        type = "app";
        program = "${packages.${system}.default}/bin/nvim";
      };
    };

    # $ nix develop
    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = [(neovimBuilder configBuilder)];
      };
    };

    overlays.default = final: prev: {
      inherit neovimBuilder;
      neovimKR = packages.${system}.default;
      neovimPlugins = pkgs.neovimPlugins;
    };

    packages.${system} = {
      default = neovimBuilder configBuilder;
    };
  };
}
