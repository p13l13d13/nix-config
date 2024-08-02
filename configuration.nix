{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Make Nix GREAT AGAIN! 
nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.pathsToLink = [ "/libexec" ];
  environment.variables.EDITOR = "vim";
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-laptop"; # Define your hostname.
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # That's mostly an ugly workaround to avoid bugs with xdg-portal on sway and wayland
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-kde
  ];
  wlr = {
    enable = true;
    settings = { # uninteresting for this problem, for completeness only
      screencast = {
        output_name = "eDP-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };
};

# I mostly use Hack tbh, but let's keep the other ones JUST IN CASE (won't use them in my whole life)
fonts.packages = with pkgs; [
  liberation_ttf
  fira-code
  fira-code-symbols
  hack-font
  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
];

# Enable networking
  networking.networkmanager.enable = true;
  
  # TODO: Automate this. Kinda stupid to change this when I move.
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  # In practice that works quite well for me living in Berlin. However, it's a wierd way to mix this with en_US.UTF-8 in other places.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "sway";
  
  services.thermald.enable = true;
  

  # Good old X-Org when something doesn't work in Wayland.
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru,de";
    xkb.options = "caps:swapescape, grp:alt_shift_toggle";
  };
  programs.dconf.enable = true;
    services.xserver = {

    desktopManager = {
      gnome.enable = true;
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
	i3status
        i3lock
        i3blocks
     ];
    };
  };
 

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gulakov = {
    isNormalUser = true;
    description = "gulakov";
    extraGroups = [ "networkmanager" "wheel" "video"];
    packages = with pkgs; [
      ghidra
      nmap
      metasploit
      gdb
      cutter
      radare2
      vulkan-tools
      pomodoro
      kdePackages.kate
      thunderbird
      neovim
      alacritty
   ];
  };
  
  environment.systemPackages = with pkgs; [
    rust-analyzer
    vscode
    nodejs
    rustup
    rust-analyzer
    lutris
    noto-fonts-emoji-blob-bin
    anki
    bottles
    foliate
    htop
    redshift
    waybar 
    grim
    slurp
    wl-clipboard
    mako
    pkgs.intel-media-driver
    metar
    typst
    keepassxc
    feh
    vim
    git
    gcc
    gnumake
    cmake
    ninja
    python3
    telegram-desktop
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    ripgrep
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
  ];

  programs.bash = { interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.light.enable = true;

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  pkgs.cheese # webcam tool
  gnome-music
  pkgs.gnome-terminal
  pkgs.epiphany # web browser
  pkgs.geary # email reader
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

# This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
