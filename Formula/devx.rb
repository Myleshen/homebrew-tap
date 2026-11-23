class Devx < Formula
  desc "macOS project, worktree, and configuration helper"
  homepage "https://github.com/Myleshen/workflow-organizer"

  on_arm do
    url "https://github.com/Myleshen/workflow-organizer/releases/download/v0.2.0/devx-0.2.0-macos-arm64.tar.gz"
    sha256 "5674274e1fb735c43962925a112847b830518df94961ab78333a87f3106288e7"
  end

  on_intel do
    url "https://github.com/Myleshen/workflow-organizer/releases/download/v0.2.0/devx-0.2.0-macos-x86_64.tar.gz"
    sha256 "61c6e225c156d5b95346ecefb4de5f60ff5d19c90697756ec3754ba4709bde8a"
  end

  license "MIT"
  version "0.2.0"

  depends_on :macos

  def install
    bin.install "devx"
    man1.install "devx.1" if File.exist?("devx.1")
  end

  test do
    assert_match "devx", shell_output("#{bin}/devx --help 2>&1")
  end
end
