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

  # A plain `brew uninstall` is a full cleanup. `delete:` cannot be used here:
  # Homebrew runs it through sudo without expanding `~`, which fails outside a
  # terminal. This block runs as the user, so it also clears the privacy grants
  # that macOS otherwise keeps forever.
  uninstall quit: "dev.myleshen.palette",
            login_item: "Palette"

  uninstall_postflight do
    [
      "~/.config/palette",
      "~/.local/state/palette",
      "~/Library/Caches/Palette",
      "~/Library/Preferences/dev.myleshen.palette.plist",
      "~/Library/Saved Application State/dev.myleshen.palette.savedState",
      "~/.hammerspoon/palette-webapps.lua",
    ].each { |path| FileUtils.rm_rf(File.expand_path(path)) }

    system_command "/usr/bin/tccutil", args: ["reset", "Accessibility", "dev.myleshen.palette"]
    system_command "/usr/bin/tccutil", args: ["reset", "ScreenCapture", "dev.myleshen.palette"]
  end

  caveats <<~EOS
    Palette is free and ad-hoc signed, so it is not notarized by Apple. If macOS
    blocks the first launch, allow it in System Settings > Privacy & Security, or
    reinstall with:
      brew install --cask --no-quarantine Myleshen/tap/palette

    Grant Accessibility to enable direct paste:
      System Settings > Privacy & Security > Accessibility

    Config and providers: ~/.config/palette
    Logs: ~/.local/state/palette/palette.log

    `brew uninstall --cask palette` removes the app, its config, history,
    caches, preferences and login item, and resets the Accessibility and Screen
    Recording grants, so the next install starts from nothing.
  EOS
end
