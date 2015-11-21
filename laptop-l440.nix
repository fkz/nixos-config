{ pkgs, ... }:
{

    hardware.opengl.driSupport32Bit = true;
    # List services that you want to enable:

    services.xserver.synaptics = {
      enable = true;
      twoFingerScroll = true;
      #additionalOptions = 
      #  ''
      #  Option "SoftButtonAreas" "60% 0 0 0 40% 60% 0 0"
      #  '';
    };

}