class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.11.3.tar.gz"
  sha256 "52ddd26549ae014423d07c5ef8f1f418dc2cdfaa00e093db58392818154ce7f6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :catalina
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :mojave
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :high_sierra
    sha256 "0dc7efb080b0eeabfae12acdea5211d76e6107b4d15bf63f0e795755cb07fa6f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    EOS
    cxx_with_flags = ENV.cxx.split + ["test.cpp",
                                      "-std=c++11",
                                      "-I#{include}",
                                      "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                                      "-o", "test"]
    system *cxx_with_flags
  end
end
