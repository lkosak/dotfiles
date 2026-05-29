# Dotfiles #
A collection of mojo-preserving configuration files. Makes a handsome environment.

### Some neat thing(s): ###

**install.sh** -- clones the structure of this directory into your home directory using symbolic links.

**git submodules** -- all kinds of external dependencies are referenced as git submodules. Just run `git submodule init` before running the installer.

## Preferred mic auto-switcher

`bin/preferred-mic` automatically switches the system audio **input** to a
preferred microphone (the DJI "Wireless Mic Rx") whenever it's available, so you
never have to open System Settings after powering it on.

It's run by a per-user launchd agent (`LaunchAgents/com.local.PreferredMic.plist`),
which `install.sh` symlinks into `~/Library/LaunchAgents` and loads. The agent
runs the script at login (`RunAtLoad`) and every 10 seconds (`StartInterval`).
Each run checks the current input device and, if the preferred mic is plugged in
but not selected, switches to it via `SwitchAudioSource`.

### Setup / reproducing on another machine

```bash
# 1. Install the only dependency.
brew install switchaudio-osx

# 2. install.sh links bin/ -> ~/bin, links the plist, and loads the agent.
./install.sh

# 3. Confirm the agent is registered and healthy (last exit code should be 0).
launchctl list | grep PreferredMic
launchctl print "gui/$(id -u)/com.local.PreferredMic" | grep -iE "state|last exit|runs"
```

To use a different microphone, change the device name in `bin/preferred-mic` to
match what `SwitchAudioSource -t input -a` reports for your device. The script
prepends `/opt/homebrew/bin` to `PATH` so launchd (which runs with a bare PATH)
can find `SwitchAudioSource`; on an Intel Mac, change that to `/usr/local/bin`.

To stop and remove the agent:

```bash
launchctl bootout "gui/$(id -u)/com.local.PreferredMic"
```

## Random tricks

### Generating a base64 encoded string from a png

```
openssl base64 -in notebook-favicon.png | tr -d '\n' | pbcopy
```
