{
  description = "TCC em LaTeX com Emacs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic
          # Pacotes mínimos para C-c C-p C-b funcionar
          memoir xpatch booktabs textcase enumitem
          # Pacotes para fazer latexmk funcionar
          latexmk breakurl xkeyval
          babel-portuges
          microtype
          abntex2
          # Dependências do svg
          svg xcolor transparent pgf catchfile
          # Outras dependência para o template da facom compilar
          cmap lastpage psfrag lipsum
        ;
      };
    in {
      #packages.default = {};

      devShell = pkgs.mkShell {
        packages = [
          tex
          pkgs.ghostscript_headless
          pkgs.inkscape # Necessário para \includesvg

          pkgs.poppler_utils # Procurar por texto no Preview-pane do Emacs
          pkgs.drawio

          pkgs.zathura
          (pkgs.aspellWithDicts (dicts: with dicts; [ en pt_BR ]))
          pkgs.emacs
        ];

        shellHook = ''
          alias build="latexmk -auxdir=./out"
          alias preview="latexmk -auxdir=./out -pdf -pvc"
          alias edit="emacs -l ${./.emacs.el}"
        '';
      };
    });
}
