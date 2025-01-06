# Actions-X86-Openwrt

Build openwrt using GitHub Actions | 使用 GitHub Actions 云编译 openwrt

# 本项目构建的镜像，不包含任何无限网卡相关驱动

### 每周六早上自动编译Openwrt最新代码。编译后系统主题为argon，去除了openwrt部分默认选中的软件，同时nginx去除http自动转https，编译分支为`master` ，即最新代码

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

### 云编译需要[在此](https://github.com/settings/tokens?type=beta)生成`Fine-grained personal access tokens`，做如下设置：

+ Token name:`OPENWRT_TOKEN`
+ Expiration:`90 Days`，注意意味着token90天后过期，到时需要重新生成。你也可以选择`Custom...`，然后设置指定时间过期，最多可选一年。现在也可以选择`No expiration`，表示永不过期。
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
