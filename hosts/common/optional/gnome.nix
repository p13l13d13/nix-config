{
  pkgs,
  ...
}: {
/*  services = {
    xserver = {
      windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
	      i3status
        i3lock
        i3blocks
         ];
      };
      desktopManager.xterm.enable = false;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
    displayManager.defaultSession = "sway";
  };
*/
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
}
