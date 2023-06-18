{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) ocamlPackages;
      tools = with ocamlPackages; [ ocaml-lsp utop findlib dune_3 base ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = tools ++ (with pkgs; [ ocaml ocamlformat opam ]);
        buildInputs = with ocamlPackages; [ angstrom angstrom-unix ];
      };
    };
}
