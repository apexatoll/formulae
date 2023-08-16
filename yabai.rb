class Yabai < Formula
  desc "A tiling window manager for macOS based on binary space partitioning."
  homepage "https://github.com/koekeishiya/yabai"
  url "https://github.com/koekeishiya/yabai/releases/download/v4.0.4/yabai-v4.0.4.tar.gz"
  sha256 "3b1fa2654c03182214f86b302126e59db546acd8c5dee5b30648afd8ef6addf8"
  head "https://github.com/koekeishiya/yabai.git"

  depends_on :macos => :high_sierra

  def install
    (var/"log/yabai").mkpath
    man.mkpath

    if build.head?
      system "make", "-j1", "install"
    end

    bin.install "#{buildpath}/bin/yabai"
    (pkgshare/"examples").install "#{buildpath}/examples/yabairc"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
    man1.install "#{buildpath}/doc/yabai.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/yabairc ~/.yabairc
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    Logs will be found in
      #{var}/log/yabai/yabai.[out|err].log
    EOS
  end

  service do
    run "#{opt_bin}/yabai"
    environment_variables PATH: std_service_path_env
    keep_alive true
    log_path "#{var}/log/yabai/yabai.out.log"
    error_log_path "#{var}/log/yabai/yabai.err.log"
    process_type :interactive
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
