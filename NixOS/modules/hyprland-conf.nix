# Home-manager module that generates ~/.config/hypr/hyprland.conf as a list
# of `source=` lines. Hosts set `hyprland.confSources` to the files they want
# sourced, in order (paths relative to $HOME).
#
# The file is written via an activation script (not home.file) on purpose:
# ambxst and matugen rewrite files in ~/.config/hypr at runtime, so the
# directory can't be a read-only nix store symlink farm.
{ config, lib, ... }:

let
  cfg = config.hyprland.confSources;
in
{
  options.hyprland.confSources = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Files sourced by the generated hyprland.conf, in order, relative to $HOME.";
  };

  config = lib.mkIf (cfg != [ ]) {
    home.activation.writeHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/hypr"
      rm -f "$HOME/.config/hypr/hyprland.conf"
      cat > "$HOME/.config/hypr/hyprland.conf" <<'EOF'
      ${lib.concatMapStrings (p: "source=${config.home.homeDirectory}/${p}\n") cfg}EOF
    '';
  };
}
