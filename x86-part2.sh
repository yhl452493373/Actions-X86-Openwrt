#!/bin/bash
#=================================================
# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# 作者: P3TERX
# Blog: https://p3terx.com
#=================================================

#删除自带的更新
sed -i '/luci-app-attendedsysupgrade/d' feeds/luci/collections/luci/Makefile

# 删除可能冲突的包
rm -rf package/feeds/luci/luci-theme-argon
rm -rf package/feeds/luci/luci-app-openclash

#调整软件在菜单中的名称
#luci-app-homeproxy
#sed -i 's/msgstr "HomeProxy"/msgstr "家庭代理"/g' package/homeproxy/po/zh_Hans/homeproxy.po
#sed -i 's/msgstr "为 ARM64\/AMD64 设计的现代 ImmortalWrt 代理平台。"/msgstr "为 ARM64\/AMD64 设计的现代 OpenWrt 代理平台。"/g' package/homeproxy/po/zh_Hans/homeproxy.po

#luci-app-mihomo
#删除 msgid "MihomoTProxy" 下的一行
#sed -i '/msgid "MihomoTProxy"/{n;d}' package/OpenWrt-mihomo/luci-app-mihomo/po/zh_Hans/mihomo.po
#在 msgid "MihomoTProxy" 下添加一行
#sed -i '/msgid "MihomoTProxy"/a\msgstr "出国加速"' package/OpenWrt-mihomo/luci-app-mihomo/po/zh_Hans/mihomo.po

#luci-app-upnp
sed -i 's/msgstr "UPnP IGD 和 PCP"/msgstr "即插即用"/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's/msgstr "UPnP IGD 和 PCP\/NAT-PMP 服务"/msgstr "即插即用服务"/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

#luci-app-nft-qos
sed -i 's/msgstr "QoS Nftables 版"/msgstr "服务质量"/g' feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po

#luci-app-ttyd
sed -i 's/msgstr "终端"/msgstr "网页终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po
sed -i "s/ssl === '1' ? 'https' : 'http'/ssl === '1' ? 'https' : location.protocol.replace(':','')/g" feeds/luci/applications/luci-app-ttyd/htdocs/luci-static/resources/view/ttyd/term.js

#luci-app-openclash
sed -i 's/msgstr "OpenClash"/msgstr "科学上网"/g' package/luci-app-openclash/luci-app-openclash/po/zh-cn/openclash.zh-cn.po

#luci-app-npc
sed -i '/msgid "Nps Client"/i\msgid "Npc"\nmsgstr "NPS穿透"\n' package/luci-app-npc/po/zh_Hans/npc.po

#luci-app-frpc
#sed -i 's/msgstr "frp 客户端"/msgstr "FRP穿透"/g' feeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po
  
# 修改LAN口默认IP
if [[ "${LAN_IP}" != "" ]]; then
  sed -i 's/192.168.2.1/'"${LAN_IP}"'/g' files/etc/config/network
  sed -i 's/192.168.1.1/'"${LAN_IP}"'/g' package/base-files/files/bin/config_generate
fi

# 设置WAN口静态IP
if [[ "${WAN_IP}" != "" && "${WAN_NETMASK}" != "" && "${WAN_GATEWAY}" != "" ]]; then
  sed -i "/        option proto 'dhcp'/a\        option gateway '"${WAN_GATEWAY}"'" files/etc/config/network
  sed -i "/        option proto 'dhcp'/a\        option netmask '"${WAN_NETMASK}"'" files/etc/config/network
  sed -i "/        option proto 'dhcp'/a\        option ipaddr '"${WAN_IP}"'" files/etc/config/network
  sed -i "s/        option proto 'dhcp'/        option proto 'static'/g" files/etc/config/network
fi

# wan口是否启用防火墙
if [[ "${ENABLE_FIREWALL}" == "false" ]]; then
  sed -i 's/#uci -q set firewall/uci -q set firewall/g' files/etc/uci-defaults/100-default-settings
  sed -i 's/#uci commit firewall/uci commit firewall/g' files/etc/uci-defaults/100-default-settings
  sed -i "s/#uci -q delete ttyd/uci -q delete ttyd/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/#uci -q set openclash/uci -q set openclash/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/#uci commit openclash/uci commit openclash/g" files/etc/uci-defaults/100-default-settings
fi

# 如果设置了wan口，进行相应配置
if [[ "${WAN_ETH}" != "" && "${WAN_ETH}" != "eth0" ]]; then
  sed -i "s/option device 'eth0'/option device '""${WAN_ETH}""'/g" files/etc/config/network
  sed -i "s/list ports '""${WAN_ETH}""'/list ports 'eth0'/g" files/etc/config/network
fi

# 修改ttyd默认端口
if [[ "${TTYD_PORT}" != "" ]]; then
  sed -i "s/uci set ttyd.@ttyd\[0\].port='7681'/uci set ttyd.@ttyd\[0\].port='"${TTYD_PORT}"'/g" files/etc/uci-defaults/100-default-settings
fi

# 修改OpenClash默认端口
if [[ "${OPENCLASH_PORT}" != "" ]]; then
  sed -i "s/uci -q set openclash.config.cn_port='9090'/uci -q set openclash.config.cn_port='"${OPENCLASH_PORT}"'/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/uci -q set openclash.config.dashboard_forward_port='9090'/uci -q set openclash.config.dashboard_forward_port='"${OPENCLASH_PORT}"'/g" files/etc/uci-defaults/100-default-settings
fi

# 如果启用npc，进行相应配置
if [[ "${NPC_SERVER}" != "" && "${NPC_PORT}" != "" && "${NPC_VKEY}" != "" ]]; then
  sed -i "s/uci -q set npc.config.protocol='tcp'/uci -q set npc.config.protocol='"${NPC_PROTOCOL}"'/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/uci -q set npc.config.enabled='0'/uci -q set npc.config.enabled='1'/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/uci -q set npc.config.server_addr=''/uci -q set npc.config.server_addr='"${NPC_SERVER}"'/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/uci -q set npc.config.server_port=''/uci -q set npc.config.server_port='"${NPC_PORT}"'/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/uci -q set npc.config.vkey=''/uci -q set npc.config.vkey='"${NPC_VKEY}"'/g" files/etc/uci-defaults/100-default-settings
fi

# 修改编译信息
sed -i 's/%D %V, %C/%D %V, %C, Build by YangHuanglin/g' package/base-files/files/etc/banner

# 创建OpenClash使用的clash二进制文件所在的路径
mkdir -p files/etc/openclash/core
# 设置Clash下载地址变量
# 从github上指定分支的文件中下载
OPENCLASH_MAIN_URL=$( curl -sL https://api.github.com/repos/vernesong/OpenClash/contents/dev/dev?ref=core | grep dev/clash-linux-amd64.tar.gz | awk -F '"' '{print $4}' | awk 'NR==4{print}' )
CLASH_TUN_URL=$( curl -sL https://api.github.com/repos/vernesong/OpenClash/contents/dev/premium?ref=core | grep premium/clash-linux-amd64-20 | awk -F '"' '{print $4}' | awk 'NR==4{print}' )
CLASH_META_URL=$( curl -sL https://api.github.com/repos/vernesong/OpenClash/contents/dev/meta?ref=core | grep meta/clash-linux-amd64.tar.gz | awk -F '"' '{print $4}' | awk 'NR==4{print}' )
# 下载并解压OpenClash的执行文件
wget -qO- $OPENCLASH_MAIN_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
# 给Clash二进制文件增加执行权限
chmod +x files/etc/openclash/core/clash*
# 下载默认IP相关数据
wget -qO- https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb > files/etc/openclash/Country.mmdb
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat > files/etc/openclash/GeoIP.dat
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat > files/etc/openclash/GeoSite.dat

