SHELL=/bin/bash

CONFIG_DIRS_DOTFILES := $(wildcard dotfiles/.config/*)
CONFIG_DIRS_HOME := $(subst dotfiles, ~, $(CONFIG_DIRS_DOTFILES))

.PHONY: help
help: ## Show make help
	@IFS=$$'\n' ; \
		help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
		printf "%-30s %s\n" "Target" "Help" ; \
		printf "%-30s %s\n" "------" "----" ; \
		for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-30s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
		done

.PHONY: system_setup
system_setup:
	ansible-playbook \
		--ask-become-pass \
		--inventory=inventory/localhost \
		$@.yml

.PHONY: dotfiles
dotfiles: config_directories ## Place dotfiles in home folder, replacing all owned by stow
	stow -t ~ -R $@/

.PHONY: config_directories
config_directories: $(CONFIG_DIRS_HOME)  ## Create directories in ~/.config. Useful because these directories might not exist yet
~/.config/%: dotfiles/.config/%
	-mkdir -p $@

.PHONY: default
default: ## By default make runs help
	@help



