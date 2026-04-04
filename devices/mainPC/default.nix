{...}: 
{
  imports = [
    ./custom-configuration.nix
  ];
  fileSystems."/media/Linux_storage_hdd" = {
    device = "/dev/disk/by-uuid/730269e9-6f16-47a1-814e-e62cf3fd72bb";
    options = [ "users" "nofail" "exec" ];
  };

  fileSystems."/media/Window_storage_hdd" = {
    device = "/dev/disk/by-uuid/5CE2EE64E2EE423E";
    options = [ "users" "nofail" "exec" ];
    fsType = "ntfs3";
  };

  fileSystems."/media/Linux_intel_ssd" = {
    device = "/dev/disk/by-uuid/f12a09bd-95e2-41d8-ab9e-1ef62aa8958c";
    options = [ "users" "nofail" "exec" ];
  };

  fileSystems."/media/Window_intel_ssd" = {
    device = "/dev/disk/by-uuid/7ADAEC07DAEBBD8F";
    options = [ "users" "nofail" "exec" ];
  };
}
