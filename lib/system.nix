{ pkgs, ... }:
{
  boot.initrd.luks.devices = 
        [ { name = "luksRoot"; device = "/dev/sda5";
            preLVM = true; } ];
      boot.loader =
        { grub.enable = false;
          custom-grub = {
            enable = true;
            version = 2;
            # Define on which hard drive you want to install Grub.
            device = "nodev";
            copyKernels = true;
          };
        };
    fileSystems."/home/fabian/old-fabian" =
    { device = "/dev/mapper/main-root";
      fsType = "ext4";
    };


}