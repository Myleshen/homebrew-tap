cask "opencode-usage" do
  version "1.0.21"
  sha256 "db3d3e1b16641bf04e98f68256fec54af584a193c0bac12c2e56ceb3da7287ae"

  # Pinned to the tagged asset so `brew upgrade` sees a newer version. Bump
  # version + sha256 here for each app release; :latest would not upgrade.
  url "https://github.com/Myleshen/mac-opencode-usage/releases/download/v#{version}/OpenCodeUsage.zip"
  name "OpenCode Usage"
  desc "Menu bar monitor for OpenCode Go usage"
  homepage "https://github.com/Myleshen/mac-opencode-usage"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "OpenCodeUsage.app"

  # Ad-hoc signed, not notarised: without this Gatekeeper calls the app damaged
  # the first time it is opened after a quarantined download.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "/Applications/OpenCodeUsage.app"]
  end

  uninstall launchctl: "dev.myleshen.opencode-usage",
            quit:      "dev.myleshen.opencode-usage"

  zap trash: [
    "~/Library/Application Support/OpenCodeUsage.lock",
    "~/Library/Preferences/dev.myleshen.opencode-usage.plist",
  ]
end
