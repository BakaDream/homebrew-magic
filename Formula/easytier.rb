class Easytier < Formula
  desc "Simple, decentralized mesh VPN with WireGuard support"
  homepage "https://easytier.cn/"
  version "2.4.5"
  license "LGPL-3.0"
  head "https://github.com/EasyTier/EasyTier", branch: "main"

  url "https://github.com/EasyTier/EasyTier/releases/download/v2.4.5/easytier-macos-aarch64-v2.4.5.zip"
  sha256 "ddf94b070f84d899504ad154666ea3f0369be6cc4da375a2d98143a312daef01"

  def install
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

      Note:
        - Each restart now automatically reads ~/.config/easytier/username.txt.
        - Default username will be 'default' if the file doesn't exist.
        - Logs: #{var}/log/easytier.log
    EOS
  end

  service do
    # 使用 bash 动态读取 username.txt（每次启动都会重新加载）
    run [
      "/bin/bash", "-c",
      "#{opt_bin}/easytier-core -w $(cat ~/.config/easytier/username.txt 2>/dev/null || echo default)"
    ]

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
