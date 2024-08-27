{ pkgs, ... }: {

  xsession.enable = true;
  xsession.windowManager.command = "gdm";
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config = { common = { default = [ "gtk" ]; }; };
  };
}
