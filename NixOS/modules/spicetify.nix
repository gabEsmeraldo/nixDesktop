{ inputs, pkgs, config, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    
    # Define o tema diretamente do pacote oficial
    theme = spicePkgs.themes.comfy;
    
    # Escolhe o esquema de cores padrão do tema (pode ser "Comfy", "Rose Pine", etc)
    colorScheme = "rose-pine";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
    ];

    enabledCustomApps = [
      spicePkgs.apps.marketplace
      spicePkgs.apps."lyricsPlus"
    ];
  };
}
