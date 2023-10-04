#!/usr/bin/env bash

source ../shared.sh

case "$OS" in
  "linux" )
    info "Installing app"
    sudo apt install i3
    info "Linking config"
    mkdir -p "$HOME/.config/i3"
    link_public_resource "./i3/config" "$HOME/.config/i3/config"
    ;;

  "windows" )
    skip
    ;;

  "macos" )
    info "Installing app(s)"
    brew install koekeishiya/formulae/yabai
    brew install skhd
    brew install jq 
    brew upgrade yabai
    info "Linking config"
    mkdir -p "$HOME/.config/yabai"
    mkdir -p "$HOME/.config/skhd"
    link_public_resource "./yabai/yabairc" "$HOME/.config/yabai/yabairc"
    link_public_resource "./yabai/skhdrc" "$HOME/.config/skhd/skhdrc"
    skhd --start-service
    yabai --start-service
    success "Yabai might only work partially. To enable completely, disable the System Integrity Protection; google 'yabai disable SIP'."
    todo "Check output below to see where SIP is disabled:"
    csrutil status
    ;;
    
  * )
    ;;
esac
