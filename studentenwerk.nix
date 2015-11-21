{ pkgs, ... }:
{
  services.openvpn.servers.studentenwerkBonn = { 
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
}