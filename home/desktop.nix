{ pkgs, ... }: {
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
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
  programs.wofi = {
    enable = true;
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

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = ''
        alacritty --title "sway-launcher" -e bash -c "dmenu_path | fzf | xargs swaymsg exec --"'';
      bars = [ ];
    };
    extraConfig = ''
      ### Input configuration
      #
      # Example configuration:
      #

      #bindsym Mod4+d alacritty --title "sway-launcher" -e bash -c "dmenu_path | fzf | xargs swaymsg exec --"

      input 'type:keyboard' {
        xkb_layout us,ru,de
        xkb_options caps:swapescape,grp:alt_shift_toggle
      }

      input type:touchpad {
        click_method clickfinger
      }

      #
      # special keys
      #
      bindsym XF86AudioRaiseVolume exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      
      # screen lokc
      bindsym Mod4+o exec swaylock -c 000000

      set $home_monitor DP-2
      set $laptop eDP-1

      bindswitch --reload lid:on output $laptop disable
      bindswitch --reload lid:off output $laptop enable

      output $home_monitor resolution 2560x1440
      output $laptop scale 1.5

      font "Hack 11"

      exec systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
      exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      # setup mako
      exec mako
      exec waybar
      # setup idle
      exec swayidle -w \
      timeout 300 'swaylock -f -c 000000' \
      timeout 301 'swaymsg "output * dpms off"' \
           resume 'swaymsg "output * dpms on"' \
      before-sleep 'swaylock -f -c 000000' \

      # startup redshift
      exec redshift
    '';
  };

  programs.waybar = {
    enable = true;
    style = ''
      @define-color base00 #181818;
      @define-color base01 #282828;
      @define-color base02 #383838;
      @define-color base03 #585858;
      @define-color base04 #b8b8b8;
      @define-color base05 #d8d8d8;
      @define-color base06 #e8e8e8;
      @define-color base07 #f8f8f8;
      @define-color base08 #ab4642;
      @define-color base09 #dc9656;
      @define-color base0A #f7ca88;
      @define-color base0B #a1b56c;
      @define-color base0C #86c1b9;
      @define-color base0D #7cafc2;
      @define-color base0E #ba8baf;
      @define-color base0F #a16946;

      * {
          border: none;
          border-radius: 0;
          font-family: "Hack", sans-serif;
          font-size: 16px;
          min-height: 0;
          transition: none;
          box-shadow: none;
      }

      #waybar {
        color: @base04;
        background: @base01;
      }

      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        margin: 4px 0;
        padding: 0 6px;
        color: @base05;
      }

      #workspaces button.visible {
      }

      #workspaces button.focused {
        border-radius: 4px;
        background-color: @base02;
      }

      #workspaces button.urgent {
        color: rgba(238, 46, 36, 1);
      }

      #tray {
        margin: 4px 16px 4px 4px;
        border-radius: 4px;
        background-color: @base02;
      }

      #tray * {
        padding: 0 6px;
        border-left: 1px solid @base00;
      }

      #tray *:first-child {
        border-left: none;
      }

      #mode, #wireplumber, #battery, #cpu, #memory, #network, #pulseaudio, #idle_inhibitor, #backlight, #custom-storage, #custom-spotify, #custom-weather, #custom-mail, #clock, #temperature {
        margin: 4px 2px;
        padding: 0 6px;
        background-color: @base02;
        border-radius: 4px;
        min-width: 20px;
      }

      #batttery {
        min-width:25px;
      }

      #pulseaudio.muted {
        color: @base0F;
      }

      #pulseaudio.bluetooth {
        color: @base0C;
      }

      #clock {
        margin-left: 4px;
        margin-right: 4px;
        background-color: transparent;
      }

      #temperature.critical {
        color: @base0F;
      }
    '';
    settings = {
      mainBar = {
        layer = "bottom";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "tray"
          "custom/spotify"
          "custom/weather"
          "wireplumber"
          "cpu"
          "memory"
          "temperature"
          "network"
          "battery"
          "clock"
          "sway/language"
        ];
        "sway/mode" = { format = " {}"; };
        "clock" = {
          format = "{:%d.%m.%Y·%H:%M}";
          tooltip = false;
        };
        "sway/window" = {
          max-length = 80;
          tooltip = false;
        };
        "custom/weather" = {
          exec = "~/.config/waybar/scripts/get_weather.sh Berlin+Germany";
          return-type = "json";
          format = "{}";
          tooltip = true;
          interval = 300;
        };
        "wireplumber" = {
          format = "{volume}% ";
          format-muted = "muted ";
          on-click = "helvum";
          max-volume = 150;
          scroll-step = 0.2;
        };
        "cpu" = {
          interval = 15;
          format = "{}% ";
          max-length = 10;
        };
        "memory" = {
          interval = 30;
          format = "{used:0.2f}";
          max-length = 10;
          tooltip = false;
        };
        "battery" = {
          bat = "BAT1";
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
          format-charging = "{capacity}%";
          interval = 30;
          states = {
            warning = 25;
            critical = 10;
          };
          tooltip = false;
        };
        "temperature" = {
          critical-threshold = 80;
          format-critical = "{temperatureC}° ";
          format = "{temperatureC}° ";
        };
        "network" = {
          format = "{icon}";
          format-alt = "{ipaddr}/{cidr} {icon}";
          format-alt-click = "click-right";
          format-icons = {
            wifi = [ "睊" "直" "" ];
            ethernet = [ "" ];
            disconnected = [ "󰖪" ];
          };
          on-click = "alacritty -e nmtui";
          tooltip = false;
        };
        "custom/spotify" = {
          interval = 1;
          return-type = "json";
          exec = "~/.config/waybar/modules/spotify.sh";
          exec-if = "pgrep spotify";
          escape = true;
        };
        tray = { icon-size = 18; };
      };
    };
  };

  home.file.".config/waybar/scripts/get_weather.sh" = {
    source = ./scripts/get_weather.sh;
    executable = true;
  };

  home.file.".config/nvim/" = {
    source = ../init.lua;
    #        recursive = true;
  };

  home.packages = with pkgs; [
    alacritty
    swayidle
    swaylock
    dmenu
    pavucontrol
    qpwgraph
    helvum
    lm_sensors
  ];
}
