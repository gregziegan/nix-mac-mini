{ config, pkgs, lib, devenv, fenix, ... }:

{
  home.stateVersion = "22.05";

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "~/.config/nix/rebuild";
      switch = "~/.config/nix/switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      source ~/.config/op/plugins.sh
      source ~/.config/nix/shell-config/zellij-completions.zsh
      export EDITOR=vim
    '';

    plugins = [
       {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };

  home.packages = with pkgs; [
    # Some basics
    coreutils
    curl
    wget

    # Dev stuff
    _1password
    jq
    nodePackages.typescript
    nodejs
    fenix.packages."aarch64-darwin".minimal.toolchain # rust
    git-absorb
    python311
    python311Packages.pytest
    python311Packages.black
    dhall
    dhall-lsp-server
    dhall-json
    gh
    zellij

    # Useful nix related tools
    nixpkgs-fmt
    nil

    devenv.packages.aarch64-darwin.devenv
    cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    nodePackages.node2nix

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
  ];

}
