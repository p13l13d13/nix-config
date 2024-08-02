{pkgs, ...}: {
  imports = [
    ./cli.nix
    ./desktop.nix
    # ./productivity.nix
    # ./hacking.nix
    # ./development.nix
    # ./devops.nix
    ./games.nix
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "p13l13d13";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
  };

  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them

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
    rust-analyzer
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
  ];
}
