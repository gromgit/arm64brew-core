class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.6.0",
      :revision => "8ef676f90f9be7c0ba4dceb27a29ec04dee5650d"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "007777ac043b06fc75d74401119316705139eb876048eb914507e216b3c1d893" => :catalina
    sha256 "4811de8b2aa52a8c14c2005bdb39ffb49ef0acad0c8acbeaf6d3685258d72609" => :mojave
    sha256 "57cf9f856d4ae5859586b975a7eea06a807027dafb2852dd5464822a9b64081f" => :high_sierra
    sha256 "a5ae77c98661de2698d4713cbd67ffb4bad71c5533fe1f8e4e4338ea7dcc36a8" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    os = OS.mac? ? "macos" : "linux"
    system "make", "out/#{os}-amd64/crc"
    bin.install "out/#{os}-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    if ENV["USER"] = "root"
      assert_match "crc should be ran as a normal user", status_output
    else
      assert_match "Unable to set ownership", status_output
    end
  end
end
