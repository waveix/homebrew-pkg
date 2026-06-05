class Ffagent < Formula
    desc "Toolkit for Agents based on LLM"
    version "0.1.1"
    homepage "https://gitlab.com/waveix/pkg-ffagent"
    url "https://gitlab.com/waveix/pkg-ffagent/-/archive/v0.1.1/pkg-ffagent-v0.1.1.tar.gz"
    sha256 "1483d961e3aeeab5a09009c62797aec7568785e587f521b2304ba5cd50a1421c"

    def install
        bin.install "ffagent"
    end

    test do
        assert_match "ffagent 0.1.1", shell_output("#{bin}/ffagent --version")
    end
end
