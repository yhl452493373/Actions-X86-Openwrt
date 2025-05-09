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

# argon主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# sirpdboy的sirpdboy-package库
git clone --depth 1 https://github.com/sirpdboy/sirpdboy-package.git ../extra-package/sirpdboy-package
# 高级设置
cp -r ../extra-package/sirpdboy-package/luci-app-advanced package/luci-app-advanced
# 关机
cp -r ../extra-package/sirpdboy-package/luci-app-poweroffdevice package/luci-app-poweroffdevice

# kenzok8的jell库
git clone --depth 1 https://github.com/kenzok8/jell.git ../extra-package/jell
# 定时重启
cp -r ../extra-package/jell/luci-app-autoreboot package/luci-app-autoreboot

# NPS内网穿透的客户端NPC
git clone https://github.com/yhl452493373/npc.git package/npc
git clone https://github.com/yhl452493373/luci-app-npc.git package/luci-app-npc

# OpenClash，此处使用开发版
git clone -b dev --depth 1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash
# idea主题替换为material，否则夜间模式日志是浅色
sed -i 's|theme: "idea",|theme: "material",|g' package/luci-app-openclash/luci-app-openclash/luasrc/view/openclash/config_editor.htm

# 自己固件中需要的驱动
git clone https://github.com/yhl452493373/openwrt-driver.git package/my-driver
