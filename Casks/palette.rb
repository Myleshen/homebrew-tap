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

  # Reset the privacy grants while the app still exists: `tccutil reset` fails
  # once the bundle is gone. `|| true` because a missing grant is not an error.
  uninstall_preflight_steps do
    run "/bin/sh", args: ["-c", "/usr/bin/tccutil reset Accessibility dev.myleshen.palette || true"]
    run "/bin/sh", args: ["-c", "/usr/bin/tccutil reset ScreenCapture dev.myleshen.palette || true"]
  end

  # Declarative steps, not a Ruby block, so the cask is not executable code.
  # `delete:` cannot be used for `~` paths: Homebrew runs it under sudo without
  # expanding the tilde.
  uninstall_postflight_steps do
    run "/bin/rm", args: [
      "-rf",
      File.expand_path("~/.config/palette"),
      File.expand_path("~/.local/state/palette"),
      File.expand_path("~/Library/Caches/Palette"),
      File.expand_path("~/Library/Preferences/dev.myleshen.palette.plist"),
      File.expand_path("~/Library/Saved Application State/dev.myleshen.palette.savedState"),
      File.expand_path("~/.hammerspoon/palette-webapps.lua"),
    ]
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
