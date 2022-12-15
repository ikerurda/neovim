# Custom NeoVim flake config
This config is based upon [gako358s](https://github.com/Gako358/neovim)
and [jordanisaacs](https://github.com/jordanisaacs/neovim-flake) configs.

## How to use
1. Remotely: `nix run github:ikerurda/neovim`
2. From the cloned repository:
a) `nix run` runs the app and `nix develop` bulds the shell
b) You can also modify the package with the overlay:
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
Then just add the package `customNeovim` to `home.pacages`

c). Or you could leave the default configuration:
```
home.packages = with pkgs; [ inputs.neovim.packages."x86_64-linux".default ];
```
or

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
