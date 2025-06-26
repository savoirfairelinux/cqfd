# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=cqfd
pkgver=5.7.0
pkgrel=1
pkgdesc='Run commands in the current directory within a container defined in a per-project config file.'
arch=('any')
url="https://github.com/savoirfairelinux/$pkgname"
license=('GPL-3.0-only')
depends=('bash' 'docker')
checkdepends=('shellcheck')
source=("https://github.com/savoirfairelinux/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('e692a4acbd9c4003f45a1d78b625e9b841b4a47582b4f458d9062e278fa3661c')
validpgpkeys=('8F3491E60E62695ED780AC672FA122CA0501CA71')

check() {
	cd "$pkgname-$pkgver"
	make -k check
}

package() {
	cd "$pkgname-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
