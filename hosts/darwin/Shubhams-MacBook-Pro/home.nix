{ username, ... }:
{
  imports = [
    ../../../home/users/smartass08
    ../../../home/darwin
    ./git-identities.nix
  ];

  home.homeDirectory = "/Users/${username}";

  # This machine has no cloudflared-fronted hosts. The rest of the network
  # toolset stays on because home/common/ssh.nix gates the 1Password agent
  # symlink on it.
  home.file.".ssh/config.d/shbam-cloudflared.conf".enable = false;
}
