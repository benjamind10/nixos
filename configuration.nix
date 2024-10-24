# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/refs/heads/release-24.05.zip}/nixos")
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
   (nerdfonts.override { fonts = [ "3270" "DroidSansMono" ]; })
 ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shiva = {
    isNormalUser = true;
    description = "shiva";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      curl
      xarchiver
      aria
      pavucontrol
      vlc
      zsh
      wget
      vim
      git
      eza
      ranger
      rofi
      lazygit
      btop
      neovim
      brave
      cinnamon.nemo
      kitty
      feh
      killall
      stdenv
      dunst
      copyq
      xclip
      steam
      fnm
      maim
      discord
      wget
    ];
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;  

  # Install firefox.
  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget    
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

   home-manager.users.shiva = {
    home.stateVersion = "24.05";  # Adapt this to match your Home Manager version
    # Define Home Manager configuration here
  };

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
