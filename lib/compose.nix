{ config, lib, pkgs, ... }: 
with lib; 
let composefile = pkgs.writeText "xcomposefile" ''
      include "%L"
      ${lib.concatStringsSep "\n" config.X11.compose}
    '';
in {
  options = {
    X11.compose = {
      default = [];
      example = [ "<Multi_key> <a> <e>  : \"ä\"" ];
      type = types.listOf types.str;
      description = "add custom compose combinations";
    };
  };
  config = mkIf (config.X11.compose != []) {
    environment.shellInit = ''
      export XCOMPOSEFILE=${composefile}
    '';
  };
}