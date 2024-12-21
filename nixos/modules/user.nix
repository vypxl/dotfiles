{ ... }:
{
  users.users.thomas = {
    isNormalUser = true;
    description = "Thomas";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
