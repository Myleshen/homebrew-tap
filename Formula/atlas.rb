class Atlas < Formula
  desc "Index every Markdown and HTML artifact under your scanned roots"
  homepage "https://github.com/Myleshen/atlas"
  url "https://github.com/Myleshen/atlas/releases/download/v1.7.0/atlas-1.7.0.tar.gz"
  sha256 "81f48952e35ab71a9f393a9177c346a3a88edf54d180d627c1be376e62609801"
  license "MIT"

  depends_on "cmark-gfm"
  uses_from_macos "python"

  # Linuxbrew does not guarantee a python3 on PATH, so depend on the formula and
  # point the installed script's shebang at it. macOS keeps the system python.
  on_linux do
    depends_on "python@3.13"
  end

  def install
    if OS.linux?
      inreplace "atlas", "#!/usr/bin/env python3", "#!#{formula_opt_bin("python@3.13")}/python3"
    end

    bin.install "atlas"
  end

  test do
    assert_match "self-test ok", shell_output("#{bin}/atlas --self-test")
  end
end
