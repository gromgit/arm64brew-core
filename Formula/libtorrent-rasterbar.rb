class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_2_4/libtorrent-rasterbar-1.2.4.tar.gz"
  sha256 "8759bddb589006ee164438588adaf007325b3bcaf6ae4c64d87a2b914409c680"

  bottle do
    cellar :any
    sha256 "3dbce02b9a73b1e3a412d0cea790fbd79452bdeb00b9938660681a97b9ba3f67" => :catalina
    sha256 "6166da8eb0feccdcde65847dd4dd5fbac0d6f23e2bbf3e106764b97ec9fc36ba" => :mojave
    sha256 "29bfceb8f08c6b9980602e78412254d044b1c0d45adbda6d1ae587976778f771" => :high_sierra
    sha256 "ed57fd6fdfc90c3ce732f142f73f5d9b7e43cfe338073bd0b7844e2e269b7ae5" => :x86_64_linux
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python37-mt
      PYTHON=python3
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    if OS.mac?
      system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                      "-L#{lib}", "-ltorrent-rasterbar",
                      "-L#{Formula["boost"].lib}", "-lboost_system",
                      "-framework", "SystemConfiguration",
                      "-framework", "CoreFoundation",
                      libexec/"examples/make_torrent.cpp", "-o", "test"
    else
      system ENV.cxx, libexec/"examples/make_torrent.cpp",
                      "-std=c++11",
                      "-I#{Formula["boost"].include}/boost", "-L#{Formula["boost"].lib}",
                      "-I#{include}", "-L#{lib}",
                      "-lpthread",
                      "-lboost_system",
                      "-ltorrent-rasterbar",
                      "-o", "test"
    end
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
