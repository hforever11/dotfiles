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
    {
      # 仕事用・個人用の Mac で共通。マシン固有の git identity は config/git/local.gitconfig (gitignore)
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin
          ./modules/identity.nix
          home-manager.darwinModules.home-manager
          (
            { config, ... }:
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # 既存ファイルと衝突したら .pre-nix に退避して置き換える (再インストール時の安全弁)
              home-manager.backupFileExtension = "pre-nix";
              home-manager.users.${config.my.username} = import ./home;
            }
          )
        ];
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
    };
}
