{ pkgs, ... }: {
  imports = [ ./network.nix ./desktop.nix ./compose.nix ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #services.virtualboxHost.enable = true;
  #virtualisation.docker.enable = true;

  programs.bash.enableCompletion = true;
  programs.bash.promptInit = ''
    PROMPT_COLOR="1;31m"
    let $UID && PROMPT_COLOR="1;32m"
    user=
    if [ $UID != 1000 ] && [ $UID != 0 ] ; then 
      user="\u@"
    fi
    PS1="\[\033[$PROMPT_COLOR\]$user\w \[\033[0m\]"
    '';
  
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
      kde5.plasma-nm
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
      #kde5.kdevelop
      # (import /home/fabian/src/kdev-haskell)
    ];

  services.printing = {
    enable = true;
  };

  X11.compose = [
    "<Multi_key> <a> <e>  : \"ä\""
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