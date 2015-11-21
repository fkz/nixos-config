# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modules, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./custom-grub/grub.nix
      ./system.nix
      ./studentenwerk.nix
      ./laptop-l440.nix
      ./common.nix
   ];

  config = let myConfig = name:
    let normalOr = val:
          if name == "normal" then val else null; in 
    {
  


    networking.hostName = "nixos"; # Define your hostname.

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

   nixpkgs.config = {
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
              # x509 = callPackage (fabian + /nix-src/x509.nix) {};
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
    services.postfix = {
        enable = true;
        hostname = "semiwahr.de";
        extraConfig = ''
        mydestination = semiwahr.de
        '';
    };
    networking.firewall.allowedTCPPorts = [ 25 80 8080 443 ];
    services.nginx = {
        enable = true;
	config = ''
	   events { }
	   http {
	      server {
	         listen 80;
		 location / {
		     root /home/fabian/superschurken/crm/website/material-design-template
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


    # services.mysql.enable = true;
    #  we want to run hydra, so we need postgresql
    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql;
    }; in
    (myConfig "normal") // {
      nesting.children = [ { config = (myConfig "noBonn"); imports = [ ./hardware-configuration.nix ./custom-grub/grub.nix ]; } ];
    };
}
