{ pkgs, ... }: {
  networking.extraHosts = ''
    84.200.8.234 schmitthenner.eu
    84.200.8.234 mail.schmitthenner.eu
    192.168.1.42 icfp
    '';
  
  networking.firewall = {
    enable = true;
    allowPing = true;
  };
  
  networking.networkmanager.enable = true;
  
  environment.systemPackages = with pkgs; [
    # some useful programs
    
    # make dns requests
    bind
    
    # be able to make local wifi's
    dnsmasq
    hostapd
    
    # generally handle connections by network manager
    networkmanager
    networkmanagerapplet
    wireshark
  ];
}