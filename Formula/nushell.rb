class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.10.0.tar.gz"
  sha256 "8e08dd1a9d25a67ffcfb32a9c6de8bfde5f797b74c44935e553db65fcd848497"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbe8943f8393fcf94cf9db08b886628b1cb59f096141b8f959814d9ed1f36b76" => :catalina
    sha256 "75750391cb2dff2d1d62d2a4c1eed4f43d619365e8768785c79045b2d2bb1dfb" => :mojave
    sha256 "0996afd276eaaba984c77531d29009999c66351f507d7e47e5bf1eea3952f923" => :high_sierra
    sha256 "2faf4a4e2ec25840460f7cc5c2d64fe25a9036f2195b1092fd34c671400d8cbd" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "linuxbrew/xorg/libxcb"
    depends_on "linuxbrew/xorg/libx11"
  end

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    if !OS.mac? && ENV["CI"]
      user = ENV["USER"]
      assert_equal "Welcome to Nushell #{version} (type 'help' for more info)\n#{user} in ~ \n❯ 2\n#{user} in ~ \n❯ ",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
    else
      assert_equal "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2\n~ \n❯ ",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
    end
  end
end
