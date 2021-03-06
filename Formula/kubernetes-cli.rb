class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.17.3",
      :revision => "06ad960bfd03b39c8310aaf92d1e7c12ce618213"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e04158043da4f8573ab0a4c51e966291e8e19f710987e41e5e7561fa5c89e364" => :catalina
    sha256 "5a1b0b2ccc3144be4818b09ce659d6a9b1aff349bddf1afdca95a251d24a820c" => :mojave
    sha256 "0d90be2c608189355c8690b77969e22557eea89d33af03bc41f88c3de311c93a" => :high_sierra
    sha256 "3c9f903153d8c770ed6db486b86f2b3d187fe139fff791abf4a20ba9866f2b84" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "rsync" => :build unless OS.mac?

  def install
    ENV["GOPATH"] = buildpath
    os = OS.linux? ? "linux" : "darwin"
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OS X Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/#{os}/amd64/kubectl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/kubectl completion zsh")
      (zsh_completion/"_kubectl").write output

      prefix.install_metafiles

      # Install man pages
      # Leave this step for the end as this dirties the git tree
      system "hack/generate-docs.sh"
      man1.install Dir["docs/man/man1/*.1"]
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
