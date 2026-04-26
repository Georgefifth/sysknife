# Distribution channels

This directory tracks every channel SysKnife is or could be distributed
through, with current status and next-action notes.

## Live

| Channel | URL | Install command | Notes |
|---|---|---|---|
| **npm** | <https://www.npmjs.com/package/sysknife-setup> | `npx sysknife-setup` | The wizard installs the daemon binary (auto-download + SHA256 verify). |
| **GitHub Releases** | <https://github.com/lacs-foundation/sysknife/releases> | `curl -fsSL <release-url>` | x86_64 + aarch64 prebuilt binaries, signed and SHA256-summed per release. |

## Staged (PRs open, awaiting maintainer account-restoration)

| Channel | PR | What it adds |
|---|---|---|
| GitHub Packages (npm registry mirror) | #225 | `npm install @lacs-foundation/sysknife-setup` from the GitHub registry |
| crates.io | part of #225 | `cargo install sysknife-cli` and `cargo install sysknife-daemon` (token-gated) |

## Drafts ready to ship

Each of these has a complete spec/formula in this directory:

| Channel | Spec | Effort | Reach |
|---|---|---|---|
| Homebrew tap | [`homebrew-tap.md`](homebrew-tap.md) + [`sysknife.rb`](sysknife.rb) | small | macOS + linuxbrew users |
| MCP servers registry | [`mcp-servers-registry.md`](mcp-servers-registry.md) | small | Claude Code / Cursor / Codex users browsing modelcontextprotocol.io |
| Arch User Repository | [`aur-package.md`](aur-package.md) | small | Arch sysadmins (heavy AUR users) |
| Ubuntu PPA | [`ppa-and-copr.md`](ppa-and-copr.md) | medium | Ubuntu sysadmin shops (`apt install sysknife`) |
| Fedora COPR | [`ppa-and-copr.md`](ppa-and-copr.md) | medium | Fedora sysadmins (`dnf install sysknife`) |

## Recommended ordering once the GitHub account is restored

1. **Merge the staged PRs** (#225, #226, #227) — npm + GitHub Packages live with MIT licensing.
2. **Tag v0.2.5** — auto-publishes everything to all the live channels.
3. **Bootstrap Homebrew tap repo** — 30 min one-time + a formula commit. Highest UX leverage per minute spent.
4. **Submit MCP servers registry PR** — 5 min. Visibility multiplier for the entire MCP ecosystem.
5. **AUR submission** — 30 min one-time. Or post in `r/archlinux` and let a community member volunteer.
6. **PPA + COPR** — defer until either (a) you have a sustained release cadence (~weekly), or (b) a community member volunteers to maintain them. Both are higher commitment than the others.

## Future / nice-to-have

- **Snap** — `sudo snap install sysknife` for universal Ubuntu reach. Snapcraft account + snapcraft.yaml. Defer until PPA is stable.
- **Flatpak** — primarily for desktop apps; a sysadmin daemon is an awkward fit. Skip unless a strong demand emerges.
- **Container images on ghcr.io** — `docker pull ghcr.io/lacs-foundation/sysknife`. Useful for testing/CI; the daemon doesn't run in a container in production (it's a host-level daemon), but a CLI-only image is valuable for one-shot dry-runs.

## Per-channel maintainer accounts needed

The bootstrap docs each list the per-channel account creation step. Aggregated:

- **Launchpad** (PPA): personal account, GPG key, `dput` config
- **Fedora Account System** (COPR): FAS account
- **AUR**: separate account at aur.archlinux.org, SSH key
- **Snapcraft**: account at snapcraft.io, snapcraft CLI
- **Homebrew**: nothing — just a public GitHub repo (`lacs-foundation/homebrew-sysknife`)
- **MCP servers registry**: nothing extra — submit a PR from the lacs-foundation account

Maintaining all of these from one person is a lot. Once the project hits a
stable cadence, hand off PPA / COPR / Snap / AUR to community maintainers
who are already in those ecosystems. The Homebrew tap can stay upstream
since it's just `git push` per release.
