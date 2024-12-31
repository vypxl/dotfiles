{ ... }:
{
  virtualisation.docker.enable = true;
  users.users.thomas.extraGroups = [ "docker" ];
}
