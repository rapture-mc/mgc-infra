{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://deploy@${vars.networking.hostsAddr.MGC-HVS-03.ipv4}/system";

  module = {
    guacamole-server = {
      source = "${vars.moduleSource}";
      vm_hostname_prefix = "MGC-DRW-BST";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };
  };
}
