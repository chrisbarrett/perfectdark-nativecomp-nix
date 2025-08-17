# Nix Flake for Perfect Dark

This repository packages the [Perfect Dark port](https://github.com/fgsfdsfgs/perfect_dark) as a Nix flake, enabling easy installation and management of the game through Nix.

## About

Perfect Dark is a reverse-engineered port of the classic N64 game Perfect Dark to modern platforms. This flake packages the native compilation project, allowing you to build and run Perfect Dark on Linux and macOS systems.

## Features

- **Cross-platform support**: Works on both Linux and macOS (Darwin)
- **macOS app bundle**: On macOS, creates a proper `.app` bundle with bundled dependencies
- **Home Manager integration**: Includes a Home Manager module for easy system integration
- **Clean builds**: Handles compiler warnings and platform-specific build requirements

## Quick Start

### With Home Manager

Add to your Home Manager configuration:

```nix
{
  inputs = {
    perfectdark.url = "github:chrisbarrett/perfectdark-nativecomp-nix";
  };

  outputs = { home-manager, perfectdark, ... }: {
    homeConfigurations.dcarrington = home-manager.lib.homeManagerConfiguration {
      modules = [
        perfectdark.homeManagerModules.default
        {
          programs.perfectdark.enable = true;
        }
      ];
    };
  };
}
```

### Building Locally

```bash
git clone https://github.com/chrisbarrett/perfectdark-nativecomp-nix.git
cd perfectdark-nativecomp-nix
nix build
```

## Game Data Requirements

**Important**: This package only provides the game engine. You will need to provide your own Perfect Dark ROM data files to play the game. The game will look for these files in the appropriate directories when launched.

Refer to the [upstream project documentation](https://github.com/fgsfdsfgs/perfect_dark) for details on setting up game data.

## Platform Support

- **Linux**: Builds as a standard executable
- **macOS**: Creates a proper macOS application bundle at `Applications/PerfectDark.app` with:
  - Bundled dynamic libraries (SDL2, zlib)
  - Fixed library paths for portability
  - Proper app metadata and icon

## Development

The flake includes several components:

- `packages/builder.nix`: Core build logic shared between platforms
- `packages/darwin.nix`: macOS-specific configuration and app bundling
- `packages/linux.nix`: Linux-specific configuration
- `packages/version.json`: Upstream version and hash information

### Updating the Package

To update to a newer version of the upstream project:

1. Update the `rev` and `hash` fields in `packages/version.json`
2. Test the build: `nix build`
3. Commit and push the changes
