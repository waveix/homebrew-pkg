class Meops < Formula
    desc "Toolkit that helps manage Microenterprise repository (MEOps)"
    version "0.1.0"
    homepage "https://gitlab.com/waveix/meops"
    url "https://gitlab.com/waveix/meops/-/archive/v0.1.0/meops-v0.1.0.tar.gz"
    sha256 "REPLACED_BY_CI"

    depends_on "rust" => :build

    def install
        ENV["MET_VERSION"] = version.to_s
        system "cargo", "install", *std_cargo_args
    end

    test do
        # The binary is `met` (crate `meops`), see the meops README.
        assert_match version.to_s, shell_output("#{bin}/met --version")
    end
end
