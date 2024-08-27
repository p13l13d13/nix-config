{ pkgs, ... }: {
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
}
