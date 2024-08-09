{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # This allows us to set the password manually
  users.mutableUsers = true;
  users.users.gulakov = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "libvirtd"
      "network"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ];

    packages = [pkgs.home-manager];
  };

  home-manager.users.gulakov = import ../../../home/${config.networking.hostName}.nix;

  # To avoid fake failing attempts to login to swaylock
  security.pam.services = {
    swaylock = {};
  };
}
