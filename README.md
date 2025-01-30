# Dotfiles #
A collection of mojo-preserving configuration files. Makes a handsome environment.

### Some neat thing(s): ###

**install.sh** -- clones the structure of this directory into your home directory using symbolic links.

**git submodules** -- all kinds of external dependencies are referenced as git submodules. Just run `git submodule init` before running the installer.

## Random tricks

### Generating a base64 encoded string from a png

```
openssl base64 -in notebook-favicon.png | tr -d '\n' | pbcopy
```
