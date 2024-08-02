{ config, modulesPath, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "intel_pstate=no_hwp" ];
    initrd = {
      availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "aesni_intel" "cryptd" ];
      kernelModules = [ "dm-snapshot" ];
    };

    kernelModules = [ "kvm-amd" ];

    extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  };
}
