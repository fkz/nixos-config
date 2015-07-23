# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modules, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./custom-grub/grub.nix
    ];

  config = let myConfig = name:
    let normalOr = val:
          if name == "normal" then val else null; in 
    {
  
      # Use the GRUB 2 boot loader.
      boot.initrd.luks.devices = 
        [ { name = "luksRoot"; device = "/dev/sda5";
            preLVM = true; } ];
      networking.extraHosts = 
        ''
	#104.24.112.38 schmitthenner.eu
	84.200.8.234 schmitthenner.eu
        84.200.8.234 mail.schmitthenner.eu
        '';

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
      #additionalOptions = 
      #  ''
      #  Option "SoftButtonAreas" "60% 0 0 0 40% 60% 0 0"
      #  '';
    };

    services.virtualboxHost.enable = true;	

    virtualisation.docker.enable = true;

    hardware.pulseaudio.enable = true;

    environment.shellAliases = {
      n = "nix-instantiate --eval --expr";
    };

    environment.systemPackages = 
      with pkgs;
      let texAggregation =
            texLiveAggregationFun
              { paths = [ texLive texLiveExtra texLiveModerncv texLiveModerntimeline texLiveCMSuper ]; }; in 
      [ emacs vim 
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
        # texAggregation
        # (import ./auctex.nix { inherit stdenv fetchurl emacs; texLive = texAggregation; })
	texAggregation
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
        kde4.kdevelop
        # (import /home/fabian/src/kdev-haskell)
      ];

    nixpkgs.config =  {
      allowUnfree = true;
      firefox = {
        enableAdobeFlash = true;
      };
      chromium = {
        enablePepperFlash = true;
      };        	     

      packageOverrides = pkgsOld : {
        # wpa_supplicant = pkgsOld.lib.overrideDerivation pkgsOld.wpa_supplicant (attrs: {
        #   extraConfig = attrs.extraConfig + ''
        #     AP=y
        #   '';
        # });
        # networkmanager = pkgsOld.lib.overrideDerivation pkgsOld.networkmanager (attrs: {
        #  postInstall = attrs.postInstall + ''
        #    echo "Alias=network-manager.service" > $out/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
        #  '';
        # });
        myHaskellPackages =
          let fabian = /home/fabian; in
          pkgs.recurseIntoAttrs (pkgs.haskellPackages.override {
            extension = self: super: let callPackage = pkgs.lib.callPackageWith self; in {
              darcs = callPackage (fabian + /nix-src/darcs.nix) {};
              FindBin = callPackage (fabian + /nix-src/FindBin.nix) {};
              structured = callPackage (fabian + /nix-src/structured.nix) { emacs = pkgs.emacs; };
              descriptive = callPackage fabian + /nix-src/descriptive.nix> {};
              web = callPackage (fabian + /haskell-env/web.nix) {};
              cryptoRandomEffect = callPackage (fabian + /nix-src/cryptoRandomEffect.nix) {};
              x509 = callPackage (fabian + /nix-src/x509.nix) {};
            };
          });
        webProxy =
          (pkgs.myHaskellPackages
          .override { profExplicit = true; profDefault = true; })
          .web.overrideDerivation (drv: 
            { extraConfigureFlags = drv.extraConfigureFlags ++ ["--enable-executable-profiling" "--ghc-options=-auto-all" "--ghc-options=-caf-all"];
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

    users.extraUsers.cabal = {
      name = "cabal";
      createHome = true;
    };

    programs.bash.enableCompletion = true;
    services.openvpn.servers.${normalOr "studentenwerkBonn"} = { 
      config = ''
        remote vpn.stw-bonn.de 1194 udp
        dev tun0
        persist-tun
        persist-key
        ca ${./ca--bonn.crt}
        remote-random
        resolv-retry infinite
        tls-remote vpn.stw-bonn.de
        auth-user-pass ${./openvpn-auth}
        #auth-user-pass
        client
        nobind
        pull
        verb 4
        redirect-gateway def1
        '';
    };
    services.postfix = {
        enable = true;
        hostname = "semiwahr.de";
        extraConfig = ''
        mydestination = semiwahr.de
        '';
    };
    networking.firewall.allowedTCPPorts = [ 25 80 443 ];
    services.nginx = {
        enable = true;
	config = ''
	   events { }
	   http {
	      server {
	         listen 80;
		 location / {
		     proxy_pass http://10.233.5.2;
		 }
              }
	      server {
	      	 listen 8000;
		 location / {
		     proxy_pass http://localhost/;
		 }
	     }
	   }
	   '';
         };
    networking.networkmanager.enable = true;

    fileSystems."/home/fabian/old-fabian" =
    { device = "/dev/mapper/main-root";
      fsType = "ext4";
    };

    #  we want to run hydra, so we need postgresql
    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql;
    }; in
    (myConfig "normal") // {
      nesting.children = [ { config = (myConfig "noBonn"); imports = [ ./hardware-configuration.nix ./custom-grub/grub.nix ]; } ];
    };
}
