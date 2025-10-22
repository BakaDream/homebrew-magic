class Easytier < Formula
  desc "Simple, decentralized mesh VPN with WireGuard support"
  homepage "https://easytier.cn/"
  version "2.4.5"
  license "LGPL-3.0"
  head "https://github.com/EasyTier/EasyTier", branch: "main"

  # ✅ macOS ARM64 (Apple Silicon) 二进制包
  url "https://github.com/EasyTier/EasyTier/releases/download/v2.4.5/easytier-macos-aarch64-v2.4.5.zip"
  sha256 "ddf94b070f84d899504ad154666ea3f0369be6cc4da375a2d98143a312daef01"

  livecheck do
    url :url
    strategy :github_latest
  end

  def install
    # 解压出的可执行文件放入 bin 目录
    bin.install "easytier-core"
    bin.install "easytier-cli"
    bin.install "easytier-web"
  end

  def caveats
    <<~EOS
      ⚠️ EasyTier requires root privileges to create TUN/utun devices.

      If your configuration uses TUN or WireGuard (e.g. includes wg:// listeners),
      you must start the service with root privileges:

          sudo brew services start easytier

      Note: This will change ownership of some EasyTier-related paths to root,
      which may require manual removal using `sudo rm` during future upgrades,
      reinstalls, or uninstalls.
    EOS
  end

  service do
    run [opt_bin/"easytier-core", "-c", "~/.config/easytier/config.toml"]
    keep_alive true
    require_root true
    working_dir var
    log_path var/"log/easytier.log"
    error_log_path var/"log/easytier.log"
  end

  test do
    system bin/"easytier-core", "-h"
    system bin/"easytier-cli", "-h"
    system bin/"easytier-web", "-h"
  end
end
