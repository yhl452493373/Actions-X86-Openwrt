# Actions-X86-Openwrt

Build openwrt using GitHub Actions | 使用 GitHub Actions 云编译 openwrt

### `6.6内核`每周六早上自动编译Openwrt最新代码。编译后系统主题为argon，去除了openwrt部分默认选中的软件，同时nginx去除http自动转https，编译分支为`master` ，即最新代码

### 6.1内核脚本文件说明

**由于6.6内核在部分设备上无法启动，因此才有了6.1内核脚本，从openwrt官方获取openwrt源码，配合lede的6.1内核来编译。如果你的设备用openwrt最新代码无法启动，可以试试回到6.1内核**

我自己的设备：

+ 康耐信J4125 4口2.5G的软路由可以6.6内核
+ 京云JC500X J3355 小主机，不能用6.6内核，只能6.1内核
+ 之前咸鱼买的 J4205 4口 i211 千兆软路由，不能用6.6内核，只能6.1内核

说明：

+ `kernel_lede_6.1.sh`为Lede目前在维护的6.1内核脚本，`target/linux/generic/`下6.1内核相关补丁采用Lede的补丁，`include/kernel-6.1`也采用Lede的，`target/linux/x86/`下面的6.1配置采用Openwrt最后一次删除时的配置，同时改6.1为默认内核。
+ `x86-Openwrt-6.1-lede.yml`使用该脚本
+ 根据仓库代码，lede应当会保留6.1内核
+ 由于这个是用的非openwrt维护的内核，时间长了之后可能与最新的openwrt源码不兼容

### 额外包含以下软件

+ luci-app-openclash(科学上网)
+ luci-app-npc(内网穿透)
+ luci-app-upnp(即插即用)
+ luci-app-samba4(网络共享)
+ luci-app-autoreboot(定时重启)
+ luci-app-poweroff(关机)
+ luci-app-firewall(防火墙)
+ luci-app-nft-qos(服务质量)
+ luci-app-ttyd(TTYD终端)
+ luci-theme-argon(argon主题)

### 基本信息

+ 默认密码：无
+ 默认IP：`192.168.2.1`
+ 默认WAN口：第1个网卡接口
+ 默认LAN口：第2、3、4、5、6个接口

如果你想修改指定网口为WAN口，需要自行修改[files/etc/config/network](files/etc/config/network)中`config interface 'wan'`下的网卡接口

如果你接口超过6个，需要自行修改[files/etc/config/network](files/etc/config/network)中`option name 'br-lan'`下的网卡接口

### 云编译需要[在此](https://github.com/settings/tokens)生成`Fine-grained personal access tokens`，做如下设置：

+ Token name:`OPENWRT_TOKEN`
+ Expiration:`90 Days`，注意意味着token90天后过期，到时需要重新生成。你也可以选择`Custom...`，然后设置指定时间过期，最多可选一年
+ Repository access: `Only select repositories`->选中自己的`Actions-X86-OpenWrt`
+ Permissions:`Repository permissions`
    + Actions:`Read and write`
    + Contents:`Read and write`
    + Environments:`Read and write`
    + Variables:`Read and write`

以上操作生成token后，把token的值复制，然后依次点击击项目的`Settings`-`Secrets and variables`-`Actions`-`New repository secret`，之后填写内容：

+ Name:`OPENWRT_TOKEN`
+ Secret:`上面操作得到的Token的值`

最后点击`Add secret`，然后就可以在`Actions`中进行编译了

## 致谢

- [Microsoft](https://www.microsoft.com)
- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub](https://github.com)
- [GitHub Actions](https://github.com/features/actions)
- [tmate](https://github.com/tmate-io/tmate)
- [mxschmitt/action-tmate](https://github.com/mxschmitt/action-tmate)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cisco](https://www.cisco.com/)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean's OpenWrt](https://github.com/coolsnowwolf/lede)

## License

[MIT](https://github.com/P3TERX/Actions-OpenWrt/blob/master/LICENSE) © P3TERX
