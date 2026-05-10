{ pkgs, ... }:
let
  mesloRegular = pkgs.fetchurl {
    name = "MesloLGS-NF-Regular.ttf";
    url = "https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Regular.ttf";
    hash = "sha256-2XlGGG6X+NfAE56Jg6v0Ch0tCGkk8sXb8cKb2PLG5X0=";
  };
  mesloBold = pkgs.fetchurl {
    name = "MesloLGS-NF-Bold.ttf";
    url = "https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Bold.ttf";
    hash = "sha256-tsAZnPfHSDyDQ+oCBliSXm3grrMYuJkIFS/LTRkiYAM=";
  };
  mesloItalic = pkgs.fetchurl {
    name = "MesloLGS-NF-Italic.ttf";
    url = "https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Italic.ttf";
    hash = "sha256-bzV7y+JZdwThV6kVYlkovKODZKicIqSsNuehFtzTku8=";
  };
  mesloBoldItalic = pkgs.fetchurl {
    name = "MesloLGS-NF-Bold-Italic.ttf";
    url = "https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Bold%20Italic.ttf";
    hash = "sha256-VrQTGt7OwFLEsyTvuBjdMm1Ybbwxb8aPmPHK4uuNEiA=";
  };
  powerlevel10kMesloLGSNF = pkgs.stdenvNoCC.mkDerivation {
    pname = "powerlevel10k-meslo-lgs-nf";
    version = "2026-05-10";
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      install -Dm444 ${mesloRegular} "$out/share/fonts/truetype/MesloLGS NF Regular.ttf"
      install -Dm444 ${mesloBold} "$out/share/fonts/truetype/MesloLGS NF Bold.ttf"
      install -Dm444 ${mesloItalic} "$out/share/fonts/truetype/MesloLGS NF Italic.ttf"
      install -Dm444 ${mesloBoldItalic} "$out/share/fonts/truetype/MesloLGS NF Bold Italic.ttf"
      runHook postInstall
    '';
  };
in
{
  fonts.packages = with pkgs; [
    powerlevel10kMesloLGSNF
    nerd-fonts.meslo-lg
    nerd-fonts.iosevka-term
  ];
}
