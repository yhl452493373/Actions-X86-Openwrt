# Actions-X86-Lede
Build lede using GitHub Actions | 使用 GitHub Actions 云编译 lede


#### 每周六早上自动编译Lede最新代码。编译后系统主题为argon，去除了lede默认选中的软件，同时nginx去除http自动转https。目前的内核为`6.1.x`。
+ luci-app-openclash(科学上网)
+ luci-app-npc(内网穿透)
+ luci-app-ddns(动态DNS)
+ luci-app-upnp(即插即用)
+ luci-app-samba4(网络共享)
+ luci-app-autoreboot(定时重启)
+ luci-app-poweroff(关机)
+ luci-app-firewall(防火墙)
+ luci-app-nlbwmon(网络监控)
+ luci-app-qos(服务质量)
+ luci-app-arpbind(IP/MAC 绑定)
+ luci-app-ttyd(TTYD终端)
+ luci-theme-argon(argon主题)
+ luci-theme-neobird(neobird主题)

## 本系统不包含任何无线网卡相关功能，防火墙为Firewall，不是Firewall4。这两项选择后lede编译不通过。

## 默认密码：`password`，默认IP：`192.168.2.1`

### 云编译需要[在此](https://github.com/settings/tokens)生成`Fine-grained personal access tokens`，做如下设置：
+ Token name:`LEDE_TOKEN`
+ Expiration:`90 Days`，注意意味着token90天后过期，到时需要重新生成
+ Repository access: `Only select repositories`->选中自己的`Actions-X86-Lede`
+ Permissions:`Repository permissions`
  + Actions:`Read and write`
  + Contents:`Read and write`
  + Environments:`Read and write`
  + Variables:`Read and write`

以上操作生成token后，把token的值复制，然后依次点击击项目的`Settings`-`Secrets and variables`-`Actions`-`New repository secret`，之后填写内容：
+ Name:`LEDE_TOKEN`
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
