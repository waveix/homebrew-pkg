class Aspm < Formula
    desc "Package manager for distributing API Schemas as OCI artifacts (ASPM)"
    version "0.1.0"
    homepage "https://gitlab.com/waveix/aspm"
    url "https://gitlab.com/waveix/aspm/-/archive/v0.1.0/aspm-v0.1.0.tar.gz"
    sha256 "REPLACED_BY_CI"

    depends_on "go" => :build

    def install
        system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/aspm"
    end

    test do
        system "#{bin}/aspm", "--version"
    end
end
