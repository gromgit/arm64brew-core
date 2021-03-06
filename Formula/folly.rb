class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2020.03.09.00.tar.gz"
  sha256 "8b6c70e296a98bc441d380e51bf5dd5264820e494ac7f89ebfec952a3f55d928"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "efea341ee385dae18cd75ae1a7317c5546119982399d012b34b4580bf287f691" => :catalina
    sha256 "4dd44e057af7a99b79c0828f60c9ac1a11f39e048ef2af8a59ecee10fa297620" => :mojave
    sha256 "ebd03869fe4a25a664b04f9f267813f03a733ae417762ae25f99fc3b76c5305d" => :high_sierra
    sha256 "dd6ff37e1c343d90b5c0fd0f9f27ea044d98be6a53667112586d5ac5af611249" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  # https://github.com/facebook/folly/issues/966
  depends_on :macos => :high_sierra if OS.mac?

  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"
  depends_on "jemalloc" unless OS.mac?

  uses_from_macos "python"

  def install
    mkdir "_build" do
      args = std_cmake_args
      args << "-DFOLLY_USE_JEMALLOC=#{OS.mac? ? "OFF" : "ON"}"

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON", ("-DCMAKE_POSITION_INDEPENDENT_CODE=ON" unless OS.mac?)
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
