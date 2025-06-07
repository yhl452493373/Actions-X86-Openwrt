#!/bin/bash
#=================================================
# 文件名: diy-part1.sh
# 描述: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# 作者: P3TERX
# Blog: https://p3terx.com
#=================================================
# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# Xiaorouji Passwall
#sed -i '$a src-git xiaorouji https://github.com/WYC-2020/openwrt-passwall.git' feeds.conf.default

#wsl里面编译前加入下面命令，不包含#
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 删除可能冲突的包
rm -rf feeds/packages/net/nps
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-nps
rm -rf feeds/luci/applications/luci-app-autoreboot
rm -rf feeds/luci/applications/luci-app-poweroff
rm -rf feeds/luci/applications/luci-app-advanced
rm -rf feeds/luci/applications/luci-app-fileassistant
rm -rf feeds/luci/applications/luci-app-poweroffdevice

# argon主题
#git clone https://github.com/jerrykuku/luci-theme-argon.git package/extra-package/luci-theme-argon
git clone https://github.com/yhl452493373/luci-theme-argon.git package/extra-package/luci-theme-argon

# kenzok8的jell库
git clone --depth 1 https://github.com/kenzok8/jell.git ../extra-package/jell
# 定时重启
cp -r ../extra-package/jell/luci-app-autoreboot package/extra-package/luci-app-autoreboot
# 关机
cp -r ../extra-package/jell/luci-app-poweroffdevice package/extra-package/luci-app-poweroffdevice
# 文件管理
cp -r ../extra-package/jell/luci-app-fileassistant package/extra-package/luci-app-fileassistant

# NPS内网穿透的客户端NPC
git clone https://github.com/djylb/nps-openwrt.git package/extra-package/nps-openwrt

# OpenClash，此处使用开发版
git clone -b dev --depth 1 https://github.com/vernesong/OpenClash.git package/extra-package/luci-app-openclash
# idea主题替换为material，否则夜间模式日志是浅色
sed -i 's|theme: "idea",|theme: "material",|g' package/extra-package/luci-app-openclash/luci-app-openclash/luasrc/view/openclash/config_editor.htm

# 自己固件中需要的驱动
git clone https://github.com/yhl452493373/openwrt-driver.git package/extra-package/my-driver
