{ config, pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Powerlevel10k instant prompt logic [cite: 1, 3, 4]
    initContent = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      # Suggest corrections for typos
      setopt CORRECT
      # Make cd push old directory onto stack
      setopt AUTO_PUSHD
      # Don't push duplicates
      setopt PUSHD_IGNORE_DUPS
      # Don't find duplicates in history
      setopt HIST_FIND_NO_DUPS

      # Powerlevel10k configuration 
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Zoxide initialization
      # eval "$(zoxide init zsh)"
    '';

    # History settings
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
      share = true;
    };

    # Shell options (setopt)
    autocd = true; # cd by typing directory name
    completionInit = ''
      # Enable completion caching
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache
    '';

    # Oh-My-Zsh configuration [cite: 5, 20]
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" # 
      ];
    };

    # Plugins managed via Nix (more reliable than OMZ for these specific ones) 
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    # Personal Aliases [cite: 23, 25]
    shellAliases = {
      #Nix
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/NixOS#asphodelus";
      clearBuilds = "sudo nix-collect-garbage -d";

      # System shortcuts
      ff = "fastfetch";
      # Syu = "yay --answerclean N --answerdiff N";

      # Navigation
      cd = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
      fe = "yazi";

      # Zoxide enhancements
      zi = "zoxide query -i";
      za = "zoxide add";

      # Color support
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ip = "ip -color=auto";

      # Git shortcuts 
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";

      # Server connection
      server = "cd Downloads && ssh -i ssh-key-2025-10-14.key ubuntu@136.248.108.180";
    };

    # Additional initialization 
  #   initContent = ''
  #     # Suggest corrections for typos
  #     setopt CORRECT
  #     # Make cd push old directory onto stack
  #     setopt AUTO_PUSHD
  #     # Don't push duplicates
  #     setopt PUSHD_IGNORE_DUPS
  #     # Don't find duplicates in history
  #     setopt HIST_FIND_NO_DUPS

  #     # Powerlevel10k configuration 
  #     [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
  #     # Zoxide initialization
  #     # eval "$(zoxide init zsh)"
  #   '';
  };
}