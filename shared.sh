#!/bin/bash

# General functions and variables used in other scripts.


# set -e


info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}


link_file () {
  local src="$(realpath $1)" dst=$(realpath -se $2) # create absolute paths

  local overwrite= backup= skip=
  local action=
  
  if [ ! -f $src ] && [ ! -d $src ]
  then
    fail "source $src does not exist"
    exit 1
  fi
  
  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"
       
      if [ "$currentSrc" == "$src" ]
      then

        skip=true
        skipwhy="because the source is already correct"

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
        skipwhy=""

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      if rm -rf "$dst"
      then
        success "removed $dst"
      else
        fail "could not remove $dst"
        exit 1
      fi
    fi

    if [ "$backup" == "true" ]
    then
      if mv "$dst" "${dst}.backup"
      then
        success "moved $dst to ${dst}.backup"
      else
        fail "could not move $dst to ${dst}.backup"
        exit 1
      fi
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped linking $src to $dst $skipwhy"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    if ln -s "$src" "$dst"
    then
      success "linked $src to $dst"
    else
      fail "could not link $src to $dst"
      exit 1
    fi
  fi
}


OS_long="$(uname --all)"
if [[ "${OS_long,,}" == *"gnu/linux"* ]]
then
  OS="linux"
elif [[ "${OS_long,,}" == *"mingw"* ]]
then
  OS="windows"
else
  fail "unknown operating system. Value of uname --all is $OS_long"
fi
