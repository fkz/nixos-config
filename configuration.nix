# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./custom-grub/grub.nix
    ];

  # Use the GRUB 2 boot loader.
  
  boot.initrd.luks.devices = 
    [ { name = "luksRoot"; device = "/dev/sda5";
        preLVM = true; } ];
  networking.extraHosts = 
  ''
  84.200.8.234 schmitthenner.eu
  84.200.8.234 mail.schmitthenner.eu
  '';

  boot.loader.grub.enable = false;
  boot.loader.custom-grub = {
      enable = true;
      version = 2;
      # Define on which hard drive you want to install Grub.
      device = "nodev";
      copyKernels = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget ./install-boot
  # ];

  system.copySystemConfiguration = true;

# List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde4.enable = true;

  services.xserver.synaptics = {
   enable = true;
   twoFingerScroll = true;
#   additionalOptions = 
#   ''
#   Option "SoftButtonAreas" "60% 0 0 0 40% 60% 0 0"
#   '';
  };

  hardware.pulseaudio.enable = true;

  environment.systemPackages = 
     with pkgs;
     let texAggregation =
         texLiveAggregationFun
         { paths = [ texLive texLiveExtra texLiveBeamer texLiveFull ]; };
     in [ emacs vim 
       firefoxWrapper 
       thunderbird
       gnupg
       pavucontrol
       darcs
       evince
       xfce.xfce4_power_manager
       psmisc
       networkmanager
       networkmanagerapplet
       wireshark
       vlc
       dhcpcd
       emacs24Packages.haskellMode
       texAggregation
       (import ./auctex.nix { inherit stdenv fetchurl emacs; texLive = texAggregation; })
       kde4.plasma-nm
       dnsmasq
       hostapd
       bridge_utils
       ed
       git
       inetutils
       jitsi
       keepassx
       kde4.kuser
       libreoffice
       lsof
       ncdu
       networkmanagerapplet
       nmap
       unzip
       wget
       xlibs.xev
       htop
       chromium
];

  nixpkgs.config =  {
   allowUnfree = true;
   firefox = {
      enableAdobeFlash = true;
   };

  packageOverrides = pkgsOld : {
    wpa_supplicant = pkgsOld.lib.overrideDerivation pkgsOld.wpa_supplicant (attrs: {
       extraConfig = attrs.extraConfig +
       ''
          AP=y
       '';
     });
    networkmanager = pkgsOld.lib.overrideDerivation pkgsOld.networkmanager (attrs: {
       postInstall = attrs.postInstall +
       ''
       echo "Alias=network-manager.service" > $out/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
       '';
     });
  };

  }; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.fabian = {
    name = "fabian";
    group = "users";
    extraGroups = [ "networkmanager" ];
    uid = 1000;
    createHome = true;
    home = "/home/fabian";
    shell = "/run/current-system/sw/bin/bash";
  };

  programs.bash.enableCompletion = true;
  services.openvpn.servers.studentenwerkBonn =
  { config = 
	''
        remote vpn.stw-bonn.de 1194 udp
        dev tun0
        persist-tun
        persist-key
        ca ${./ca--bonn.crt}
        remote-random
        resolv-retry infinite
        tls-remote vpn.stw-bonn.de
        auth-user-pass ${builtins.toFile "auth"
                           ''
                                <username redacted>
                                <password redacted>
                           '' }
        #auth-user-pass
        client
        nobind
        pull
        verb 4

        redirect-gateway def1
        '';
    };
    networking.networkmanager.enable = true;

    fileSystems."/home/fabian/old-fabian" =
    { device = "/dev/mapper/main-root";
      fsType = "ext4";
    };
}