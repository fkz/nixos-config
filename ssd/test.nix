{ pkgs, ... }: {
  imports = [ ./. ];
  services.studentenwerkBonn.enable = false;
}