{
  lib,
  config,
  ...
}: {
  options = {
    boot-config.enable = lib.mkEnableOption "enables custom boot configuration";
  };

  config = lib.mkIf config.boot-config.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "breeze";
      };

      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "psmouse.synaptics_intertouch=0"
        "i915.i915_enable_rc6=1"
        "pcie_aspm=force"
        "epb=7"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "cgroup_enable=memory"
        "cgroup_enable=cpuset"
        "cgroup_memory=1"
      ];
      loader.timeout = 1;
    };

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      zfsSupport = true;
      efiInstallAsRemovable = true;
      device = "/dev/sda";
      extraConfig = ''
        acpi_backlight=vendor
        acpi_osi=Linux
      '';
    };

    boot.extraModprobeConfig = ''
      options thinkpad_acpi  fan_control=1
    '';
  };
}
