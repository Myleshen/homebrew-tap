cask "palette" do
  version "2.4.1"
  sha256 "a4acd6c999834507f5bd5c01d1558e7e2ce7d20bc21e38d5262c2ceaa406886f"

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

  # A plain `brew uninstall` is a full cleanup: no config, history, database,
  # caches, preferences, saved state or login item left behind.
  uninstall quit: "dev.myleshen.palette",
            login_item: "Palette",
            trash: [
              "~/.config/palette",
              "~/.local/state/palette",
              "~/Library/Caches/Palette",
              "~/Library/Preferences/dev.myleshen.palette.plist",
              "~/Library/Saved Application State/dev.myleshen.palette.savedState",
              "~/.hammerspoon/palette-webapps.lua",
            ]

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

    Uninstall removes that data too. macOS keeps the privacy grants, so clear
    them by hand if you are starting over:
      tccutil reset Accessibility dev.myleshen.palette
      tccutil reset ScreenCapture dev.myleshen.palette
  EOS
end
