class CurlOpenssl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  revision 1

  stable do
    url "https://curl.haxx.se/download/curl-7.69.0.tar.bz2"
    sha256 "668d451108a7316cff040b23c79bc766e7ed84122074e44f662b8982f2e76739"

    # The below three patches all fix critical bugs. Remove them with curl 7.69.1.
    patch do
      url "https://github.com/curl/curl/commit/8aa04e9a24932b830bc5eaf6838dea5a3329341e.patch?full_index=1"
      sha256 "77595ec475e692bd24832e0e6e98de5d68a43bf7199c632ae0443fcb932791fb"
    end

    patch do
      url "https://github.com/curl/curl/commit/e040146f22608fd92c44be2447a6505141a8a867.patch?full_index=1"
      sha256 "f4267c146592067e84eacb62cdb22e0a35636699a8237470ccaf27d68cb17a86"
    end

    patch do
      url "https://github.com/curl/curl/commit/64258bd0aa6ad23195f6be32e6febf7439ab7984.patch?full_index=1"
      sha256 "afeb69e09b3402926acd40d76f6b28d9790ac1f1e080f4eb3f2500d5aaf46971"
    end
  end

  bottle do
    sha256 "c0b351723ccb8b144e1eb3aa23d1f73bce6dd1d4e9f3cd0a87dd7ea26bf797a5" => :catalina
    sha256 "02e3c317b5646f97792c8777b3fe669b185552b5c5ddaa1746ea96d53524fd98" => :mojave
    sha256 "1649addf03756d2c541b1b5e054a1a9002dd81628e758d92d5685b8cf981b449" => :high_sierra
    sha256 "ad13f7ffe5fbd573b5c0deef94d9845c40b5b378b18803c5b2f1fa2a4ea690f7" => :x86_64_linux
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if OS.mac?
    keg_only :provided_by_macos
  else
    keg_only "it conflicts with curl"
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "libidn"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-ares=#{Formula["c-ares"].opt_prefix}
      --with-ca-bundle=#{etc}/openssl@1.1/cert.pem
      --with-ca-path=#{etc}/openssl@1.1/certs
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-libpsl
    ]

    system "./configure", *args
    system "make", "install"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
