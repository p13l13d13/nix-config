{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
	"thunderbolt"
      ];
      kernelModules = ["kvm-intel"];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    
    tmp.cleanOnBoot = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "zswap.enabled=1"
      "amd_pstate=active"
      "mitigations=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "quiet"
      "rd.systemd.show_status=auto"
      "rd.udev.log_priority=3"
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ed88a973-ee8c-4dfb-ab05-b494ee6c57ce";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4DAA-18BE";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = "schedutil";
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
      CPU_BOOST_ON_AC= "1";
      CPU_BOOST_ON_BAT="0";
    };
  };
  hardware.firmware = with pkgs; [ linux-firmware ];
  hardware.ksm.enable = true;
  hardware.bluetooth.enable = true;
  hardware.usb-modeswitch.enable = true;

  hardware.graphics = {
     enable = true;

     extraPackages = with pkgs;
     [
	intel-media-driver
     ];
  };
}
