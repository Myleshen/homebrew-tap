class Atlas < Formula
  desc "Index every Markdown and HTML artifact under your scanned roots"
  homepage "https://github.com/Myleshen/atlas"
  url "https://github.com/Myleshen/atlas/releases/download/v1.8.0/atlas-1.8.0.tar.gz"
  sha256 "0c3d46a6241a66ea643914c32e28623807f521dd8333381ad399b3a3729e4e7b"
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
