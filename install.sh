#!/bin/bash

cd "$(dirname "$0")"
DOTFILES_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "$DOTFILES_ROOT/shared.sh"

# HELP.

Help () {
   # Display Help
  echo "Usage: '$0 [-r] NAME... | -c | -h'"
  echo "Set-up machine by running one or more install scripts."
  echo ""
  echo "options:"
  echo " (none)  Each NAME is the name of a folder in the dotfiles repo root."
  echo "         Runs the install script in each folder (in specified order)."
  echo "         Example: '$0 utils nerdfonts'"
  echo "         Runs install scripts in 'utils' and 'nerdfonts' folders."
  echo ""
  echo "   -r    Each NAME is the name of a text file in the dotfile repo root"
  echo "         containing folder names. (One folder name per line.) Runs the"
  echo "         install script in each folder (in specified order)."
  echo "         Example: '$0 -r part1'"
  echo "         Runs install scripts of the folders in the text file 'part1'."
  echo ""
  echo "   -c    Check; displays the foldernames available to install and which"
  echo "         do not yet have an install script."
  echo ""
  echo "   -h    Display this Help."
}

Error () {
  echo "Usage: '$0 [-r] NAME...'"
  echo "Try '$0 -h' for more information."
  exit 1
}

Check () {

  avail=()
  unavail=()
  for path in "$DOTFILES_ROOT"/*/; do
    foldername="$(basename "$path")"
    if [ -f "$path/install.sh" ]; then
      avail+=("$foldername")
    else
      unavail+=("$foldername")
    fi
  done
  echo "The following folders have an install script and are therefore available as arguments to this script:"
  printf "  "; printf "%s " "${avail[@]}"; echo ""
  if [ ${#unavail[@]} -gt 0 ]; then
    echo "And these folders do not have an install script (yet):"
    printf "  "; printf "%s " "${unavail[@]}"; echo ""
  fi
}

# FUNCTIONS USED IN MAIN PROGRAM.

install_files () {
  # check if all files exist
  filepaths=()
  for filename in "$@"; do
    filepath="$(realpath $filename)"
    if [ ! -f "$filepath" ]; then
      fail "$filepath does not exist or is not a file" 
      exit 1
    else
      filepaths+=("$filepath")
    fi
  done
  # execute all
  for filepath in "${filepaths[@]}"; do
    install_file "$filepath"
  done
}

install_file () {
  echo ''
  echo "Processing file $1"
  echo ''
  install_folders $(cat "$1")
}

install_folders () {
  # check if all folders exist
  folderpaths=()
  for foldername in "$@"; do
    folderpath="$DOTFILES_ROOT/$foldername"
    if [ ! -f "$folderpath/install.sh" ]; then
      fail "$folderpath/install.sh does not exist"
      exit 1
    else
      folderpaths+=("$folderpath")
    fi
  done
  # execute all
  for folderpath in "${folderpaths[@]}"; do
    install_folder "$folderpath"
  done
}

install_folder () {
  # Run the install script in a folder, i.e., in ./$1/install.sh

  local folderpath="$1"
  local foldername=$(basename "$folderpath")
  success   "┌── $foldername ─── start ────┐"
  cd "$folderpath"
  ./install.sh

  if [ $? -eq 0 ]
  then
    success "└── $foldername ─── \033[0;32msuccess\033[0m ──┘"
    successfully+=("$foldername")
  else
    fail    "└── $foldername ─── \033[0;31merror\033[0m ────┘"
    failure+=("$foldername")
  fi
}

# PARSE ARGUMENTS.

# No arguments: error
if [ $# -eq 0 ]; then 
  echo "Error: no arguments"
  Error
fi

# Get options
read_files=false
while getopts ":rhc" opt; do
  case $opt in
    c) # display available folders
      Check
      exit
      ;;
      
    h) # display help
      Help
      exit
      ;;

    r)
      read_files=true
      ;;
    
    *)
      echo "Error: invalid option."
      Error
      ;;
  esac
done
shift $((OPTIND - 1))

# PREPARE.

successful=()
failure=()

# DO ACTUAL WORK.

if [ "$read_files" = false ]; then
  install_folders "$@"
else
  install_files "$@"
fi

# SUMMARY.

echo ''
if [ ${#successfully[@]} -gt 0 ]; then
  echo "Summary: successfully finished"
  for foldername in "${successfully[@]}"; do
    success "$foldername"
  done
fi
if [ ${#failure[@]} -gt 0 ]; then
  echo "Summary: ran into error"
  for foldername in "${failure[@]}"; do
    fail "$foldername"
  done
fi
echo "Check for to-do items"
todo "In output above, check for lines starting with [\033[0;36m\033[1mTODO\033[0m]. They indicate to-do items, like (private) files or folders that must still be created."
