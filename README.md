# Palette tap

```sh
brew install --cask Myleshen/tap/palette
```

## opencode-usage

```sh
brew install --cask Myleshen/tap/opencode-usage
brew upgrade --cask opencode-usage    # picks up new releases
```

The cask is pinned to the tagged release (`version` + `sha256`), so `brew
upgrade` works. Bump both here whenever the app publishes a release.

## atlas

```sh
brew install Myleshen/tap/atlas
```

## devx

```sh
brew install Myleshen/tap/devx
```

Both formulae are pinned to the tagged release and install on macOS and
Linuxbrew. `devx` ships one macOS tarball per architecture; the formula picks
`arm64` or `x86_64` from the running CPU and builds from source on Linux, where
the macOS-only launch features are unavailable. `atlas` is pure Python.
