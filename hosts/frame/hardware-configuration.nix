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
      kernelModules = ["kvm-amd" "amdgpu"];
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
      "amd_pstate=guided"
      "tsc=reliable"
      "clocksource=tsc"
      "psmouse.synaptics_intertouch=0"
      "zswap.enabled=1"
      "amd_pstate=active"
      "mitigations=off"
      "nowatchdog"
      "rd.systemd.show_status=auto"
      "rd.udev.log_priority=3"
    ];
  };


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/169a0eae-abc0-46d4-88d7-f9501a8c2a55";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A07A-FB32";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";
  services.power-profiles-daemon.enable = true;
  hardware.pulseaudio.enable = false; 
  hardware.firmware = with pkgs; [ linux-firmware ];
  hardware.ksm.enable = true;
  hardware.bluetooth.enable = true;
  hardware.amdgpu.amdvlk.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
}
