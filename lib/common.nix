{ pkgs, ... }:

{
  imports = [ ./network.nix ./desktop.nix ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    #services.virtualboxHost.enable = true;
    #virtualisation.docker.enable = true;

    programs.bash.enableCompletion = true;

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
        vlc
        dhcpcd
        emacs24Packages.haskellMode
        # texAggregation
        # (import ./auctex.nix { inherit stdenv fetchurl emacs; texLive = texAggregation; })
	# texAggregation
	kde4.plasma-nm
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
        unzip    #virtualisation.docker.enable = true;

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