#!/bin/bash
#=================================================
# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# 作者: P3TERX
# Blog: https://p3terx.com
#=================================================

#修复netfilter在linux 6.1.x上无法编译问题
sed -i 's/CONFIG_NF_FLOW_TABLE_IPV4 \\/CONFIG_NF_FLOW_TABLE_IPV4@lt6.1 \\/g' package/kernel/linux/modules/netfilter.mk
sed -i 's/CONFIG_NF_FLOW_TABLE_IPV6 \\/CONFIG_NF_FLOW_TABLE_IPV6@lt6.1 \\/g' package/kernel/linux/modules/netfilter.mk
sed -i 's/$(LINUX_DIR)\/net\/ipv4\/netfilter\/nf_flow_table_ipv4.ko \\/$(LINUX_DIR)\/net\/ipv4\/netfilter\/nf_flow_table_ipv4.ko@lt6.1 \\/g' package/kernel/linux/modules/netfilter.mk
sed -i 's/$(LINUX_DIR)\/net\/ipv6\/netfilter\/nf_flow_table_ipv6.ko \\/$(LINUX_DIR)\/net\/ipv6\/netfilter\/nf_flow_table_ipv6.ko@lt6.1 \\/g' package/kernel/linux/modules/netfilter.mk

#调整软件在菜单中的名称
#luci-app-upnp
sed -i 's/msgstr "UPnP"/msgstr "即插即用"/g' feeds/luci/applications/luci-app-upnp/po/zh-cn/upnp.po
sed -i 's/msgstr "通用即插即用（UPnP）"/msgstr "即插即用（UPnP）"/g' feeds/luci/applications/luci-app-upnp/po/zh-cn/upnp.po
#luci-app-qos
sed -i 's/msgstr "QoS"/msgstr "服务质量"/g' feeds/luci/applications/luci-app-qos/po/zh-cn/qos.po
#luci-app-ttyd
sed -i 's/msgstr "TTYD 终端"/msgstr "网页终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh-cn/terminal.po

#luci-app-openclash
sed -i 's/msgstr "OpenClash"/msgstr "科学上网"/g' package/luci-app-openclash/luci-app-openclash/po/zh-cn/openclash.zh-cn.po
#luci-app-npc
sed -i '/msgid "Nps Client"/i\msgid "Npc"\nmsgstr "内网穿透"\n' package/luci-app-npc/po/zh-cn/npc.po

  
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
  sed -i "s/#uci commit ttyd/uci commit ttyd/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/#uci -q set openclash/uci -q set openclash/g" files/etc/uci-defaults/100-default-settings
  sed -i "s/#uci commit openclash/uci commit openclash/g" files/etc/uci-defaults/100-default-settings
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
wget -qO- https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/lite/Country.mmdb > files/etc/openclash/Country.mmdb
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat > files/etc/openclash/GeoIP.dat
wget -qO- https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat > files/etc/openclash/GeoSite.dat

# 创建npc的二进制文件所在路径
mkdir -p files/usr/bin
# 设置NPC下载地址变量，只取第一条记录，即最新的
# 从github上releases下载
NPC_URL=$( curl -sL https://api.github.com/repos/ehang-io/nps/releases | grep /linux_amd64_client | awk -F '"' '{print $4}' | awk 'NR==1{print}' )
# 下载并解压其中的根目录下名为npc的执行文件
wget -qO- $NPC_URL | tar xOvz npc > files/usr/bin/npc
# 给npc二进制文件增加执行权限
chmod +x files/usr/bin/npc
