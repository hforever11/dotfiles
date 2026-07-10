{
  description = "sfukunaga's dotfiles (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    let
      mkHost =
        hostModule:
        nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin
            ./modules/identity.nix
            hostModule
            home-manager.darwinModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # 既存ファイルと衝突したら退避して置き換える (chezmoi からの移行用)
                home-manager.backupFileExtension = "pre-nix";
                home-manager.users.${config.my.username} = import ./home;
              }
            )
          ];
        };
    in
    {
      darwinConfigurations = {
        work = mkHost ./hosts/work.nix;
        personal = mkHost ./hosts/personal.nix;
      };
    };
}
