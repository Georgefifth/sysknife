# frozen_string_literal: true

# Homebrew formula for SysKnife (https://github.com/lacs-foundation/sysknife).
#
# Installs prebuilt binaries from the GitHub release for the host architecture.
# Verifies SHA256 against the release's published sums. Does NOT register the
# daemon as a service — `npx sysknife-setup` handles that with user-vs-system
# choice.
#
# Update procedure on each release:
#   1. bump `version`
#   2. update each `sha256` from the release's sha256sums-linux-<arch>.txt
#      file (and add darwin sums when macOS builds ship)
#   3. commit + push to lacs-foundation/homebrew-sysknife
#
# Formula language reference:
#   https://docs.brew.sh/Formula-Cookbook
class Sysknife < Formula
  desc "AI-managed Linux sysadmin — typed actions, risk gates, audit chain"
  homepage "https://github.com/lacs-foundation/sysknife"
  license "MIT"
  version "0.2.4"

  # Linux releases (x86_64 + aarch64). macOS support is roadmap — when it
  # ships the maintainer adds `on_macos do … end` blocks below.
  on_linux do
    on_intel do
      url "https://github.com/lacs-foundation/sysknife/releases/download/v#{version}/sysknife-v#{version}-linux-x86_64"
      # Update from sha256sums-linux-x86_64.txt
      sha256 "REPLACE_WITH_SHA256_OF_LINUX_X86_64_BINARY"
    end
    on_arm do
      url "https://github.com/lacs-foundation/sysknife/releases/download/v#{version}/sysknife-v#{version}-linux-aarch64"
      # Update from sha256sums-linux-aarch64.txt
      sha256 "REPLACE_WITH_SHA256_OF_LINUX_AARCH64_BINARY"
    end
  end

  def install
    # The release ships the binary unpacked, named e.g. sysknife-v0.2.4-linux-x86_64.
    # `bin.install` accepts a single argument that is the path of the
    # downloaded asset; rename it to "sysknife" on the way in.
    if Hardware::CPU.intel?
      bin.install "sysknife-v#{version}-linux-x86_64" => "sysknife"
    elsif Hardware::CPU.arm?
      bin.install "sysknife-v#{version}-linux-aarch64" => "sysknife"
    end
  end

  # Sister formula could install sysknife-daemon as a separate binary; for v1
  # we keep them in lockstep on the user's machine via `npx sysknife-setup`.

  test do
    assert_match "sysknife", shell_output("#{bin}/sysknife --help")
  end
end
