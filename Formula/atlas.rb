class Atlas < Formula
  desc "Index every Markdown and HTML artifact under your scanned roots"
  homepage "https://github.com/Myleshen/atlas"
  url "https://github.com/Myleshen/atlas/releases/download/v1.9.0/atlas-1.9.0.tar.gz"
  sha256 "d962907ae881622fc5e1ff77f4067bcb25670b192f03d9e1b7cf19ab16ec9cc7"
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
