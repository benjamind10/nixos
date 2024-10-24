{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Time zone and locale
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

  # Shell and fonts
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  fonts.packages = with pkgs; [
   (nerdfonts.override { fonts = [ "3270" "DroidSansMono" ]; })
  ];

  # X11 and i3 window manager setup
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

  # Sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User and package management
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

  # Docker
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  services.xserver.videoDrivers = [ "nvidia" ];

  # Home Manager configuration
  home-manager.users.shiva = {
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
      zsh kitty neovim
    ];

    
    home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/.zshrc;
    home.file.".config/nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };

  };

  system.stateVersion = "24.05";
}
