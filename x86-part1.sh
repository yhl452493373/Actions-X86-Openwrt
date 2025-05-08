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
#git clone https://github.com/yhl452493373/luci-theme-argon.git package/luci-theme-argon

# 高级设置
git clone https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced

# NPS内网穿透的客户端NPC
git clone https://github.com/yhl452493373/npc.git package/npc
git clone https://github.com/yhl452493373/luci-app-npc.git package/luci-app-npc

# OpenClash，此处使用开发版
git clone -b dev --depth 1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash
# idea主题替换为material，否则夜间模式日志是浅色
sed -i 's/theme: "idea",/theme: "material",/g' package/luci-app-openclash/luci-app-openclash/luasrc/view/openclash/config_editor.htm

# 关机
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
# 修正关机中文语言问题
mv package/luci-app-poweroff/po/zh-cn package/luci-app-poweroff/po/zh_Hans

# 自己固件中需要的包
git clone https://github.com/yhl452493373/openwrt-packages.git package/my-packages
# 修正定时重启中文语言问题
mv package/my-packages/luci-app-autoreboot/po/zh-cn package/my-packages/luci-app-autoreboot/po/zh_Hans

# 自己固件中需要的驱动
git clone https://github.com/yhl452493373/openwrt-driver.git package/my-driver
