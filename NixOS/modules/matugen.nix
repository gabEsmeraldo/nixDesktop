# modules/matugen.nix
{ pkgs, inputs, ... }: {
  # Install the matugen package
  home.packages = [ 
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default 
  ];

  # Manually create the config file Matugen expects
  xdg.configFile."matugen/config.toml".text = ''
  [config]
  variant = "dark"

  [templates.kitty]
  input_path = '${../templates/kitty.conf}'
  output_path = '~/.config/kitty/colors.conf'
  post_hook = 'pkill -SIGUSR1 kitty'

  [templates.ghostty]
  input_path = '${../templates/ghostty.conf}'
  output_path = '~/.config/ghostty/themes/matugen'
  # Ghostty 1.2.0+ reloads config on SIGUSR2 (PR #7759).
  post_hook = 'pkill -SIGUSR2 ghostty || true'

'';
}


  # [templates.vencord]
  # input_path = '${../templates/vencord.css}'
  # output_path = '~/.config/vesktop/themes/matugen.css'