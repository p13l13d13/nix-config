{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/gulakov.nix
    ../common/optional/pipewire.nix
    ../common/optional/tlp.nix
    ../common/optional/docker.nix
    ../common/optional/gnome.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/fail2ban.nix
  ];

  networking = { hostName = "thinky"; };

  fonts.packages = with pkgs; [
    hack-font
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
  ];
  services.flatpak.enable = true; 
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
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.printing.enable = true;
  security.rtkit.enable = true;
  services.libinput.enable = true;
  services.dbus.enable = true;

  programs.dconf.enable = true;

  system.stateVersion = "22.05";
}
