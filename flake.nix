{
  description = "MGC NixOS Infrastructure";

  inputs = {
    megacorp.url = "github:rapture-mc/nixos-module?ref=unstable";
    nixpkgs.follows = "megacorp/nixpkgs";

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-generators,
    megacorp,
    terranix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    vars = import ./vars;

    # Helper function for importing different Terraform configurations
    importTerraformConfig = machineName: action:
      import ./hypervisors/${machineName}/terranix.nix {
        inherit terranix pkgs system machineName action vars;
      };
  in {
    # Nix commands to create/destroy Terraform infrastructure
    # Run with "nix run .#<hypervisor-name>-apply"
    apps.${system} = import ./hypervisors {inherit importTerraformConfig;};

    # For generating NixOS QCOW EFI images for use with terraform + libvirt
    # Build with "nix build .#qcow-efi"
    packages.${system}.qcow-efi = nixos-generators.nixosGenerate {
      system = "${system}";
      format = "qcow-efi";
      modules = [
        megacorp.nixosModules.default
        {
          networking.hostName = "nixos";

          system.stateVersion = "24.11";

          megacorp = {
            config = {
              system.enable = true;
              bootloader.enable = false;  # nixos-generator will handle bootloader configuration instead

              openssh = {
                enable = true;
                authorized-ssh-keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzlYmoWjZYFeCNdMBCHBXmqpzK1IBmRiB3hNlsgEtre benny@MGC-DRW-BST01"
                ];
              };

              users = {
                enable = true;
                admin-user = "benny";
              };
            };
          };
        }
      ];
    };
  };
}
