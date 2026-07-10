{ lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./work.local.nix) ./work.local.nix;
}
