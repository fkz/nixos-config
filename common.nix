{ pkgs, ... }:

{
  networking.extraHosts = 
        ''
	#104.24.112.38 schmitthenner.eu
	84.200.8.234 schmitthenner.eu
        84.200.8.234 mail.schmitthenner.eu
	192.168.1.42 icfp
	'';
    system.copySystemConfiguration = true;


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


    services.virtualboxHost.enable = true;	

    #virtualisation.docker.enable = true;

    hardware.pulseaudio.enable = true;

    environment.shellAliases = {
      n = "nix-instantiate --eval --expr";
      # nb = "nix-build --no-out-link '<nixpkgs>'";
    };

    environment.systemPackages = 
      with pkgs;
      [ emacs vim 
        firefoxWrapper 
        thunderbird
	#sage
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
        # texAggregation
        # (import ./auctex.nix { inherit stdenv fetchurl emacs; texLive = texAggregation; })
	# texAggregation
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
        lsof
        ncdu
        networkmanagerapplet
        nmap
        unzip
        wget
        xlibs.xev
        htop
        chromium
        kde4.kdevelop
        # (import /home/fabian/src/kdev-haskell)
      ];

    nixpkgs.config =  {
      allowUnfree = true;
      firefox = {
        #enableAdobeFlash = true;
      };
      chromium = {
        #enablePepperFlash = true;
      };        	     
    };
}