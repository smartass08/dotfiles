{ hostname, lib, ... }:
let
  profileGuid = "${hostname}-nix-profile";
in
{
  home.file."Library/Application Support/iTerm2/DynamicProfiles/${hostname}.json".text =
    builtins.toJSON
      {
        Profiles = [
          {
            Name = hostname;
            Guid = profileGuid;
            "Custom Command" = "No";
            "Normal Font" = "MesloLGS-NF-Regular 13";
            "Non Ascii Font" = "MesloLGS-NF-Regular 13";
            "Use Non-ASCII Font" = true;
            "Terminal Type" = "xterm-256color";
            "Unlimited Scrollback" = true;
            "Prompt Before Closing 2" = 0;
            "Silence Bell" = true;
          }
        ];
      };

  home.activation.setIterm2DefaultProfile = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    /usr/bin/defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "${profileGuid}"
  '';
}
