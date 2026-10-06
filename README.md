# OpenWhip

![Whip divider](assets/divider.png)

Sometimes claude code is going too shlow, and you must whip him into shape..

## Install + run

```bash
npm install -g openwhip
openwhip
```

windows and mac supported out of the box, but Linux is a special snowflake so you need to install `xdotool` for keyboard automation

```bash
sudo apt install xdotool
```

## Nix / NixOS

The flake supports `x86_64-linux` and `aarch64-linux`. Enable Nix's
`nix-command` and `flakes` experimental features, then run from this repository:

```bash
nix build                       # Package is available under ./result
nix run                         # Start OpenWhip in the foreground
nix profile add .               # Install the CLI and desktop launcher
nix develop -c electron --ozone-platform=x11 .
```

The development shell includes Node.js, Electron, and `xdotool`; no `npm install`
is needed for Linux development. The package uses Electron from the pinned
nixpkgs input and includes `xdotool` automatically. The deprecated `badclaude`
command also forwards to OpenWhip.

To install declaratively, add this input to your NixOS flake:

```nix
inputs.openwhip.url = "github:GitFrog1111/OpenWhip";
```

Then include a module in your `nixosSystem`'s `modules` list, where `inputs` is
the argument to your flake's `outputs` function:

```nix
({ pkgs, ... }: {
  environment.systemPackages = [
    inputs.openwhip.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
})
```

OpenWhip needs a desktop session with a system tray. Its Nix launcher uses the
X11 backend because keyboard automation uses `xdotool`. Wayland sessions need
XWayland, and automation only works with X11/XWayland targets, not native
Wayland applications.

## Controls

- Click tray icon: spawn whip.
- Click: drop whip.
- Whip him 😩💢
- It sends an interrupt (Ctrl-C) and one of 5 encouraging messages!

## Roadmap

- [x] Initial release! 🥳
- [x] Cease and desist letter from Anthropic
- [ ] Crypto miner
- [ ] Logs of how many times you whipped claude so when the robots come we can order people nicely for them
- [ ] Updated whip physics

## Ecosystem

The OFFICAL openwhip ecosystem token. 

Contract address: BRyUZbJkm9Pty4FUmTrBGno7U4Ga8TWzcKJJRLCBpump

Stay tuned for updates on X! 👀
https://x.com/blended_jpeg
