class Aspm < Formula
    desc "Package manager for distributing API Schemas as OCI artifacts (ASPM)"
    version "0.1.0"
    homepage "https://gitlab.com/waveix/aspm"
    url "https://gitlab.com/waveix/aspm/-/archive/v0.1.0/aspm-v0.1.0.tar.gz"
    sha256 "REPLACED_BY_CI"

    depends_on "rust" => :build

    def install
        ENV["ASPM_VERSION"] = version.to_s
        system "cargo", "install", *std_cargo_args
    end

    test do
        assert_match version.to_s, shell_output("#{bin}/aspm --version")
    end
end
