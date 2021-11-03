# Dotfiles

To install, clone this repository anywhere you like, and then execute the included `install.sh` script.

If using Java, coc.nvim requires lombok. As such, download the `lombok.jar` from https://projectlombok.org/download and move it to `/usr/local/share/lombok.jar`. If you don't use Java or don't care about lombok, remove the `java.jdt.ls.vmargs` value from `coc-settings.json`.

Until I get around to updating this repo for portability, this project currently assumes a macOS target environment.
