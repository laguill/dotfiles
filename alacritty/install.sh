#!/bin/bash

source ../shared.sh

install_themes () {
  # update nodejs
  npm cache clean -f
  npm install -g n
  n stable
  # install
  if npm i -g alacritty-themes; then
    success "installed the program"
    alacritty-themes Gruvbox-Dark
    success "set Gruvbox-Dark theme"
    todo "Change the alacritty theme interactively with 'alacritty-themes'. Alternatively, use 'alacritty-themes <theme>', and see here for the available themes: https://github.com/rajasegar/alacritty-themes/tree/master/themes"
  else
    fail "Could not install theme selector"
  fi
}

case "$OS" in
  "linux" )
    # install
    info "Installing app"
    sudo add-apt-repository ppa:aslatter/ppa -y    
    sudo apt install alacritty
    # config
    info "Linking config file"
    mkdir -p "$HOME/.config/alacritty/"
    link_file "./alacritty_linux.yml.symlink" "$HOME/.config/alacritty/alacritty.yml"
    # themes
    info "Installing theme selector"
    npm cache clean -f
    npm install -g n
    n stable
    install_themes
    ;;

  "windows" )
    # install
    info "Installing app"
    scoop bucket add extras
    scoop install extras/alacritty
    # config
    info "Linking config file"
    mkdir -p "$APPDATA/alacritty/"
    link_file "./alacritty_windows.yml.symlink" "$APPDATA/alacritty/alacritty.yml"
    # themes
    info "Installing theme selector"
    install_themes
    ;;
  
  "macos" )
    # install
    info "Installing app"
    brew install --cask alacritty
    # config
    info "Linking config file"
    mkdir -p "$HOME/.config/alacritty/"
    link_file "./alacritty_linux.yml.symlink" "$HOME/.config/alacritty/alacritty.yml"
    # themes
    info "Installing theme selector"
    npm cache clean -f
    npm install -g n
    n stable
    install_themes
    ;;

  * )
    ;;
esac
