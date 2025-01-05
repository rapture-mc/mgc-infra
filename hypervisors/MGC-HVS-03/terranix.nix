{
  pkgs,
  terranix,
  system,
  machineName,
  action,
  vars,
  ...
}: let
  opentofu = pkgs.opentofu;
  terraformConfiguration = terranix.lib.terranixConfiguration {
    inherit system;
    modules = [
      (import ./vms/MGC-DRW-HDS01.nix {inherit vars;})
      (import ./vms/MGC-DRW-PWS01.nix {inherit vars;})
      (import ./vms/MGC-DRW-RVP01.nix {inherit vars;})
      (import ./vms/MGC-DRW-GUC01.nix {inherit vars;})
    ];
  };
in {
  type = "app";
  program = toString (pkgs.writers.writeBash "apply" ''
    cd ./hypervisors/${machineName}

    if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
    cp ${terraformConfiguration} config.tf.json \
      && ${opentofu}/bin/tofu init \
      && ${opentofu}/bin/tofu ${action}
  '');
}
