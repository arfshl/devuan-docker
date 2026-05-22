# export the env
export RELEASE=daedalus
export ARCH_DOCKER=$ARCH
case "$ARCH" in
    x86_64) ARCH=amd64 ;;
    arm) ARCH=armhf ;;
    arm64) ARCH=arm64 ;;
esac
case "$ARCH_DOCKER" in
    x86_64) ARCH_DOCKER=amd64 ;;
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
    --include=locales,passwd,ca-certificates,sudo,dbus,mesa-utils \
    --format=tar \
    ${dist_version} \
    devuan-$ARCH_DOCKER.tar.xz \
    "deb http://deb.devuan.org/merged ${dist_version} main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-updates main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-security main contrib non-free" \
    "deb http://deb.devuan.org/merged ${dist_version}-backports main contrib non-free"