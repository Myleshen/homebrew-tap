class Devx < Formula
  desc "macOS project, worktree, and configuration helper"
  homepage "https://github.com/Myleshen/workflow-organizer"
  license "MIT"

  # The release ships one tarball per architecture. Homebrew no longer accepts
  # url/sha256 inside on_arm/on_intel, so pick the pair from the running CPU.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Myleshen/workflow-organizer/releases/download/v0.2.0/devx-0.2.0-macos-arm64.tar.gz"
      sha256 "5674274e1fb735c43962925a112847b830518df94961ab78333a87f3106288e7"
    else
      url "https://github.com/Myleshen/workflow-organizer/releases/download/v0.2.0/devx-0.2.0-macos-x86_64.tar.gz"
      sha256 "61c6e225c156d5b95346ecefb4de5f60ff5d19c90697756ec3754ba4709bde8a"
    end
  end

  # Releases only ship macOS binaries, so Linux builds from the source tarball.
  # The launch/workspace features (open, osascript) are macOS-only and do not
  # work on Linux, but the rest of the CLI does.
  if OS.linux?
    url "https://github.com/Myleshen/workflow-organizer/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "2fdcb8d6a85772756015ce5e8c1cfad665631c0f3471d9e14fc659e88f3fd047"
  end

  on_linux do
    depends_on "rust" => :build
  end

  def install
    if OS.mac?
      bin.install "devx"
      man1.install "devx.1" if File.exist?("devx.1")
    else
      # cargo install puts the devx binary in prefix/bin itself.
      system "cargo", "install", *std_cargo_args
      man1.install "docs/devx.1" if File.exist?("docs/devx.1")
    end
  end

  test do
    assert_match "devx", shell_output("#{bin}/devx --help 2>&1")
  end
end
