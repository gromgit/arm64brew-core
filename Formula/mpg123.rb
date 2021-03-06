class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.13/mpg123-1.25.13.tar.bz2"
  sha256 "90306848359c793fd43b9906e52201df18775742dc3c81c06ab67a806509890a"

  bottle do
    sha256 "231bff62192a6c109c7eeafd4deb90b967197f0656a5aa6ff23360540b2ea3e2" => :catalina
    sha256 "853131e5b67225d5018b5574c9073dafee53d7fd8b326f164bad02b835ceee92" => :mojave
    sha256 "fc7974c5e52d1c85e0345e359371fc7b1b2b102e2b2b4b4107a5a761ce06c5f4" => :high_sierra
    sha256 "631b0f6dee88808099b49294cd1974d6f4e82c6cf8187c51012523f9613365aa" => :x86_64_linux
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
