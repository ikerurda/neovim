{
  inputs,
  plugins,
  ...
}: final: prev:
with builtins;
let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = getAttr name inputs;
    };
in {
  neovimPlugins =
    listToAttrs (map (name:
      {
        inherit name;
        value = buildPlug name;
      }
    ) plugins);
}
