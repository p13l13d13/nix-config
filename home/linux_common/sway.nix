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

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = "
      monitor=,preferred,auto,auto
      monitor=DP-2,preferred,auto,auto
      monitor=eDP-1,preferred,auto,auto
      xwayland {
        force_zero_scaling = true
      }
    ";
     settings = {
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        "wl-clip-persist --clipboard both"
        "hyprctl setcursor Nordzy-cursors 22 &"
        "waybar &"
        "hyprlock"
      ];

      general = {
        allow_tearing = true;
        layout = "dwindle";
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";
        "col.inactive_border" = "0x00000000";
        border_part_of_window = false;
        no_border_on_floating = false;
      };

      misc = {
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = false;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = false;
        };

        drop_shadow = false;
      };

      animations = {
        enabled = false;
      };

      input = {
        kb_layout = "us,ru";
        kb_options ="grp:alt_caps_toggle,caps:swapescape"; 
        follow_mouse = 1;
        sensitivity = 0.2;
        touchpad = {
          middle_button_emulation = true;
          natural_scroll = true;
        };
      };
      "$mainMod" = "SUPER";
          bind = [
        # show keybinds list
        "$mainMod, F1, exec, show-keybinds"

        # keybindings
        "$mainMod, Return, exec, alacritty"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, togglefloating,"
        "$mainMod, D, exec, alacritty --title \"launcher\" -e bash -c \"dmenu_path | fzf | xargs swaymsg exec --\""
        "$mainMod, Escape, exec, swaylock"
        "$mainMod SHIFT, Escape, exec, shutdown-script"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, E, exec, nautilus"
        "$mainMod SHIFT, B, exec, pkill -SIGUSR1 .waybar-wrapped"
        "$mainMod, C ,exec, hyprpicker -a"

        # screenshot
        "$mainMod, Print, exec, grimblast --notify --cursor --freeze save area ~/Pictures/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
        ",Print, exec, grimblast --notify --cursor --freeze copy area"

        # switch focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # switch workspace
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # same as above, but switch to the workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod CTRL, c, movetoworkspace, empty"

        # window control
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod CTRL, left, resizeactive, -80 0"
        "$mainMod CTRL, right, resizeactive, 80 0"
        "$mainMod CTRL, up, resizeactive, 0 -80"
        "$mainMod CTRL, down, resizeactive, 0 80"
        "$mainMod ALT, left, moveactive,  -80 0"
        "$mainMod ALT, right, moveactive, 80 0"
        "$mainMod ALT, up, moveactive, 0 -80"
        "$mainMod ALT, down, moveactive, 0 80"

        # media and volume controls
        ",XF86AudioRaiseVolume,exec, pamixer -i 2"
        ",XF86AudioLowerVolume,exec, pamixer -d 2"
        ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"
        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        # laptop brigthness
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
             ];
      bindl = [
       ", switch:off:Lid, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:on:Lid, exec, hyprctl keyword monitor \"eDP-1, enable\""
      ];
    };
 };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    DISABLE_QT5_COMPAT = "0";
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_THEME = "Dracula";
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
      default_border none
      default_floating_border none
      titlebar_padding 1
      titlebar_border_thickness 0      

      input 'type:keyboard' {
        xkb_layout us,ru,de
        xkb_options caps:swapescape,grp:alt_shift_toggle
      }

      input 2362:628:PIXA3854:00_093A:0274_Touchpad {
        dwt enabled
        tap enabled
        middle_emulation enabled
        click_method clickfinger
        accel_profile adaptive
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
         timeout 300 'swaylock --hide-keyboard-layout -f -c 000000' \
         timeout 600 'swaymsg "output * dpms off"' \
         resume 'swaymsg "output * dpms on"' \
         after-resume 'swaymsg "output * enable"' \
         before-sleep 'swaylock --hide-keyboard-layout -f -c 000000 -i'

      # startup redshift
      exec redshift -l 52.5:13.4
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
        modules-left = [ "hyprland/workspaces"];
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
        "clock" = {
          format = "{:%d.%m.%Y·%H:%M}";
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

  home.packages = with pkgs; [
    swayidle
    swaylock
    dmenu
  ];
}
