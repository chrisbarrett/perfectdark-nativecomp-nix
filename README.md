# Nix Flake for Perfect Dark

This repository packages the [Perfect Dark port to modern systems](https://github.com/fgsfdsfgs/perfect_dark) as a Nix
Flake, enabling easy installation and management of the game through Nix.

> [!IMPORTANT]
> This package only provides the game engine--you will need to download and
> install the ntsc-final ROM to run the game. Refer to the [upstream project](https://github.com/fgsfdsfgs/perfect_dark)
> for details.

> [!NOTE]
> I've only tested this on darwin-aarch64; PRs to address build issues on other
> systems are welcome.

## Quick Start

Add this Flake as an input to your flake configuration, and consume it in your flake arguments:

```nix
{
  inputs = {
    perfectdark.url = "github:chrisbarrett/perfectdark-port-nix";
  };

  outputs = { perfectdark, ... }: {
     # <snip>
  }
}
```

From there, you have a few choices in how to install Perfect Dark.

### Home Manager

This repo provides a home manager module, which integrates Perfect Dark nicely into an existing declarative config.

You need to:

1. import the overlay when instantiating Nixpkgs; this defines the `perfectdark`
   package and adds it to `pkgs`.

   ```nix
   nixpkgs.overlays = [ perfectdark.overlays.default ];
   ```

2. Import the home-manager module, which defines the configuration options.

   ```nix
   home-manager.users.dcarrington.imports = [ perfectdark.homeModules.default ];
   ```

Once you've done that, you can reference the `programs.perfectdark` options in your home-manager configuration.

```nix
{ config, ... }:
{
  programs.perfectdark = {
    enable = true;

    # See: https://github.com/fgsfdsfgs/perfect_dark/wiki/Command-line-parameters
    # for how these parameters are interpreted.

    # profile = 0;                          # Automatically select player file (based on creation order)
    # skipIntro = true;                     # Skip intro sequence
    # romFile = "pd.ntsc-final.z64";        # ROM file name/path override; can be an absolute path
  };
}
```

- On Linux, the executable will be installed at `~/.nix-profile/bin/perfectdark`.
- On macOS, the app will installed to `~/Applications/Home Manager Apps/PerfectDark.app`.

> [!TIP]
> macOS apps installed via Home Manager aren't normally indexed by Spotlight.
> Setting up [hraban/mac-app-util](https://github.com/hraban/mac-app-util) will fix this and let you launch
> PerfectDark.app via Spotlight.

### Direct package installation

You can reference the package outputs directly.

```nix
# In your flake configuration
environment.systemPackages = [ perfectdark.packages.${system}.default ];

# Or with the overlay applied
environment.systemPackages = [ pkgs.perfectdark ];
```

### Acknowledgements

- Huge thanks to the native decomp project, and to the port developers for making this gem from my childhood playable on modern hardware. ❤️
- DataDyte logo used for the macOS app icons sourced from: https://fictionalcompanies.fandom.com/wiki/DataDyne_Corporation?file=DataDyne.png (Machinedramon22)
