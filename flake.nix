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
    nvim-treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
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
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Autocomplete
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    # Commenting
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Statusline
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Themes
    github-theme = {
      url = "github:projekt0n/github-nvim-theme";
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
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
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
      "lspkind"
      "nvim-treesitter-context"
      "nvim-lightbulb"
      "nvim-code-action-menu"
      "lsp-signature"
      "null-ls"
      "sqls-nvim"
      "telescope"
      "lualine"
      "nvim-cmp"
      "cmp-buffer"
      "cmp-nvim-lsp"
      "cmp-vsnip"
      "cmp-path"
      "cmp-treesitter"
      "vim-vsnip"
      "nvim-autopairs"
      "kommentary"
      "todo-comments"
      "github-theme"
      "nvim-cursorline"
      "indent-blankline"
      "gitsigns-nvim"
      "glow-nvim"
    ];

    pluginOverlay = lib.buildPluginOverlay;

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        pluginOverlay
        (final: prev: {
          rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
        })
      ];
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
          formatOnSave = true;
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
          lspkind.enable = true;
          indentBlankline = {
            enable = true;
            fillChar = "";
            eolChar = "";
            showCurrContext = true;
          };
          cursorWordline = {
            enable = true;
            lineTimeout = 0;
          };
        };
        vim.statusline.lualine = {
          enable = true;
          theme = "github-theme";
        };
        vim.theme = {
          enable = true;
          name = "github-theme";
          style = "dark_default";
        };
        vim.completion = {
          enable = true;
          autopairs = true;
        };
        vim.treesitter = {
          enable = true;
          context.enable = true;
        };
        vim.telescope = {
          enable = true;
        };
        vim.markdown = {
          enable = true;
          glow.enable = true;
        };
        vim.git = {
          enable = true;
          gitsigns.enable = true;
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
