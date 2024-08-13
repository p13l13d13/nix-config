{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/gulakov.nix
    ../common/optional/pipewire.nix
    ../common/optional/docker.nix
    ../common/optional/gnome.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/fail2ban.nix
  ];

  networking = { hostName = "frame"; };

  fonts.packages = with pkgs; [
    hack-font
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
  ];

  programs.sway.enable = true;
  programs.sway.package = null;

  networking.networkmanager.enable = true;
  powerManagement.powertop.enable = true;
  programs = {
    adb.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };
  services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      desktopManager.xterm.enable = false;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.sessionPackages = [
    ((
			pkgs.writeTextDir "share/wayland-sessions/sway.desktop" ''[Desktop Entry]
Name=Sway
Comment=Sway run from a login shell
Exec=${pkgs.dbus}/bin/dbus-run-session -- bash -l -c sway
Type=Application''
    ).overrideAttrs (oldAttrs: {
      passthru = {
        providedSessions = ["sway"];
      };
    })
    )
  ];
    displayManager.gdm = {
        enable = true;
      };
    displayManager.defaultSession = "gnome";
  };

  services.thermald.enable = true;
  services.printing.enable = true;
  security.rtkit.enable = true;
  services.libinput.enable = true;
  services.libinput.touchpad.clickMethod = "clickfinger";
  services.dbus.enable = true;

  programs.dconf.enable = true;

  system.stateVersion = "22.05";
}
