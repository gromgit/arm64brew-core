class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://github.com/espressif/esptool"
  url "https://github.com/espressif/esptool/archive/v2.8.tar.gz"
  sha256 "f6187ab0467e05bff6ef4e777bde5ee8eb57a74154865d30491ebb42b228c617"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0957ff12323413dfd8d106c492c2eae375b4d77d73f085ff36f11404bb9d490e" => :catalina
    sha256 "408cf90221d809ffe687c897ae5ecd510b4cc894348f03a38c4da682f0497cfb" => :mojave
    sha256 "c11b3731a7895ecea413fffb4de8455493f7f9db15066d42f2fcc79971ff4f30" => :high_sierra
    sha256 "86157f02389c0dc1a12c6830e9f0649613275b2662b160640c7b64cf09a2853a" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match(/#{version}/, shell_output("#{bin}/esptool.py version"))
    assert_match(/#{version}/, shell_output("#{bin}/espefuse.py --help"))
    assert_match(/#{version}/, shell_output("#{bin}/espsecure.py --help"))

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
