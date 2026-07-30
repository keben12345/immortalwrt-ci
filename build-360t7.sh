#!/usr/bin/env bash
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses-dev libpython3-dev libreadline-dev libssl-dev libtool libyaml-dev libz-dev lld llvm lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip python3-ply python3-docutils python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev zstd

export OP_BUILD_PATH=$PWD
git clone -b openwrt-25.12 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt

cd "${OP_BUILD_PATH}"/immortalwrt || exit
git checkout v25.12.0
./scripts/feeds update -a && ./scripts/feeds install -a
rm -rf ./tmp && rm -rf .config
mv "${OP_BUILD_PATH}"/360t7.config "${OP_BUILD_PATH}"/immortalwrt/.config
sed -i 's/192.168.1.1/192.168.1.88/g' package/base-files/files/bin/config_generate
make defconfig
make download -j8
make V=s -j$(nproc)
echo "FILE_DATE=$(date +%Y%m%d%H%M)" >>"$GITHUB_ENV"
