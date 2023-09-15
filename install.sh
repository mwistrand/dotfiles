#!/usr/bin/env bash

DOTFILES="$(pwd)"

get_symlinks() {
	find -H "$DOTFILES" -maxdepth 2 -name "*.symlink"
}

symlink_files_in_dir() {
	name=${1}

	echo "installing to ~/.${name}"
	if [ ! -d "$HOME/.${name}" ]; then
		echo "Creating ~/.${name}"
		mkdir -p "$HOME/.${name}"
	fi

	src="$DOTFILES/${name}"
	files=$(find "${src}" -maxdepth 1 -not -path "${src}" 2>/dev/null)
	for file in $files; do
	    target="$HOME/.${name}/$(basename "$file")"
	    if [ -e "$target" ]; then
			echo "~${target#$HOME} already exists... Skipping."
	    else
			echo "Creating symlink for $file"
			ln -s "$file" "$target"
	    fi
	done
}

create_symlinks() {
	echo -e "Creating symlinks..."

	for file in $(get_symlinks) ; do
		target="$HOME/.$(basename "$file" ".symlink")"
		if [ -e "$target" ]; then
			echo "~${target#$HOME} already exists... Skipping."
		else
			echo "Creating symlink for $file"
			ln -s "$file" "$target"
		fi
	done

	symlink_files_in_dir "config"
	symlink_files_in_dir "clojure"
}

create_language_files() {
	echo -e "Creating language files for ltex..."
	mkdir -p "$HOME/.config/spell"
	touch "$HOME/.config/spell/en.utf-8.add"
}

install_brew_packages() {
	if [ "$(uname)" == "Darwin" ]; then
		echo -e "Install homebrew packages?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes )
					if test ! "$(command -v brew)"; then
						echo "Homebrew not installed. Installing."
						# Run as a login shell (non-interactive) so that the script doesn't pause for user input
						curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
					fi

					# install brew dependencies from Brewfile
					brew bundle

					# install fzf
					echo "Installing fzf"
					"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
					break;;

				No )
					exit;;
			esac
		done
	fi
}

fix_terminfo() {
	echo -e "Fixing italics in tmux..."
	tic -x "$DOTFILES/terminfo/italics.terminfo"
}

create_symlinks
create_language_files
install_brew_packages
fix_terminfo
