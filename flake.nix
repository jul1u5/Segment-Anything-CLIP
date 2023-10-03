{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: {
        devShells.default = let
          fhs = pkgs.buildFHSUserEnv {
            name = "bamba";

            targetPkgs = _: [
              pkgs.micromamba
              pkgs.libGL
            ];

            profile = ''
              set -e
              eval "$(micromamba shell hook -s posix)"
              export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
              micromamba activate clip
              set +e
            '';
          };
        in
          pkgs.mkShell {
            packages = [fhs];
          };
      };
    };
}
