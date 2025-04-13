{ pkgs, ... }:
{
  imports = [ ./devenv/modules/vscodium.nix ];
  packages = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic
        appendixnumberbeamer
        beamer
        beamertheme-metropolis
        booktabs
        catchfile
        ccicons
        chktex
        cm-super
        ec
        enumitem
        epstopdf
        etoolbox
        fancyvrb
        fira
        float
        fontaxes
        framed
        fvextra
        graphics
        hyperref
        ifplatform
        latex
        latexmk
        lineno
        microtype
        minted
        ms
        mweights
        fontawesome
        pgf
        pgfopts
        pgfplots
        preview
        translator
        ulem
        upquote
        xcolor
        xkeyval
        xstring;
    })
    pkgs.curl
    pkgs.ghostscript
    pkgs.gnumake
    pkgs.python3Packages.pygments
    pkgs.treefmt
    pkgs.unzip
    pkgs.which
  ];

  cachix.pull = [ "datakurre" ];
}
