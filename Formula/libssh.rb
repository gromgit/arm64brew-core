class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.3.tar.xz"
  sha256 "2c8b5f894dced58b3d629f16f3afa6562c20b4bdc894639163cf657833688f0c"
  revision 1 unless OS.mac?
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "b4cff56528c3a0a8c960f57539b402173c360451d9786aee5dfb42880dfea721" => :catalina
    sha256 "09b06812c37f7e2213224e92a0d579e0e9bf56bc4d1cd3f017f1877b22eb757f" => :mojave
    sha256 "db8b47069aadc848fec558351e684464d1d9f3ddc1b6105e6720dddffde30823" => :high_sierra
    sha256 "067fc2ef4244c360de4c691575d128a1aaa22e9045256f6108a807e0b81ee90d" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", *("-L#{lib}" if OS.mac?), *("-lssh" if OS.mac?),
           testpath/"test.c", *("-L#{lib}" unless OS.mac?), *("-lssh" unless OS.mac?), "-o", testpath/"test"
    system "./test"
  end
end
