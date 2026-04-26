# Ubuntu PPA and Fedora COPR

Native package channels for the two LTS targets — closest to "the right way"
for Ubuntu/Fedora sysadmins. Higher effort than the AUR/Homebrew paths,
but enormously higher reach for production sysadmin shops.

> **Status:** maintainer-wanted; bootstrap notes below for whoever picks it up.

## Why this matters

Ubuntu / Fedora sysadmins reach for `apt install sysknife` and `dnf install
sysknife` first. If those commands don't work, they often skip the tool
entirely. The PPA and COPR are the channels that close that gap.

Both are FREE for OSS, both auto-build from a source tarball, both signed.

## Ubuntu PPA — `ppa:lacs-foundation/sysknife`

### Bootstrap (one-time)

1. Maintainer creates a Launchpad account at <https://launchpad.net/+login>.
   This is separate from GitHub. Standard OSS PPA workflow.
2. Set up a PPA: `https://launchpad.net/~lacs-foundation/+activate-ppa`
3. Generate a GPG key for package signing (RSA-4096 or ED25519):
   ```sh
   gpg --full-generate-key
   gpg --send-keys --keyserver keyserver.ubuntu.com <KEYID>
   ```
   Upload public key to Launchpad: profile → "OpenPGP keys" → import.
4. Set up `dput` config:
   ```ini
   # ~/.dput.cf
   [sysknife-ppa]
   fqdn = ppa.launchpad.net
   method = ftp
   incoming = ~lacs-foundation/ubuntu/sysknife/
   login = anonymous
   allow_unsigned_uploads = 0
   ```

### Per-release upload

Each git tag triggers (manually for now) an upload:

```sh
# In a fresh checkout of the tag:
debuild -S -sa            # build source package + sign
dput sysknife-ppa ../sysknife_<version>_source.changes
```

Launchpad builds binary `.deb` for every supported Ubuntu series (jammy,
noble, oracular at time of writing) and publishes them within ~30 min.

### `debian/` directory needed in the source tree

A minimal Debian packaging layout under `packaging/debian/`:

- `changelog` (auto-bump per release)
- `control` (Source/Package/Depends)
- `rules` (debhelper-style)
- `compat` (debhelper compat level)
- `install` (file mappings: `target/release/sysknife → usr/bin/`, …)
- `postinst` (creates sysknife user, installs sudoers fragment)

Reference: any well-maintained PPA project — e.g. `nodejs`, `mosh`,
`ripgrep`. The packaging is standard.

## Fedora COPR — `lacs-foundation/sysknife`

### COPR bootstrap (one-time)

1. Maintainer creates Fedora Account System (FAS) account at
   <https://accounts.fedoraproject.org/register/>
2. Sign in to <https://copr.fedorainfracloud.org/> with FAS
3. New project: name `sysknife`, chroots `fedora-rawhide-x86_64`,
   `fedora-41-x86_64`, `fedora-41-aarch64` (extend per release)
4. Add a `dist-git`-style spec file under `packaging/sysknife.spec`
5. Trigger build: `copr-cli build sysknife <srpm-url>`

### Spec file outline (`packaging/sysknife.spec`)

```spec
Name:           sysknife
Version:        0.2.4
Release:        1%{?dist}
Summary:        AI-managed Linux sysadmin — typed actions, risk gates, audit chain

License:        MIT
URL:            https://github.com/lacs-foundation/sysknife
Source0:        %{url}/archive/v%{version}/sysknife-%{version}.tar.gz

BuildRequires:  rust, cargo, openssl-devel, sqlite-devel
Requires:       systemd

%description
SysKnife is an open-source Linux system management agent that interprets
plain-language intents into typed, risk-classified actions. Every action
ships with a formal risk level, an explicit approval gate, and an
HMAC-SHA256 tamper-evident audit chain.

%prep
%autosetup -n sysknife-%{version}

%build
cargo build --release --locked -p sysknife-cli -p sysknife-daemon

%install
install -Dm0755 target/release/sysknife        %{buildroot}%{_bindir}/sysknife
install -Dm0755 target/release/sysknife-daemon %{buildroot}%{_bindir}/sysknife-daemon
install -Dm0644 packaging/sysknife-daemon.service %{buildroot}%{_unitdir}/sysknife-daemon.service
install -Dm0644 packaging/sysknife-sudoers     %{buildroot}%{_sysconfdir}/sudoers.d/sysknife
install -Dm0644 packaging/sysknife-sysusers.conf %{buildroot}%{_sysusersdir}/sysknife.conf
install -Dm0644 packaging/sysknife-tmpfiles.conf %{buildroot}%{_tmpfilesdir}/sysknife.conf
install -Dm0644 packaging/50-sysknife.rules    %{buildroot}%{_datadir}/polkit-1/rules.d/50-sysknife.rules
install -Dm0755 packaging/sysknife-grub-kargs-edit %{buildroot}%{_libexecdir}/sysknife/grub-kargs-edit

%files
%license LICENSE
%doc README.md
%{_bindir}/sysknife
%{_bindir}/sysknife-daemon
%{_unitdir}/sysknife-daemon.service
%config(noreplace) %{_sysconfdir}/sudoers.d/sysknife
%{_sysusersdir}/sysknife.conf
%{_tmpfilesdir}/sysknife.conf
%{_datadir}/polkit-1/rules.d/50-sysknife.rules
%{_libexecdir}/sysknife/grub-kargs-edit

%post
%systemd_post sysknife-daemon.service

%preun
%systemd_preun sysknife-daemon.service

%postun
%systemd_postun_with_restart sysknife-daemon.service

%changelog
* Sat Apr 26 2026 Vladimir Rotariu <sysknife-development@protonmail.com> - 0.2.4-1
- Initial COPR build at v0.2.4 — MIT relicense, multi-LTS Ubuntu support
```

### Per-release rebuild

```sh
copr-cli build sysknife https://github.com/lacs-foundation/sysknife/releases/download/v0.2.4/sysknife-0.2.4.src.rpm
```

(or set up GitHub Actions with the COPR API token to rebuild on each tag)

## Recommended order of work

1. **Homebrew tap first** — fastest to reach, lowest maintenance cost
2. **MCP servers registry submission** — high visibility for free
3. **AUR** — easy, community usually picks up the maintenance
4. **PPA** — biggest reach but highest effort; defer until 1-3 ship
5. **COPR** — symmetrically biggest Fedora reach; do alongside the PPA

The maintainer might want to leave PPA + COPR maintenance to community
volunteers once the project hits ~1k stars, since they're the most
commitment-heavy of the channels.
