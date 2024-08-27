{ pkgs, config, ... }: {
  imports = [
    ./cli.nix
    ./desktop.nix
    # ./productivity.nix
    # ./hacking.nix
    # ./development.nix
    # ./devops.nix
    ./games.nix
    ./firefox.nix
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "gulakov";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    fw-ectool
    nixpkgs-lint
    sqlite
    rustup
    ruff
    pyright
    typescript-language-server
    black
    typst

    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator
    ghidra
    nmap
    metasploit
    gdb
    cutter
    radare2
    vulkan-tools
    pomodoro
    thunderbird
    alacritty
    vscode
    nodejs
    anki
    redshift
    grip
    slurp
    wl-clipboard
    pkgs.intel-media-driver
    keepassxc
    feh
    vim
    gcc
    telegram-desktop
    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.de_DE
    zathura
    nil
    python3
    pulseaudio
    pulseaudio-ctl
    discord
    nixfmt-classic
    killall
    htop
    gopls
    yarn
    libcap
    go
    libinput
    opensnitch
    brightnessctl
    zellij
    vlc
    obsidian
    pciutils
    lm_sensors

    pkgs.nodePackages."bash-language-server"
    pkgs.nodePackages."vscode-langservers-extracted"
  ];
}
