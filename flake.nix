{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) ocamlPackages;
      tools = with ocamlPackages; [ ocaml ocaml-lsp utop findlib dune_3 ];
      bondi = ocamlPackages.buildDunePackage {
        pname = "bondi";
        buildInputs = [ ocamlPackages.base ];
        version = "unstable-2023-06-19";
        src = ./.;
      };
    in
    {
      packages.${system}.default = bondi;
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = tools ++ [ pkgs.ocamlformat ];
      };

    };
}
