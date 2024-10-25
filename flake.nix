{
  description = "NixOS configuration with Home Manager for multiple profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix  
        ];
      };
    };

    homeConfigurations = {
      shiva = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        system = "x86_64-linux";
        homeDirectory = "/home/shiva";
        username = "shiva";
        configuration = ./hosts/desktop/home.nix;  
      };
    };
  };
}

