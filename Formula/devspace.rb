class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.6.1",
    :revision => "79c0e28f426fdfa0f2f486dd69ba5e9ad53f7caa"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaa7b21d1fb78ffa242934d6259f269df70cef8e6e79996ce323e513f6a509c7" => :catalina
    sha256 "566f68ff9c2555e2ba6981b4908d38dfdf84590db1a2a8b58ef714f4ef624a08" => :mojave
    sha256 "cea510381024d690428c9dcb584ddc57ba471d13c99b7c5e3bd154b4941e7fdb" => :high_sierra
    sha256 "430b85239d6139230b997c568d8315bfae8c6a531549f230c0799dfc3a45fe53" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
