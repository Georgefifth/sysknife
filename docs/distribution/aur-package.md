# AUR package — `sysknife-bin`

Arch User Repository submission. Arch sysadmins are heavy AUR users; the
package gets SysKnife into `paru -S sysknife-bin` / `yay -S sysknife-bin`
reach.

> **Status:** PKGBUILD draft below. Needs an AUR account + initial submission.

## AUR account setup

One-time, performed by the maintainer:

1. Create account at <https://aur.archlinux.org/register> (free, separate
   from the GitHub account)
2. Add SSH key to AUR profile
3. Clone the empty AUR git repo:
   ```sh
   git clone ssh://aur@aur.archlinux.org/sysknife-bin.git
   ```
4. Add the PKGBUILD + .SRCINFO files (template below)
5. Push

## PKGBUILD (`sysknife-bin`)

Save as `PKGBUILD` in the AUR repo:

```bash
# Maintainer: Vladimir Rotariu <sysknife-development@protonmail.com>
pkgname=sysknife-bin
pkgver=0.2.4
pkgrel=1
pkgdesc="AI-managed Linux sysadmin — typed actions, risk gates, audit chain"
arch=('x86_64' 'aarch64')
url="https://github.com/lacs-foundation/sysknife"
license=('MIT')
depends=('systemd')
optdepends=(
    'ufw: firewall actions on Ubuntu-style hosts'
    'snapd: snap action support'
    'apparmor: AppArmor profile management'
    'distrobox: rootless container actions'
)
provides=('sysknife')
conflicts=('sysknife')

source_x86_64=("$pkgname-$pkgver-x86_64::https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sysknife-v$pkgver-linux-x86_64"
               "$pkgname-daemon-$pkgver-x86_64::https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sysknife-daemon-v$pkgver-linux-x86_64"
               "https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sha256sums-linux-x86_64.txt")
source_aarch64=("$pkgname-$pkgver-aarch64::https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sysknife-v$pkgver-linux-aarch64"
                "$pkgname-daemon-$pkgver-aarch64::https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sysknife-daemon-v$pkgver-linux-aarch64"
                "https://github.com/lacs-foundation/sysknife/releases/download/v$pkgver/sha256sums-linux-aarch64.txt")

# These are placeholders — update on each release from sha256sums-linux-<arch>.txt.
sha256sums_x86_64=('SKIP' 'SKIP' 'SKIP')
sha256sums_aarch64=('SKIP' 'SKIP' 'SKIP')

package() {
    install -Dm755 "$srcdir/$pkgname-$pkgver-$CARCH" "$pkgdir/usr/bin/sysknife"
    install -Dm755 "$srcdir/$pkgname-daemon-$pkgver-$CARCH" "$pkgdir/usr/bin/sysknife-daemon"
}
```

## .SRCINFO

Generate from the PKGBUILD with `makepkg --printsrcinfo > .SRCINFO`. Commit
both files together.

## Updating on each release

```sh
cd ~/aur/sysknife-bin
sed -i "s/^pkgver=.*/pkgver=$NEW_VERSION/" PKGBUILD
# Update sha256sums_x86_64 and sha256sums_aarch64 from the GitHub release.
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Update to $NEW_VERSION"
git push
```

The AUR helper bots (`aurutils`, `paru`, `yay`) pick up the new version within
minutes.

## Maintainer-wanted

If the lacs-foundation prefers an Arch community member to maintain the AUR
package rather than the upstream maintainer, link to this doc from the
"Distribution" section of the README and someone will likely take it on. AUR
volunteers are common for OSS sysadmin tools.
