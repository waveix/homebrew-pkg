# Bootstrap

## Adding a formula

1. Tag a release in the tool's source repo and grab the tarball sha256.
2. Add `Formula/<name>.rb` here pointing at that tarball (`url` + `sha256`).
3. Push. Users get it via `brew install waveix/pkg/<name>`.
