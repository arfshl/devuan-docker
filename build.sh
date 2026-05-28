# export the env
export RELEASE=$(curl -s http://deb.devuan.org/merged/dists/stable/Release | grep "Codename" | cut -d' ' -f2)
case "$ARCH" in
    armhf) ARCH_DOCKER=armv7 ;;
    ppc64el) ARCH_DOCKER=ppc64le ;;
    arm64) ARCH_DOCKER=arm64 ;;
    amd64) ARCH_DOCKER=amd64 ;;
    armel) ARCH_DOCKER=armv5 ;;
esac
echo "RELEASE=$RELEASE" >> "$GITHUB_OUTPUT"
echo "ARCH=$ARCH" >> "$GITHUB_OUTPUT"

# install depedencies
curl -L -o /tmp/mmdebstrap.deb http://ftp.us.debian.org/debian/pool/main/m/mmdebstrap/mmdebstrap_1.5.7-3_all.deb
sudo apt install -yq /tmp/mmdebstrap.deb
curl -L -o /tmp/keyring.deb http://ftp.us.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2025.1_all.deb
sudo apt install -yq /tmp/keyring.deb
curl -L -o /tmp/devuankey.deb http://deb.devuan.org/merged/pool/DEVUAN/main/d/devuan-keyring/devuan-keyring_2025.08.09_all.deb
sudo apt install -yq /tmp/devuankey.deb

# start build with mmdebstrap and sprays some WD-40 to get rid of rust on coreutils
dist_version="$RELEASE"

sudo mmdebstrap \
    --arch=$ARCH \
    --variant=minbase \
    --components="main,contrib,non-free" \
    --include=locales,passwd,ca-certificates,devuan-keyring \
    --format=tar \
    ${dist_version} \
    devuan-$ARCH_DOCKER.tar.xz \
    "deb http://deb.devuan.org/merged ${dist_version} main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-updates main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-security main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-backports main contrib non-free"
