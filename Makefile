update: rebuild home

home:
	home-manager switch --flake .\#$$(whoami)@$$(hostname)

rebuild:
	nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update
	sudo nixos-rebuild switch --flake .\#$$(hostname)
	@if [ "$$(hostname)" = "foxflower" ]; then \
		echo "==> foxflower: restarting docker to clear stale containerd shims"; \
		sudo systemctl restart docker; \
	fi

gc:

	# remove all generations older than 7 days
	sudo nix --extra-experimental-features nix-command profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug
	nix store gc --debug

optimize:
	nix-store --optimise

############################################################################
#
#  Misc, other useful commands
#
############################################################################

fmt:
	# format the nix files in this repo
	nix fmt

nvidia-hashes:
	# regenerate all nvidia driver hashes: make nvidia-hashes V=610.57.04
	# never bump `version` in hosts/desktop/nvidia.nix without rerunning this --
	# a stale hash silently resolves to the old source instead of failing.
	@test -n "$(V)" || (echo "usage: make nvidia-hashes V=<driver-version>" && exit 2)
	@./scripts/nvidia-hashes.sh $(V)

nvidia-check:
	# verify the pending system generation's kernel module and GSP firmware agree
	@modinfo $$(find -L /nix/var/nix/profiles/system/kernel-modules/lib/modules/*/kernel/drivers/video -name 'nvidia.ko*' | head -1) | grep '^version'
	@echo -n "firmware:      "; basename $$(ls -d /nix/var/nix/profiles/system/firmware/nvidia/[0-9]*)
