#!/usr/bin/env bash

source ../shared.sh

case "$OS" in
"linux")
	info "Removing old installation"
	rm -rf "$HOME/.local/share/nvim"
	rm -rf "$HOME/.config/nvim"

	# install nvim
	info "Installing app"
	# . some utilities
	sudo apt install ripgrep
	# . app itself
	# mkdir -p "$HOME/.local/bin"
	# curl -Lo "$HOME/.local/bin/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	# chmod u+x "$HOME/.local/bin/nvim"
	#link_public_resource "$HOME/.local/bin/nvim" "nvim.appimage"
	# (alternative: install from apt, but often outdated)
	# sudo apt install neovim
	
	brew install neovim

	# virtual environment specifically for neovim plugins, in this folder
	# info "Creating python environment for neovim"
	# sudo apt install python3.11
	# poetry install
	
	# add user config
	info "Adding user configs"
	link_public_resource "./nvim" "$HOME/.config/nvim"
	link_public_resource "./alternative_configs/lazyvim" "$HOME/.config/nvim-lazyvim"
	link_public_resource "./alternative_configs/astronvim" "$HOME/.config/nvim-astronvim"
	;;

"windows")
	info "Removing old installation"
	# TODO: where is .local/share/nvim on windows?
	rm -rf "$USERPROFILE/AppData/Local/nvim"

	# install nvim
	info "Installing app"
	scoop bucket add main
	scoop install gcc
	scoop install neovim # use winget instead of scoop because of company policy.
	
	# virtual environment specifically for neovim plugins, in this folder
	info "Creating python environment for neovim"
	poetry install
	# on windows, there is no bin folder, but rather a scripts folder
	(
		cd "$USERPROFILE/.dotfiles/neovim/.venv/"
		ln -s Scripts bin
	)

	# add user config
	info "Adding user configs"
	link_public_resource "./nvim" "$USERPROFILE/AppData/Local/nvim"
	link_public_resource "./alternative_configs/lazyvim" "$USERPROFILE/AppData/Local/nvim-lazyvim"
	link_public_resource "./alternative_configs/astronvim" "$USERPROFILE/AppData/Local/nvim-astronvim"
	;;

"macos")
	info "Removing old installation"
	rm -rf "$HOME/.local/share/nvim"
	rm -rf "$HOME/.config/nvim"

	# install nvim
	info "Installing app"
	brew install neovim
	
	# virtual environment specifically for neovim plugins, in this folder
	info "Creating python environment for neovim"
	poetry install

	# add user config
	info "Adding user configs"
	link_public_resource "./nvim" "$HOME/.config/nvim"
	link_public_resource "./alternative_configs/lazyvim" "$HOME/.config/nvim-lazyvim"
	link_public_resource "./alternative_configs/astronvim" "$HOME/.config/nvim-astronvim"
	;;

"termux")
	info "Removing old installation"
	rm -rf "$HOME/.local/share/nvim"
	rm -rf "$HOME/.config/nvim"

	# install nvim
	info "Installing app"
	# . some utilities
	pkg update
	pkg install "tur-repo"
	pkg install uv ripgrep imagemagick
	pkg install neovim
	
	# virtual environment specifically for neovim plugins, in this folder
	# info "Creating python environment for neovim"
	# sudo apt install python3.11
	# poetry install
	
	# add user config
	info "Adding user configs"
	link_public_resource "./nvim" "$HOME/.config/nvim"
	link_public_resource "./alternative_configs/lazyvim" "$HOME/.config/nvim-lazyvim"
	link_public_resource "./alternative_configs/astronvim" "$HOME/.config/nvim-astronvim"
	;;


*) ;;
esac
