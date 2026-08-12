#!/usr/bin/env bash
#
# Print a ready-to-paste `hardware.nvidia.package` block for a given NVIDIA
# driver version, with every hash fetched fresh from upstream.
#
#   ./scripts/nvidia-hashes.sh 610.57.04
#   ./scripts/nvidia-hashes.sh 610.57.04 --no-aarch64
#
# Why this exists: the hashes in hosts/desktop/nvidia.nix are fixed-output
# derivation hashes. Nix resolves an FOD purely by its hash, so a *stale* hash
# left over from a previous version silently resolves to that old source
# instead of failing the build -- you get a driver whose kernel module and
# userspace are different versions. Always regenerate all of them together.

set -euo pipefail

VERSION="${1:-}"
WANT_AARCH64=1
for arg in "${@:2}"; do
	case "$arg" in
	--no-aarch64) WANT_AARCH64=0 ;;
	*)
		echo "unknown option: $arg" >&2
		exit 2
		;;
	esac
done

if [ -z "$VERSION" ]; then
	echo "usage: $0 <driver-version> [--no-aarch64]" >&2
	echo "example: $0 610.57.04" >&2
	exit 2
fi

# Flat file hash (fetchurl): hash of the bytes as-is.
prefetch_file() {
	nix store prefetch-file --json "$1" | jq -r .hash
}

# NAR hash (fetchFromGitHub/fetchzip): hash of the unpacked tree.
prefetch_unpack() {
	nix store prefetch-file --unpack --json "$1" | jq -r .hash
}

gh_tag() { echo "https://github.com/NVIDIA/$1/archive/refs/tags/${VERSION}.tar.gz"; }

echo "==> fetching hashes for NVIDIA ${VERSION} (this downloads the .run installers)" >&2

echo "  .. x86_64 driver" >&2
SHA_64=$(prefetch_file \
	"https://us.download.nvidia.com/XFree86/Linux-x86_64/${VERSION}/NVIDIA-Linux-x86_64-${VERSION}.run")

if [ "$WANT_AARCH64" = 1 ]; then
	echo "  .. aarch64 driver" >&2
	SHA_ARM=$(prefetch_file \
		"https://us.download.nvidia.com/XFree86/Linux-aarch64/${VERSION}/NVIDIA-Linux-aarch64-${VERSION}.run")
fi

echo "  .. open-gpu-kernel-modules" >&2
SHA_OPEN=$(prefetch_unpack "$(gh_tag open-gpu-kernel-modules)")

echo "  .. nvidia-settings" >&2
SHA_SETTINGS=$(prefetch_unpack "$(gh_tag nvidia-settings)")

echo "  .. nvidia-persistenced" >&2
SHA_PERSISTENCED=$(prefetch_unpack "$(gh_tag nvidia-persistenced)")

cat <<EOF

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "${VERSION}";
    sha256_64bit = "${SHA_64}";
EOF
if [ "$WANT_AARCH64" = 1 ]; then
	echo "    sha256_aarch64 = \"${SHA_ARM}\";"
fi
cat <<EOF
    openSha256 = "${SHA_OPEN}";
    settingsSha256 = "${SHA_SETTINGS}";
    persistencedSha256 = "${SHA_PERSISTENCED}";
  };
EOF
