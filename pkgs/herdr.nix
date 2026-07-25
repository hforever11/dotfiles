# nixpkgs master (0.7.3) の pkgs/by-name/he/herdr/package.nix を 0.7.4 へ bump した一時 overlay。
# 0.7.4 は type = "shell" キーバインドのゾンビリーク修正 (#1360) を含む。
# nixpkgs の herdr が 0.7.4 以上になったらこのファイルと darwin/default.nix の overlay を削除する。
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  zig_0_15,
  cctools,
  xcbuild,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr";
  version = "0.7.4";

  __structuredAttrs = true;

  # 以前は deps.files.ghostty.org の wuffs tarball 再パッケージに伴う zig ハッシュ不一致を
  # postPatch で回避していたが、vendor 側が実物のハッシュ
  # (N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs) を宣言するよう修正されたため不要になった。
  src = fetchFromGitHub {
    owner = "ogulcancelik";
    repo = "herdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dBOQYLFitJ+E3XNz44Ag3CIrBxFj16CmVPp7qil0ssg=";
  };

  cargoHash = "sha256-XHzZy2tKLbMQy4POmXowUcGf77ZPunG/oQ3P2wOoVls=";

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/libghostty-vt";
    fetchAll = true;
    hash = "sha256-pgGu8+NwvFcj6SrN4VaTHLeHdA7QY731ctyrHZwgFAc=";
  };

  nativeBuildInputs = [
    zig_0_15.hook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  # Upstream binary tests are renamed, added, or changed between releases and
  # depend on host process details, so Nix-only patches for them are brittle.
  doCheck = false;

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  postConfigure = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Agent multiplexer that lives in your terminal";
    homepage = "https://herdr.dev";
    changelog = "https://github.com/ogulcancelik/herdr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "herdr";
    platforms = lib.platforms.unix;
  };
})
