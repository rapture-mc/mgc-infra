{
  networking = import ./networking.nix;

  moduleSource = "git::https://gitea.megacorp.industries/megacorp/terraform-libvirt-module.git?ref=40acff807a0ffb1c0da741774c37ebeda90730b7";
}
