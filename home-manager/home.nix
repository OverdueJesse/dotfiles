{ config, pkgs, ... }:

{
  home.username = "jesse";
  home.homeDirectory = "/home/jesse";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}

