# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.polkit.enable = true;

  boot.kernelModules = ["vcan" "can_raw"];

  # VCAN for ECU Simulation
  systemd.network.enable = true;

  systemd.network.netdevs."vcan0" = {
    netdevConfig = {
      Name = "vcan0";
      Kind = "vcan";
    };
  };

  systemd.network.networks."vcan0" = {
    matchConfig.Name = "vcan0";
    networkConfig = {
      LinkLocalAddressing = "no";
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jesse = {
    isNormalUser = true;
    description = "Jesse Guillory";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    	vesktop
	    zsh
	    pkgs.starship
	    nerd-fonts.bigblue-terminal
	    nerd-fonts.fira-code
	    ripgrep
	    lazygit
      gdu
	    nodejs
	    python313Packages.pynvim
	    bottom
	    rustup
	    cargo
	    fzf
	    zoxide
	    yazi
	    gitkraken
	    spotify
	    vtsls
	    prettierd
	    lua-language-server
	    pyright
	    stylua
	    bitwarden-desktop
	    flameshot

	    # Gaming
	    lutris

	    # CAN for ECU SIM
	    can-utils

	    # Unstable
	    unstable.tombi
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pipewire
    vim
    wget
    kitty
    waybar
    xdg-desktop-portal-hyprland
    wireplumber
    swayidle
    swaylock
    grim
    wl-clipboard
    kdePackages.dolphin
    git
    gzip
    unzip
    gcc
    hyprlock
    hyprpaper
    rofi-wayland
	  gnupg
	  pinentry-curses
	  openssl
	  lxqt.lxqt-policykit
  ];

  # programs.nix-ld.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
  };

  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  services.displayManager.enable = false;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "hyprland";
      user = "jesse";
    };
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.pathsToLink = [
    "$HOME/.config/rofi/scripts"
  ];

  # mounting disks
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
