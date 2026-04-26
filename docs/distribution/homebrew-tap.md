# Homebrew tap — `lacs-foundation/homebrew-sysknife`

Brewing SysKnife from a private tap so macOS users (development) and Linux
users (homebrew-on-Linux) can install via:

```sh
brew tap lacs-foundation/sysknife
brew install sysknife
```

> **Status:** ready to ship — formula draft below. Needs the tap repo
> created (`lacs-foundation/homebrew-sysknife`) and the formula committed.

## Tap repo bootstrap

One-time setup, performed by the maintainer once the GitHub account is
restored:

```sh
gh repo create lacs-foundation/homebrew-sysknife \
    --public \
    --description "Homebrew tap for SysKnife — AI-managed Linux sysadmin"
gh repo clone lacs-foundation/homebrew-sysknife
cd homebrew-sysknife
mkdir Formula
cp /home/user/Desktop/lacs/docs/distribution/sysknife.rb Formula/
git add Formula/sysknife.rb
git commit -m "Initial sysknife formula at v0.2.4"
git push origin main
```

After that, any user — macOS or Linux — can run `brew tap lacs-foundation/sysknife
&& brew install sysknife` and get the prebuilt x86_64 / aarch64 binaries from
the GitHub release matching the formula's `version`.

## Updating on each release

Bump the formula's `version` and `sha256` per architecture, commit, push.
Optional: add a CI job in this repo's release workflow to do this
automatically on each tag.

## Formula

The actual Ruby formula lives at `docs/distribution/sysknife.rb`.

It does not build from source — it downloads the prebuilt binaries from the
sysknife GitHub release for the host arch, verifies the SHA256, and installs
`sysknife` + `sysknife-daemon` to `#{HOMEBREW_PREFIX}/bin/`.

The daemon is intentionally NOT registered as a launchd / systemd service by
the formula — `npx sysknife-setup` handles that, with the user's choice of
user-level vs system-level service install. The formula is purely for the
binaries.
