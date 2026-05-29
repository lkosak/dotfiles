# Dotfiles #
A collection of mojo-preserving configuration files. Makes a handsome environment.

### Some neat thing(s): ###

**install.sh** -- clones the structure of this directory into your home directory using symbolic links.

**git submodules** -- all kinds of external dependencies are referenced as git submodules. Just run `git submodule init` before running the installer.

## Preferred mic auto-switcher

`bin/preferred-mic` automatically switches the system audio **input** to a
preferred microphone (the DJI "Wireless Mic Rx") whenever it's available, so you
never have to open System Settings after powering it on.

It's run by a per-user launchd agent (`LaunchAgents/com.local.PreferredMic.plist`).
The agent runs the script at login (`RunAtLoad`) and every 10 seconds
(`StartInterval`); each run checks the current input device and, if the preferred
mic is plugged in but not selected, switches to it via `SwitchAudioSource`.

`install.sh` symlinks the plist into `~/Library/LaunchAgents` but does **not**
load it — loading is a manual step (see below), so it only happens on machines
where you actually want it.

### Setup (with these dotfiles)

```bash
# 1. Install the only dependency.
brew install switchaudio-osx

# 2. install.sh links bin/ -> ~/bin and symlinks the plist (does not load it).
./install.sh

# 3. Load the agent.
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.local.PreferredMic.plist

# 4. Confirm it's registered and healthy (last exit code should be 0).
launchctl list | grep PreferredMic
launchctl print "gui/$(id -u)/com.local.PreferredMic" | grep -iE "state|last exit|runs"
```

### Setup (manual, without these dotfiles)

For reproducing on a machine that doesn't use this repo:

```bash
# 1. Install the dependency.
brew install switchaudio-osx

# 2. Copy the script somewhere stable and make it executable.
mkdir -p ~/bin
cp bin/preferred-mic ~/bin/preferred-mic
chmod +x ~/bin/preferred-mic

# 3. Write the launch agent, pointing ProgramArguments at that absolute path.
cat > ~/Library/LaunchAgents/com.local.PreferredMic.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.PreferredMic</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/bin/preferred-mic</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>10</integer>
</dict>
</plist>
EOF

# 4. Load and verify.
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.local.PreferredMic.plist
launchctl list | grep PreferredMic
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
