{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://controller@${vars.networking.hostsAddr.MGC-DRW-HVS02.ipv4}/system";

  module = {
    zabbix-server = {
      source = "${vars.moduleSource}";
      vm_hostname_prefix = "MGC-DRW-ZBX";
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
