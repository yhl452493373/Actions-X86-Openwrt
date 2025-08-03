#!/bin/bash
#=================================================
# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# 作者: P3TERX
# Blog: https://p3terx.com
#=================================================

# luci-app-upnp
sed -i 's|msgstr "UPnP"|msgstr "即插即用"|g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's|msgstr "通用即插即用（UPnP）"|msgstr "通用即插即用"|g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's|msgstr "UPnP IGD 和 PCP"|msgstr "即插即用"|g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's|msgstr "UPnP IGD 和 PCP/NAT-PMP 服务"|msgstr "通用即插即用"|g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

# luci-app-nft-qos
sed -i 's|msgstr "QoS Nftables 版"|msgstr "服务质量"|g' feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po

# luci-app-ttyd
sed -i 's|msgstr "终端"|msgstr "网页终端"|g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po
sed -i "s|ssl === '1' ? 'https' : 'http'|ssl === '1' ? 'https' : location.protocol.replace(':','')|g" feeds/luci/applications/luci-app-ttyd/htdocs/luci-static/resources/view/ttyd/term.js

# luci-app-openclash
sed -i 's|msgstr "OpenClash"|msgstr "科学上网"|g' package/extra-package/luci-app-openclash/luci-app-openclash/po/zh-cn/openclash.zh-cn.po

# luci-app-npc
sed -i 's|msgstr "NPS 内网穿透客户端"|msgstr "NPS穿透"|g' package/extra-package/nps-openwrt/luci-app-npc/po/zh-cn/npc.po
sed -i 's|msgstr "NPS 内网穿透客户端"|msgstr "NPS穿透"|g' package/extra-package/nps-openwrt/luci-app-npc/po/zh_Hans/npc.po

# 调整应用在菜单中的位置
# samba4 移动到 服务 中
sed -i 's|admin/nas/samba4|admin/services/samba4|g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
# ttyd 移动到 服务 中
sed -i 's|admin/system/ttyd|admin/services/ttyd|g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

# 如果设置了WAN口设备，则修改为指定设备
if [[ "${WAN_ETH}" != "" && "${WAN_ETH}" != "eth0" ]]; then
  sed -i "s|uci -q set network.wan.device='eth0'|uci -q set network.wan.device='${WAN_ETH}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q set network.wan6.device='eth0'|uci -q set network.wan6.device='${WAN_ETH}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q add_list network.@device\[0\].ports='${WAN_ETH}'|uci -q add_list network.@device\[0\].ports='eth0'|g" files/etc/uci-defaults/1000-default-settings
fi

# 设置WAN口静态IP
if [[ "${WAN_IP}" != "" && "${WAN_NETMASK}" != "" && "${WAN_GATEWAY}" != "" ]]; then
  sed -i "s|#uci -q set network.wan.proto='static'|uci -q set network.wan.proto='static'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|#uci -q set network.wan.ipaddr='192.168.1.2'|uci -q set network.wan.ipaddr='${WAN_IP}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|#uci -q set network.wan.gateway='192.168.1.1'|uci -q set network.wan.gateway='${WAN_GATEWAY}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|#uci -q set network.wan.netmask='255.255.255.0'|uci -q set network.wan.netmask='${WAN_NETMASK}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|#uci -q set network.wan.dns='223.5.5.5 114.114.114.114'|uci -q set network.wan.dns='223.5.5.5 114.114.114.114'|g" files/etc/uci-defaults/1000-default-settings
fi

# 修改LAN口默认IP
if [[ "${LAN_IP}" != "" ]]; then
  sed -i "s|uci -q add_list network.lan.ipaddr='192.168.2.1|uci -q add_list network.lan.ipaddr='${LAN_IP}|g" files/etc/uci-defaults/1000-default-settings
fi

# WAN口是否启用防火墙
if [[ "${ENABLE_FIREWALL}" == "false" ]]; then
  sed -i 's|#uci -q set firewall|uci -q set firewall|g' files/etc/uci-defaults/1000-default-settings
  sed -i 's|#uci commit firewall|uci commit firewall|g' files/etc/uci-defaults/1000-default-settings
  sed -i 's|#uci -q delete ttyd|uci -q delete ttyd|g' files/etc/uci-defaults/1000-default-settings
  sed -i 's|#uci -q set openclash|uci -q set openclash|g' files/etc/uci-defaults/1000-default-settings
  sed -i 's|#uci commit openclash|uci commit openclash|g' files/etc/uci-defaults/1000-default-settings
fi

# 修改ttyd默认端口
if [[ "${TTYD_PORT}" != "" ]]; then
  sed -i "s|uci set ttyd.@ttyd\[0\].port='7681'|uci set ttyd.@ttyd\[0\].port='${TTYD_PORT}'|g" files/etc/uci-defaults/1000-default-settings
fi

# 修改OpenClash默认端口
if [[ "${OPENCLASH_PORT}" != "" ]]; then
  sed -i "s|uci -q set openclash.config.cn_port='9090'|uci -q set openclash.config.cn_port='${OPENCLASH_PORT}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q set openclash.config.dashboard_forward_port='9090'|uci -q set openclash.config.dashboard_forward_port='${OPENCLASH_PORT}'|g" files/etc/uci-defaults/1000-default-settings
fi

# 如果启用npc，进行相应配置
if [[ "${NPC_SERVER}" != "" && "${NPC_PORT}" != "" && "${NPC_VKEY}" != "" ]]; then
  sed -i "s|uci -q set npc.@npc\[0\].enable='0'|uci -q set npc.@npc\[0\].enable='1'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q set npc.@npc\[0\].server_addr=''|uci -q set npc.@npc\[0\].server_addr='${NPC_SERVER}:${NPC_PORT}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q set npc.@npc\[0\].protocol='tcp'|uci -q set npc.@npc\[0\].protocol='${NPC_PROTOCOL}'|g" files/etc/uci-defaults/1000-default-settings
  sed -i "s|uci -q set npc.@npc\[0\].vkey=''|uci -q set npc.@npc\[0\].vkey='${NPC_VKEY}'|g" files/etc/uci-defaults/1000-default-settings
fi

# 输出文件内容
echo "以下为初次启动时执行的脚本"
# 有vkey，则隐藏，没有则原样输出
sed -E "s|(uci -q set npc\.@npc\[0\]\.vkey=')[^']+(')|\1已隐藏\2|g" files/etc/uci-defaults/1000-default-settings

# 修改编译信息
sed -i 's|%D %V, %C|%D %V, %C, Build by YangHuanglin|g' package/base-files/files/etc/banner

# 修复 Rust 编译失败
sed -i 's|--set=llvm\.download-ci-llvm=true|--set=llvm\.download-ci-llvm=false|g' feeds/packages/lang/rust/Makefile

# 创建OpenClash使用的clash二进制文件所在的路径
mkdir -p files/etc/openclash/core
# 设置Clash下载地址变量
# 从github上指定分支的文件中下载
CLASH_SMART_URL=$( curl -sL https://api.github.com/repos/vernesong/OpenClash/contents/dev/smart?ref=core | grep smart/clash-linux-amd64-v2.tar.gz | awk -F '"' '{print $4}' | awk 'NR==4{print}' )
#CLASH_META_URL=$( curl -sL https://api.github.com/repos/vernesong/OpenClash/contents/dev/meta?ref=core | grep meta/clash-linux-amd64.tar.gz | awk -F '"' '{print $4}' | awk 'NR==4{print}' )
# 下载并解压OpenClash的执行文件
wget -qO- $CLASH_SMART_URL | tar xOvz > files/etc/openclash/core/clash_meta
#wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
# 给Clash二进制文件增加执行权限
chmod +x files/etc/openclash/core/clash*
# 下载默认IP相关数据
wget -qO- https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb > files/etc/openclash/Country.mmdb
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat > files/etc/openclash/GeoIP.dat
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat > files/etc/openclash/GeoSite.dat
