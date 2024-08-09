{
  pkgs,
  ...
}: {
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
  xsession.enable = true;
  xsession.windowManager.command = "gdm";
  xdg.portal.config.common.default = "*";
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
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
    systemdIntegration = true;
    config = {
       bars = [];
    };
    extraConfig = ''
    # Logo key. Use Mod1 for Alt.
set $mod Mod4

# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l
# Your preferred terminal emulator
set $term alacritty
# Your preferred application launcher
set $menu alacritty --title "sway-launcher" -e bash -c "dmenu_path | fzf | xargs swaymsg exec"

### Output configuration
#
# Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
# output * bg ~/dotfiles/wallpaper.jpg fill

### Input configuration
#
# Example configuration:
#

input 'type:keyboard' {
  xkb_layout us,ru,de
  xkb_options caps:swapescape,grp:alt_shift_toggle
}

bindsym $mod+Return exec $term

  # kill focused window
  bindsym $mod+q kill

  # start your launcher
  bindsym $mod+d exec $menu

  # Drag floating windows by holding down $mod and left mouse button.
  # Resize them with right mouse button + $mod.
  # Despite the name, also works for non-floating windows.
  # Change normal to inverse to use left mouse button for resizing and right
  # mouse button for dragging.
  floating_modifier $mod normal

  # reload the configuration file
  bindsym $mod+Shift+c reload

  # exit sway (logs you out of your wayland session)
  bindsym $mod+Shift+e exit
#
# Moving around:
#
  # Move your focus around
  bindsym $mod+$left focus left
  bindsym $mod+$down focus down
  bindsym $mod+$up focus up
  bindsym $mod+$right focus right
  # or use $mod+[up|down|left|right]
  #bindsym $mod+Left focus left
  #bindsym $mod+Down focus down
  #bindsym $mod+Up focus up
  #bindsym $mod+Right focus right

  # _move_ the focused window with the same, but add Shift
  bindsym $mod+Shift+$left move left
  bindsym $mod+Shift+$down move down
  bindsym $mod+Shift+$up move up
  bindsym $mod+Shift+$right move right
  # ditto, with arrow keys
  #bindsym $mod+Shift+Left move left
  #bindsym $mod+Shift+Down move down
  #bindsym $mod+Shift+Up move up
  #bindsym $mod+Shift+Right move right
#
# Workspaces:
#
  # switch to workspace
  bindsym $mod+1 workspace 1
  bindsym $mod+2 workspace 2
  bindsym $mod+3 workspace 3
  bindsym $mod+4 workspace 4
  bindsym $mod+5 workspace 5
  bindsym $mod+6 workspace 6
  bindsym $mod+7 workspace 7
  bindsym $mod+8 workspace 8
  bindsym $mod+9 workspace 9
  bindsym $mod+0 workspace 10
  # move focused container to workspace
  bindsym $mod+Shift+1 move container to workspace 1
  bindsym $mod+Shift+2 move container to workspace 2
  bindsym $mod+Shift+3 move container to workspace 3
  bindsym $mod+Shift+4 move container to workspace 4
  bindsym $mod+Shift+5 move container to workspace 5
  bindsym $mod+Shift+6 move container to workspace 6
  bindsym $mod+Shift+7 move container to workspace 7
  bindsym $mod+Shift+8 move container to workspace 8
  bindsym $mod+Shift+9 move container to workspace 9
  bindsym $mod+Shift+0 move container to workspace 10
  # Note: workspaces can have any name you want, not just numbers.
  # We just use 1-10 as the default.
#
# Layout stuff:
#
  # You can "split" the current object of your focus with
  # $mod+b or $mod+v, for horizontal and vertical splits
  # respectively.
  bindsym $mod+b splith
  bindsym $mod+v splitv

  # Switch the current container between different layout styles
  bindsym $mod+s layout stacking
  bindsym $mod+t layout tabbed
  bindsym $mod+e layout toggle split

  # Make the current focus fullscreen
  bindsym $mod+f fullscreen

  # Toggle the current focus between tiling and floating mode
  bindsym $mod+Shift+n floating toggle

  # Swap focus between the tiling area and the floating area
  bindsym $mod+n focus mode_toggle

  # move focus to the parent container
  #bindsym $mod+a focus parent
#
# Scratchpad:
#
  # Sway has a "scratchpad", which is a bag of holding for windows.
  # You can send windows there and get them back later.

  # Move the currently focused window to the scratchpad
  bindsym $mod+Shift+minus move scratchpad

  # Show the next scratchpad window or hide the focused scratchpad window.
  # If there are multiple scratchpad windows, this command cycles through them.
  bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
#mode "resize" {
  # left will shrink the containers width
  # right will grow the containers width
  # up will shrink the containers height
  # down will grow the containers height
#  bindsym $left resize shrink width 10 px or 10 ppt
#  bindsym $down resize grow height 10 px or 10 ppt
#  bindsym $up resize shrink height 10 px or 10 ppt
#  bindsym $right resize grow width 10 px or 10 ppt

  # ditto, with arrow keys
#  bindsym Left resize shrink width 10 px or 10 ppt
#  bindsym Down resize grow height 10 px or 10 ppt
#  bindsym Up resize shrink height 10 px or 10 ppt
#  bindsym Right resize grow width 10 px or 10 ppt

  # return to default mode
#  bindsym Return mode "default"
#  bindsym Escape mode "default"
#}

# bindsym $mod+Shift+r mode "resize"

#
# windows
#
default_border pixel 2
client.focused #4c566a #2e3440 #d8dee9 #4c566a #4c566a
client.unfocused #000000 #000000 #4c566a #000000 #000000
client.urgent #b48ead #2e3440 #d8dee9 #a3be8c #b48ead
#for_window [app_id="firefox"] border none

#
# special keys
#
bindsym XF86AudioRaiseVolume exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym XF86MonBrightnessUp exec brightnessctl set +5%

# screen lokc
bindsym $mod+o exec swaylock -c 000000

output * scale 1
font "Hack 11"

#include /etc/sway/config.d/*

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
    modules-left =  ["sway/workspaces" "sway/mode"];
    modules-center = ["sway/window"];
    modules-right = ["tray" "custom/spotify" "custom/weather" "wireplumber" "cpu" "memory" "temperature" "network" "battery" "clock" "sway/language"];
    "sway/mode" = {
        format = " {}";
    };
    "clock" = {
        format= "{:%d.%m.%Y·%H:%M}";
        tooltip= false;
    };
    "sway/window"= {
        max-length= 80;
        tooltip = false;
    };
    "custom/weather"= {
      exec= "~/.config/waybar/scripts/get_weather.sh Berlin+Germany";
      return-type = "json";
      format= "{}";
      tooltip= true;
      interval= 300;
    };
    "wireplumber"= {
      format= "{volume}% ";
      format-muted= "muted ";
      on-click= "helvum";
      max-volume= 150;
      scroll-step= 0.2;
    };
    "cpu"= {
        interval= 15;
        format= "{}% ";
        max-length= 10;
    };
    "memory"= {
        interval= 30;
        format= "{used:0.2f}";
        max-length= 10;
        tooltip= false;
    };
    "battery"= {
        bat= "BAT0";
        format= "{capacity}% {icon}";
        format-alt= "{time} {icon}";
        format-icons= ["" "" "" "" ""];
        format-charging= "{capacity}%";
        interval= 30;
        states= {
            warning= 25;
            critical= 10;
        };
        tooltip= false;
    };
    "temperature"= {
        critical-threshold= 80;
	      format-critical= "{temperatureC}° ";
	      format= "{temperatureC}° ";
    };
    "network"= {
        format= "{icon}";
        format-alt= "{ipaddr}/{cidr} {icon}";
        format-alt-click= "click-right";
        format-icons= {
            wifi= ["睊" "直" ""];
            ethernet= [""];
            disconnected= ["󰖪"];
        };
        on-click= "alacritty -e nmtui";
        tooltip= false;
    };
    "custom/spotify"= {
        interval= 1;
        return-type= "json";
        exec= "~/.config/waybar/modules/spotify.sh";
        exec-if = "pgrep spotify";
        escape = true;
    };
    tray = {
        icon-size= 18;
    };
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


  programs.neovim.enable = true;

  home.packages = with pkgs; [
     alacritty
     dmenu
     pavucontrol
     qpwgraph
     helvum
  ];
}
