#!/bin/bash
#run this in openwrt workdir

#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

echo Clone lede source code
git clone --depth 1 https://github.com/coolsnowwolf/lede.git lede

cd openwrt

echo Replace target/linux/generic/backport-6.1
rm -rf target/linux/generic/backport-6.1
cp -r ../lede/target/linux/generic/backport-6.1 target/linux/generic/backport-6.1

echo Replace target/linux/generic/hack-6.1
rm -rf target/linux/generic/hack-6.1
cp -r ../lede/target/linux/generic/hack-6.1 target/linux/generic/hack-6.1

echo Replace target/linux/generic/pending-6.1
rm -rf target/linux/generic/pending-6.1
cp -r ../lede/target/linux/generic/pending-6.1 target/linux/generic/pending-6.1

echo Replace include/kernel-6.1
cp ../lede/include/kernel-6.1 include/kernel-6.1

echo Restore target/linux/x86/patches-6.1
mkdir -p target/linux/x86/patches-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/patches-6.1/100-fix_cs5535_clockevt.patch -o target/linux/x86/patches-6.1/100-fix_cs5535_clockevt.patch
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/patches-6.1/103-pcengines_apu6_platform.patch -o target/linux/x86/patches-6.1/103-pcengines_apu6_platform.patch

echo Restore target/linux/generic/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/generic/config-6.1 -o target/linux/generic/config-6.1

echo Restore target/linux/x86/64/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/64/config-6.1 -o target/linux/x86/64/config-6.1

echo Restore and update target/linux/x86/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/config-6.1 -o target/linux/x86/config-6.1
sed -i '/^CONFIG_MITIGATION_SPECTRE_BHI=y/a CONFIG_CPU_MITIGATIONS=y' target/linux/x86/config-6.1
sed -i '/^CONFIG_CPU_MITIGATIONS=y/a CONFIG_FIT_PARTITION=n' target/linux/x86/config-6.1
sed -i '/^CONFIG_FIT_PARTITION=n/a CONFIG_SHORTCUT_FE=y' target/linux/x86/config-6.1

echo Restore target/linux/x86/generic/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/generic/config-6.1 -o target/linux/x86/generic/config-6.1

echo Restore target/linux/x86/geode/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/geode/config-6.1 -o target/linux/x86/geode/config-6.1

echo Restore target/linux/x86/legacy/config-6.1
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/legacy/config-6.1 -o target/linux/x86/legacy/config-6.1

echo Restore target/linux/x86/Makefile
curl -sfL https://raw.githubusercontent.com/openwrt/openwrt/485afd4b1107d38dff94bca106ecf260982dee35/target/linux/x86/Makefile -o target/linux/x86/Makefile
