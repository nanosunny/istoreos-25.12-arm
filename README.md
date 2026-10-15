<div align="center">
  <img src="./configfiles/screenshot/istoreos.png" style="max-width: 100%; height: auto;" />
  <h1>✨ 基于官方源码编译的iStoreOS固件 ✨</h1>

  <img src="https://img.shields.io/github/downloads/Kwonelee/iStoreOS-Native/total.svg?style=for-the-badge&color=32C955"/>
  <img src="https://img.shields.io/github/stars/Kwonelee/iStoreOS-Native.svg?style=for-the-badge&color=orange"/>
  <img src="https://img.shields.io/github/forks/Kwonelee/iStoreOS-Native.svg?style=for-the-badge&color=ff69b4"/>
  <img src="https://img.shields.io/github/license/Kwonelee/iStoreOS-Native.svg?style=for-the-badge&color=blueviolet"/>

  [![](https://img.shields.io/badge/-目录:-696969.svg)](#readme)
  [![](https://img.shields.io/badge/-项目介绍-FFFFFF.svg)](#-项目介绍-)
  [![](https://img.shields.io/badge/-插件说明-FFFFFF.svg)](#-插件说明-)
  [![](https://img.shields.io/badge/-支持设备-FFFFFF.svg)](#-支持设备-)
  [![](https://img.shields.io/badge/-项目截图-FFFFFF.svg)](#-项目截图-)
  [![](https://img.shields.io/badge/-Thanks-FFFFFF.svg)](#-Thanks-)
  [![](https://img.shields.io/badge/-免责声明-FFFFFF.svg)](#-免责声明-)
</div>

---

## 🤔 项目介绍 [![](https://img.shields.io/badge/-项目介绍-FFFFFF.svg)](#-项目介绍-)
**iStoreOS** 目标是提供一个人人会用的路由兼轻 **NAS 系统** ，不管是作为路由还是 NAS，你都有相似的操作体验

> [!TIP]
> 📢本项目提供了一个 **将第三方 rockchip 设备适配至 iStoreOS 官方源码** 的参考实现，支持通过源码编译生成 **`sysupgrade`** 格式固件。该格式可手动在线刷写升级， **一次适配，持续更新** ，告别重复刷机
> 
> 当前默认编译 **iStoreOS 25.12（内核 6.12）**，如需旧版可将 `.github/workflows/build-istoreos-6.x.yml` 中的 `REPO_BRANCH` 改回 `istoreos-24.10`
> 
> 使用此仓库必须设置机密token，Actions云编译固件时需要用到，通常在仓库设置里面。机密键名为 **`GH_TOKEN`**（严禁在仓库可视代码中填写，否则后果自负）

---

## 😅 插件说明 [![](https://img.shields.io/badge/-插件说明-FFFFFF.svg)](#-插件说明-)
固件内置插件与官方 iStoreOS 固件保持一致（配置来自官方 [config.buildinfo](https://fw0.koolcenter.com/iStoreOS/easepi-r1/config.buildinfo)），其余插件可从 iStore 商店安装。

已内置增强插件：
- **OpenAppFilter (OAF) 应用过滤**：基于 DPI 深度包检测的上网行为管理插件，支持游戏 / 视频 / 聊天 / 下载等数百款应用的识别与过滤、按时间段管控、用户分组等功能。
  - 源码 feed：`https://github.com/jjm2473/OpenAppFilter.git -b dev7`（jjm2473 针对 iStoreOS / 6.x 内核维护的适配分支）
  - Rockchip 设备：完整安装 `kmod-oaf` / `appfilter` / `luci-app-oaf` / `luci-i18n-oaf-zh-cn`；
  - Amlogic 设备：仅内置用户态 + Web 界面，`kmod-oaf` 在首次启动后通过「应用过滤」界面在线匹配 unifreq 定制内核版本安装。
  - ⚠️ 使用提示：
    - 请将设备作为**主路由**使用，并**关闭防火墙中的软件/硬件流量加速（flow offloading / SFE / Shortcut-FE）**，否则会绕过 netfilter 导致应用识别失效；
    - 若与广告过滤、QoS、多 WAN、负载均衡等同样操作 nf_conn mark 的模块冲突，可能出现过滤无效，请按需关闭冲突功能；
    - 首次使用请在 Web 界面「网络 → 应用过滤」中开启服务、勾选需要过滤的应用并保存生效，特征库可在插件页面在线更新。
- **晶晨宝盒（luci-app-amlogic）**：Amlogic / Rockchip / Allwinner 盒子专用管理工具（默认内置在 Amlogic 固件，Rockchip 固件不启用）。
  - 源码：`https://github.com/ophub/luci-app-amlogic`
  - 提供功能：**安装系统到 eMMC**、手动/在线升级固件、**在线升级 unifreq 定制内核**、固件备份与恢复、快照管理、设置自定义固件/内核下载源。
  - Web 位置：「系统 → 晶晨宝盒」


## 😊 支持设备 [![](https://img.shields.io/badge/-支持设备-FFFFFF.svg)](#-支持设备-)
| 设备         |  状态     |  包名                                                                  | 备注                        |
|-------------|:---------:| ----------------------------------------------------------------------- |:----------------------------:|
| panther-x2  |    ✅    | istoreos-rockchip-armv8-panther_panther-x2-squashfs-sysupgrade.img.gz   | 🟢 已测试（Rockchip RK3566）     |
| g68-plus    |    ✅    | istoreos-rockchip-armv8-nsy_g68-plus-squashfs-sysupgrade.img.gz         | 🟡 未测试（Rockchip RK3568）     |
| **R68P**    |    ✅    | istoreos-rockchip-armv8-r68p_r68p-squashfs-sysupgrade.img.gz            | 🟡 未测试（Rockchip RK3568）
|
| 魔百和 M302A|    ✅    | istoreos-s905l3b-m302a-*.img.gz                                          | 🟡 新增（Amlogic S905L3B，需U盘启动） |
| 其他        |    ⏳    |                                                                          |                              |

✅ 支持 - ⏳ 计划中 - ⭕ 不支持

### 🎛️ R68P（RK3568 双网口盒子）说明

R68P 是 RK3568 双网口盒子，硬件接近 Radxa ROCK 3A，刷 ROCK 3A 的 Armbian 可正常启动，但刷通用 ROCK 3A OpenWrt 会出现**WAN/LAN 错位**（启动后活跃口变 WAN，另一个口显示 LAN 但链路 down）。本仓库做了以下针对性修复：

1. **专属 DTS**（`configfiles/dts/rk3568/rk3568-r68p.dts`）：显式设置 `ethernet0 = &gmac0`、`ethernet1 = &gmac1`，从内核层面固定网卡枚举顺序，避免随机错位；同时对两个 RTL8211F PHY 分别配置 reset GPIO 和 tx/rx 延迟，保证两路 rgmii 链路都能正常 Link Up。
2. **`02_network` 网口绑定**：`r68p,rk3568` 板型固定 `ucidef_set_interfaces_lan_wan "eth0" "eth1"`，靠近电源口的 RJ45 为 LAN，另一个为 WAN。
3. **兼容性**：`SUPPORTED_DEVICES` 同时追加了 `radxa,rock-3a` 兼容标记，因此**已有 ROCK 3A 系统的设备也可以直接刷 sysupgrade 包升级**，无需重新写盘。

**刷机流程（R68P）：**
1. 先跑 `Sync Files`，再跑 `Build iStore OS 6.x`；
2. 下载 `istoreos-rockchip-armv8-r68p_r68p-squashfs-sysupgrade.img.gz`；
3. 写 SD 卡插入盒子启动，或者从 ROCK 3A 系统的 Web 升级界面直接选 sysupgrade 包（保留配置）升级；
4. 启动后 LAN 口默认 IP `192.168.100.1`，插线即能进管理页。

### 📺 Amlogic 魔百和 M302A 说明

M302A（S905L3B）是晶晨平台运营商电视盒子，与 panther-x2 / g68-plus 的 Rockchip 平台走**不同的构建流水线**：

- Rockchip 设备：执行 **`Build iStore OS 6.x`** 工作流，走 iStoreOS 官方 `rockchip/armv8` 源码（默认主线 6.12 内核，编译时随 `istoreos-25.12` 分支自动取最新）；
- 魔百和 M302A：执行 **`Build iStore OS for Amlogic (M302A)`** 工作流，编译 `armsr/armv8` 通用 rootfs（基于 iStoreOS-25.12 最新版），再用 [ophub/amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) 脚本注入 unifreq **6.12.y** 定制内核（与 iStoreOS-25.12 主线内核大版本对齐，`KERNEL_AUTO_LATEST=true` 会自动拉取 ophub 发布的最新小版本）+ DTB + bootloader 打包。

> **关于"最新内核"**：iStoreOS 官方未发布适配 Amlogic S905L3B 的原生内核（缺少晶晨专用 DTB / bootloader / eMMC 驱动），因此 Amlogic 设备无法直接使用 iStoreOS 官方内核启动；这里采用 unifreq 维护的晶晨定制内核 **6.12.y**（主流线与 iStoreOS-25.12 官方内核一致，且持续更新最新小版本），由 ophub 脚本在打包阶段注入。内核版本可在 Actions 运行时通过 `kernel_version` 参数切换为 `6.6.y` 或 `6.1.y`。

**刷机流程（M302A）：**
1. 从 Actions / Releases 下载 `istoreos-s905l3b-m302a-*.img.gz`；
2. 用 Rufus / balenaEtcher **直接写入 U 盘**（无需解压）；
3. 将 U 盘插入 M302A 靠近网口的 USB 口，**短接 CPU 旁 4R19 电阻**（或 USB Burning Tool 写入降级 bootloader）从 U 盘启动；
4. U 盘启动后，默认 DHCP 从主路由获取 IP，进入 Web →「系统 → 晶晨宝盒」→「安装 OpenWrt」，或 SSH 执行 `install-to-emmc.sh` 写入 eMMC；
5. 拔掉 U 盘重启，即进入 iStoreOS。

**晶晨宝盒功能（M302A 已内置）：**
- **安装到 eMMC**：一键把 U 盘系统写入内置存储；
- **在线升级固件**：在「晶晨宝盒 → 固件升级」里直接从本仓库 Releases 下载新版本，不用重新写 U 盘；
- **在线升级内核**：在「晶晨宝盒 → 内核管理」里一键升级/切换 unifreq 内核版本（如在 6.12.y / 6.6.y 之间切换）；
- **备份/恢复/快照**：保留配置与系统快照，方便折腾。

**注意：**
- M302A 多数批次**百兆网口、无内置 WiFi**，如需 WiFi 请额外插 USB 网卡（已内置 mt7601u / rtl8188eu / rtl8812au 驱动）；
- OAF（应用过滤）用户态界面已内置，`kmod-oaf` 内核模块**首次启动后**在 Web 界面「应用过滤」里点一下内核安装即可自动匹配 unifreq 6.12.y 内核版本；
- 晶晨宝盒的固件下载地址默认指向**当前仓库**的 Releases，若你 Fork 到自己账号下，首次启动后请到「系统 → 晶晨宝盒 → 设置」里把"OpenWrt 固件下载地址"改成你自己的 GitHub 仓库地址（格式 `https://github.com/你的用户名/你的仓库名`）；
- 魔百和因运营商定制批次多（ZN / BYT / CW 等代工），网卡/WiFi 可能略有差异，若启动后外设不工作可反馈具体代工信息进一步定制 DTB。

---

## 🤗 项目截图 [![](https://img.shields.io/badge/-项目截图-FFFFFF.svg)](#-项目截图-)
![screenshots](./configfiles/screenshot/screenshot2.png)

---

## 🌟 Star戳一戳，好运加满！😆
> **"点过 `Star` 的朋友，颜值与智慧双双在线！✨"**
> 
> **"您的每一个⭐️，都是开源土壤里的一缕阳光，让灵感发芽，让创造生长~"**

## 🎉 Thanks [![](https://img.shields.io/badge/-Thanks-FFFFFF.svg)](#-Thanks-)
- [istoreos](https://github.com/istoreos/istoreos)
- [linux-6.6.y](https://github.com/unifreq/linux-6.6.y)
- https://github.com/Kwonelee/iStoreOS-Actions

## 🙏 免责声明 [![](https://img.shields.io/badge/-免责声明-FFFFFF.svg)](#-免责声明-)
- 📚 本固件仅供学习研究，严禁用于任何商业用途
- 🤝 使用本固件产生的所有后果均由使用者自行承担
- ⚠️ 固件仍可能存在缺陷，开发者不提供任何形式的技术支持
- 📜 请严格遵守国家网络安全法律法规，合法使用

<a href="#readme">
<img src="https://img.shields.io/badge/-返回顶部-FFFFFF.svg" title="返回顶部" align="right"/>
</a>
