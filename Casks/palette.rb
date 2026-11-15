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

  # Privacy grants can only be reset while the bundle still exists, and the app
  # must be gone before its database and caches can be removed.
  uninstall_preflight_steps do
    run "/bin/sh", args: ["-c", <<~SH]
      /usr/bin/osascript -e 'tell application id "dev.myleshen.palette" to quit' >/dev/null 2>&1 || true
      /bin/sleep 1
      /usr/bin/tccutil reset Accessibility dev.myleshen.palette >/dev/null 2>&1 || true
      /usr/bin/tccutil reset ScreenCapture dev.myleshen.palette >/dev/null 2>&1 || true
    SH
  end

  # One best-effort pass, so a single stubborn path can never leave the cask
  # half-uninstalled. `delete:` is unusable here: Homebrew runs it under sudo
  # without expanding `~`.
  uninstall_postflight_steps do
    run "/bin/sh", args: ["-c", <<~SH]
      /bin/rm -rf \
        "$HOME/.config/palette" \
        "$HOME/.local/state/palette" \
        "$HOME/Library/Caches/Palette" \
        "$HOME/Library/Preferences/dev.myleshen.palette.plist" \
        "$HOME/Library/Saved Application State/dev.myleshen.palette.savedState" \
        "$HOME/.hammerspoon/palette-webapps.lua" 2>/dev/null || true
    SH
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
