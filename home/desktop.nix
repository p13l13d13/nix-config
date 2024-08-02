{
  config,
  lib,
  pkgs,
  ...
}: {

  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "sway";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.light.enable = true;
  programs.firefox.enable = true;
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

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

  programs.wofi = {
    enable = true;
    package = pkgs.wofi.overrideAttrs (oa: {
      patches =
        (oa.patches or [])
        ++ [
          ./wofi-run-shell.patch # Fix for https://todo.sr.ht/~scoopta/wofi/174
        ];
    });
    settings = {
      image_size = 48;
      columns = 3;
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
      run-exec_search = true;
      matching = "multi-contains";
    };
  };

  home.packages = let
    inherit (config.programs.password-store) package enable;
  in
    lib.optional enable (pkgs.pass-wofi.override {pass = package;});

    programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${config.fontProfiles.regular.family} 12";
      recolor = true;
      default-bg = "${colors.surface}";
      default-fg = "${colors.surface_bright}";
      statusbar-bg = "${colors.surface_container}";
      statusbar-fg = "${colors.on_surface_variant}";
      inputbar-bg = "${colors.surface}";
      inputbar-fg = "${colors.on_secondary}";
      notification-bg = "${colors.surface}";
      notification-fg = "${colors.on_secondary}";
      notification-error-bg = "${colors.error}";
      notification-error-fg = "${colors.on_error}";
      notification-warning-bg = "${colors.error}";
      notification-warning-fg = "${colors.on_error}";
      highlight-color = "${colors.tertiary}";
      highlight-active-color = "${colors.secondary}";
      completion-bg = "${colors.surface_bright}";
      completion-fg = "${colors.on_surface}";
      completions-highlight-bg = "${colors.secondary}";
      completions-highlight-fg = "${colors.on_secondary}";
      recolor-lightcolor = "${colors.surface}";
      recolor-darkcolor = "${colors.inverse_surface}";
    };
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  home.packages = with pkgs; [
     alacritty
  ]

  fonts.packages = with pkgs; [
     liberatoin_ttf
     fire-code
     fire-code-symbols
     hack-font
     (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
  ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      effect-blur = "20x3";
      fade-in = 0.1;

      font = config.fontProfiles.regular.family;
      font-size = 15;

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 40;
      indicator-idle-visible = true;
      indicator-y-position = 1000;

      ring-color = "${colors.surface_bright}";
      inside-wrong-color = "${colors.on_error}";
      ring-wrong-color = "${colors.error}";
      key-hl-color = "${colors.tertiary}";
      bs-hl-color = "${colors.on_tertiary}";
      ring-ver-color = "${colors.secondary}";
      inside-ver-color = "${colors.on_secondary}";
      inside-color = "${colors.surface}";
      text-color = "${colors.on_surface}";
      text-clear-color = "${colors.on_surface_variant}";
      text-ver-color = "${colors.on_secondary}";
      text-wrong-color = "${colors.on_surface_variant}";
      text-caps-lock-color = "${colors.on_surface_variant}";
      inside-clear-color = "${colors.surface}";
      ring-clear-color = "${colors.primary}";
      inside-caps-lock-color = "${colors.on_tertiary}";
      ring-caps-lock-color = "${colors.surface}";
      separator-color = "${colors.surface}";
    };
  };
}
