{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://controller@${vars.networking.hostsAddr.MGC-DRW-HVS01.ipv4}/system";

  module = {
   controller-server = {
      source = "${vars.moduleSource}";
      vm_hostname_prefix = "MGC-DRW-CTR";
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
