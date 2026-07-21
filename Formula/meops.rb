class Meops < Formula
    desc "Toolkit that helps manage Microenterprise repository (MEOps)"
    version "0.1.0"
    homepage "https://gitlab.com/waveix/meops"
    url "https://gitlab.com/waveix/meops/-/archive/v0.1.0/meops-v0.1.0.tar.gz"
    sha256 "REPLACED_BY_CI"

    depends_on "go" => :build

    def install
        system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/meops"
    end

    test do
        system "#{bin}/meops", "--version"
    end
end
