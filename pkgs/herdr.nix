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
  applyPatches,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr";
  version = "0.7.4";

  __structuredAttrs = true;

  # deps.files.ghostty.org の wuffs tarball が再パッケージされ、vendor が宣言する
  # zig ハッシュと不一致でフェッチできない (2026-07-16、ghostty 本家も未追従)。
  # 新 tarball は google/wuffs v0.4.0-alpha.9 の公式タグと diff -r で完全一致を確認済みのため、
  # 宣言ハッシュを実物に合わせて書き換える
  src = applyPatches {
    name = "herdr-${finalAttrs.version}-src";
    src = fetchFromGitHub {
      owner = "ogulcancelik";
      repo = "herdr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dBOQYLFitJ+E3XNz44Ag3CIrBxFj16CmVPp7qil0ssg=";
    };
    postPatch = ''
      substituteInPlace vendor/libghostty-vt/pkg/wuffs/build.zig.zon \
        --replace-fail "N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs" \
                       "N-V-__8AAEXUywEb8JCSytwiCVUsFb2CwHjOB59jhyRhOhsj"
    '';
  };

  cargoHash = "sha256-XHzZy2tKLbMQy4POmXowUcGf77ZPunG/oQ3P2wOoVls=";

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/libghostty-vt";
    fetchAll = true;
    hash = "sha256-Fw6+P80pHjh7qa8lHuVTOlszU4rQOEx5BEs6G3nCpsQ=";
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
