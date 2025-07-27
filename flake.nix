{
  description = "mdformat-myst development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        package = python.pkgs.buildPythonPackage rec {
          pname = "mdformat-myst";
          version = "0.2.1";
          pyproject = true;

          src = ./.;

          build-system = with python.pkgs; [ flit-core ];

          dependencies = with python.pkgs; [
            mdformat
            mdformat-footnote
            mdformat-frontmatter
            mdformat-tables
            mdit-py-plugins
            ruamel-yaml
          ];

          pythonImportsCheck = [ "mdformat_myst" ];
        };
      in
      {
        packages.default = package;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            (pkgs.mdformat.withPlugins (p: [
              package
            ]))
          ];
        };
      }
    );
}
