class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v12.1.0",
      :revision => "8afe57913a08deffa247d7b5f837e0b28a54b864"
  revision 1
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "80d5d3074c6d8acd381119d26c84afa286b6930b22eb1646866441f4ce9d5b97" => :catalina
    sha256 "ebdfca363f2e1fa339bed6f5117b944f6b8e1d5f51dc4e0e441837207e212521" => :mojave
    sha256 "266c266b48419e47794760e7825edc7cbbdd8e5f2a6b76179a929076828911b1" => :high_sierra
    sha256 "cbe9f59de32fcadd46ecf3a3cc775310ee4bab68239fc5f3cde79c394fd735dd" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  unless OS.mac?
    # Needs libraries at runtime:
    # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found
    depends_on "gcc@6"
    fails_with :gcc => "5"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test", "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount],[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
