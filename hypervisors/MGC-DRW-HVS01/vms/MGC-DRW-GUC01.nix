{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu:///system";

  module = {
    guacamole-server = {
      source = "${vars.moduleSource}";
      vm_hostname_prefix = "MGC-DRW-GUC";
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
