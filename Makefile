update: rebuild home

home:
	home-manager switch --flake .\#$$(whoami)@$$(hostname)

rebuild:
	nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update
	sudo nixos-rebuild switch --flake .\#$$(hostname)

gc:

	# remove all generations older than 7 days
	sudo nix --extra-experimental-features nix-command profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug

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
