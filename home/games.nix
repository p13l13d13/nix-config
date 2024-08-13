{ pkgs, ... }: {

  home.packages = with pkgs; [
    # wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    mangohud
    vkbasalt-cli
    gamescope
    goverlay
    lutris
  ];
}
