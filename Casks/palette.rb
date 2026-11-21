cask "palette" do
  version "2.8.0"
  sha256 "891f90fe79875a905595e196fbee0b23e4ce4c1fffafd91486d8cf3f4159811d"

  url "https://github.com/Myleshen/palette/releases/download/v#{version}/Palette-#{version}.zip"
  name "Palette"
  desc "Keyboard-first launcher with extensible providers"
  homepage "https://github.com/Myleshen/palette"

  depends_on macos: :sonoma
  depends_on formula: "fd"
  depends_on formula: "fzf"

  app "Palette.app"

  # Ad-hoc signed, so Gatekeeper cannot verify it; clear the download flag the
  # same way `--no-quarantine` does for other unsigned casks.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "/Applications/Palette.app"]
  end

  # A plain `brew uninstall` is a full cleanup. `delete:` cannot be used here:
  # Homebrew runs it through sudo without expanding `~`, which fails outside a
  # terminal. This block runs as the user, so it also clears the privacy grants
  # that macOS otherwise keeps forever.
  uninstall quit: "dev.myleshen.palette",
            login_item: "Palette"

  # Everything Palette writes lives under these paths, so `brew uninstall --zap`
  # is a full reset. A plain uninstall leaves them, like any cask.
  uninstall quit: "dev.myleshen.palette",
            login_item: "Palette"

  zap trash: [
    "~/.config/palette",
    "~/.local/state/palette",
    "~/Library/Caches/Palette",
    "~/Library/Preferences/dev.myleshen.palette.plist",
    "~/Library/Saved Application State/dev.myleshen.palette.savedState",
    "~/.hammerspoon/palette-webapps.lua",
  ]

  caveats <<~EOS
    Palette is free and ad-hoc signed, so it is not notarized by Apple. If macOS
    blocks the first launch, allow it in System Settings > Privacy & Security, or
    reinstall with:
      brew install --cask --no-quarantine Myleshen/tap/palette

    Grant Accessibility to enable direct paste:
      System Settings > Privacy & Security > Accessibility

    Config and providers: ~/.config/palette
    Logs: ~/.local/state/palette/palette.log

    Full reset before a clean install:
      brew uninstall --cask --zap palette
      tccutil reset Accessibility dev.myleshen.palette
      tccutil reset ScreenCapture dev.myleshen.palette
    The cask cannot reset the privacy grants itself; macOS only allows that with
    tccutil, and Homebrew casks cannot run commands on uninstall.
  EOS
end
