#!/bin/bash

dotfiles=$HOME/.dotfiles
configdir=$HOME/.config

if [ ! -d $dotfiles ]
then
	echo "$dotfiles not found"
	exit
fi

echo "Starting ~/.config symlinks"
for file in $dotfiles/config/*
do
	target=$configdir/$( basename $file )
	if [ -e $target ]
	then
		echo "$target exists already. Skipping."
	else
		echo "Creating symlink for $file"
		ln -s $file $target
	fi
done

echo "Starting ~/ symlinks"
for file in $dotfiles/*
do
	filename=$( basename $file )
	target=$HOME/.$filename
	if [ -e $target ]
	then
		echo "$target exists already. Skipping."
	else
		if [ $filename != "install.sh" ] && [ $filename != "README.md" ]
		then
			echo "Creating symlink for $file"
			ln -s $file $target
		fi
	fi
done
