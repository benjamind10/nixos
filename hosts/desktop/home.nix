{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    zsh
    kitty
    neovim
  ];

  home.file.".zshrc".source = ../../dotfiles/zsh/.zshrc;
  home.file.".config/nvim".source = ../../dotfiles/nvim;
}
