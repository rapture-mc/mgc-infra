{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://controller@${vars.networking.hostsAddr.MGC-DRW-HVS02.ipv4}/system";

  module = {
    windows-server = {
      source = "${vars.moduleSource}";
      os_img_url = "/var/lib/libvirt/images/win22.qcow2";
      uefi_enabled = false;
      vm_hostname_prefix = "MGC-DRW-DMC";
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
