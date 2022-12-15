# Custom NeoVim flake config
This config is based upon [gako358s](https://github.com/Gako358/neovim)
and [jordanisaacs](https://github.com/jordanisaacs/neovim-flake) configs.

## How to use
Remotely with `nix run github:ikerurda/neovim` or from the cloned repository:  
1) Run the app (`nix run`) or build a shell (`nix develop`)
2) Modify the package with the overlay:
```
overlays = [
  neovim.overlays.default
  (final: prev: {
    customNeovim = prev.neovimBuilder {
      config = {
        vim.lsp.enable = false;
      };
    };
  })
];
```
Then just add the package `customNeovim` to `home.packages`

3) Or leave the default configuration:
```
home.packages = with pkgs; [ inputs.neovim.packages."x86_64-linux".default ];
```
4) Or:
```
overlays = [
  neovim.overlays.default
];
```
Then just add the package `neovimKR` to `home.pacages`

## How to update plugins
```
nix flake update
```

## Folder structure
```
.
|-[lib] -- Contains utility functions
|-[modules] -- Contains modules which are used to configure neovim
|-flake.lock -- Lock file
|-flake.nix -- Flake file
|-README.md -- This file
```
