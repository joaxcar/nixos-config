# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
   unstableTarball = 
     fetchTarball
       https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  networking.hostName = "nixos"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
    # consoleFont = "Lat2-Terminus18";
    # consoleKeyMap = "us";
    # defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    unstable.antibody
    zsh
    firefox
    git
    dmenu
    networkmanager
  ];
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

 #  Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManagergsddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;


  networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
  };
  services.httpd = {
      enable = true;
      enablePHP = true;
      enableUserDir = true;
      adminAddr = "johan@naetet.se";
      hostName = "localhost";
      documentRoot = "/www";
  };
  services.mysql = {
      enable = true;
      package = pkgs.mysql57;
      dataDir = "/var/lib/mysql";
  };
  services.xserver = {
      enable = true;
      layout = "us,se";
      xkbOptions = "caps:alt,shift:both_capslock,ctrl:swap_lalt_lctl_lwin,ctrl:ralt_rctrl,ctrl:swap_rwin_rctl";
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      desktopManager.default = "none";
      desktopManager.xterm.enable = false;
      windowManager.default = "xmonad";
      libinput.enable = true;
      # extraPackages = haskellPackages: [
        # haskellPackages.xmonad-contrib
        # haskellPackages.xmonad-extras
        # haskellPackages.xmonad
      # ];
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.johan = {
    name = "johan";
    group = "users";
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/johan";
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
