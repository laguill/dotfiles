# dotfiles

## Structure

```
dotfiles/
├── shared.sh   # functionality used across install files
├── install     # installs apps; run './install -h' for more information
├── part1       # text file with app folder names (to install at once)
│
├── app_folder1/      # One folder per application
│    └── install.sh   # installs the app and its configuration, creates symlinks, etc.
│
├── app_folder2/
│    ├── install.sh
│    ├── bashrc              # Other files...
│    ├── aliases/            # ...and folders are used in the installation process. They may also be linked to.
│    └── (no secrets here)   # Password files etc are not stored in this public repository. Instead, the install script
│                            # creates a symlink to a file or folder in the ~/.secrets/ folder (so, in the user's home
│                            # folder). In order to inform the user, which files and folders are used as the source of
│                            # a symlink, a message is displayed during the installation process...
├── secrets/                 # ...and also, an empty text file with the same name is created in this folder. The user
│                            # can compare its contents with that of `~/.secrets/`, to see if anything is missing.
│
.
.
```

There is one folder per application.

Each folder contains an `install.sh` script, which installs the necessary software, creates the necessary symlinks, etc. It is not called directly by the user.

In the root, there is a `shared.sh` file, which contains some functionality used in the individual `install.sh` files. This file is also not called directly by the user.

## Installation

The repository must live in the `.dotfiles/` folder, directly under the user's home folder. 

The best way to get the files there is by cloning the repository, so that any changes can be commited and push back to github. Cloning can be done using `git`, if it's already installed on the system, using 

```bash
git clone https://github.com/laguill/dotfiles.git ~/.dotfiles
``` 

Alternatively, if `git` is not yet installed, the repository can be manually downloaded and copied to the `.dotfiles/` folder, and the clone command can be ran after `git` has been installed (git installation is done by this repository).

## Usage

In the root, there is an `install` script, which is the only file you need to run.

- On Linux, run it from a bash terminal.

- On Windows, run it from git bash.

- On Mac, run it from a bash terminal.

The script takes one or more app (=folder) names as arguments, and also allows for the usage of text files; see `./install -h` for help.

NB: the individual app's `install.sh` files are not meant to be called directly. To install the `app_folder1`, we don't run `./app_folder1/install.sh`, but rather 

```bash
./install app_folder1
```

### Secrets

After the installer script has completed correctly, we need to handle the secret files and folders that contain private information such as passwords.

For this, we can check the `secrets` folder inside the dotfiles repository. Let's say the following symlink is created:

    ```
    ~/.config/espanso                                        # Location on filesystem where app looks for its data
    -->  ~/.secrets/espanso                                  # Symlink created by install.sh
    ```

As this link is pointing to a location outside of the repository, namely, inside `~/.secrets/`, the script also created an empty textfile with the same name in the `dotfiles/secrets/` folder:

    ```
    .../this_dotfiles_repository/secrets/espanso             # empty textfile
    ```

This file serves as a reminder, which resources are expected in `~/.secrets/`. The user can go to the `~/.secrets/` folder (create it if not yet existing), and create the resource called (`espanso`) inside it.

Of course, instead of copying the resource into this folder, the user can also create a (secondary) symlink from elsewhere. Or, instead of creating the `~/.secrets/` folder, the user can also choose symlink to the entire folder instead of the individual items it contains.

## Development

When adding an application, copy the `.template` folder, an example install file can be found inside.

Also add the foldername to `part1` or `part2` or (...), so that it is installed when running 

```bash
./install -r part1
```

## Details / conventions

Even the target of a hidden file (e.g., `.bashrc`) will not start with a dot (and will be e.g. `bashrc`). This is to make them visible and distinct from other files.
