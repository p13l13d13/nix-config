{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/p13l13d13
    ../common/optional/pipewire.nix
    ../common/optional/tlp.nix
    ../common/optional/docker.nix
    ../common/optional/gnome.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/fail2ban.nix
   ];

  networking = {
    hostName = "thinky";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };
  
  networking.networkmanager.enable = true;
  powerManagement.powertop.enable = true;
  programs = {
    adb.enable = true;
  };

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  services.thermald.enable = true;
  services.printing.enable = true;
  security.rtkit.enable = true;
  services.libinput.enable = true;
  services.dbus.enable = true;

  programs.dconf.enable = true;

  system.stateVersion = "22.05";
}
