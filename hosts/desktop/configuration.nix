{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./home.nix 
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
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

  services.xserver = {
    enable = true;
    desktopManager = { xterm.enable = false; };
    displayManager = { defaultSession = "none+i3"; };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
      ];
    };
    xkb = { layout = "us"; variant = ""; };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.shiva = {
    isNormalUser = true;
    description = "shiva";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      curl xarchiver aria pavucontrol vlc zsh wget vim git eza ranger rofi lazygit
      btop neovim brave cinnamon.nemo kitty feh killall stdenv dunst copyq xclip
      steam fnm maim discord wget
    ];
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "24.05";
}
