class Met < Formula
    desc "Tool that helps manage Microenterprise repository"
    version "0.1.0"
    homepage "https://gitlab.com/waveix/pkg-met"
    url "https://gitlab.com/waveix/pkg-met/-/archive/v0.1.0/pkg-met-v0.1.0.tar.gz"
    sha256 "REPLACED_BY_CI"

    depends_on "go" => :build

    def install
        system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/met"
    end

    test do
        system "#{bin}/met", "--version"
    end
end
