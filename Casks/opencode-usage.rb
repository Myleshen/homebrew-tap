cask "opencode-usage" do
  version :latest
  sha256 :no_check

  # Latest release asset: drives both install and `brew upgrade`.
  url "https://github.com/Myleshen/mac-opencode-usage/releases/latest/download/OpenCodeUsage.zip"
  name "OpenCode Usage"
  desc "Menu bar monitor for OpenCode Go usage"
  homepage "https://github.com/Myleshen/mac-opencode-usage"

  depends_on macos: ">= :sonoma"

  app "OpenCodeUsage.app"

  # Ad-hoc signed, not notarised: without this Gatekeeper calls the app damaged
  # the first time it is opened after a quarantined download.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/OpenCodeUsage.app"]
  end

  uninstall launchctl: "dev.myleshen.opencode-usage",
            quit:      "dev.myleshen.opencode-usage"

  zap trash: [
    "~/Library/Application Support/OpenCodeUsage.lock",
    "~/Library/Preferences/dev.myleshen.opencode-usage.plist",
  ]
end
