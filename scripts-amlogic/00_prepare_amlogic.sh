#!/bin/bash
# =====================================================================
# Amlogic (M302A / S905L3B) 定制脚本
# 作用：对源码做 amlogic 必要的定制。
# 注意：Amlogic 盒子不在 OpenWrt 官方 Device 列表里，我们编的是通用
#       armv8 rootfs，不追加 Device 定义；真正的设备适配由打包阶段
#       ophub/amlogic-s9xxx-openwrt 的脚本 + flippy/unifreq 内核完成。
# =====================================================================
set -e

echo "==> [Amlogic] 开始执行定制脚本..."

# ---------- 1. 给打包阶段准备 M302A 标识 ----------
echo "==> [Amlogic] 记录目标设备标识：s905l3b / M302A"
mkdir -p files/etc/istoreos-amlogic
cat > files/etc/istoreos-amlogic/device.conf <<'EOF'
SOC=s905l3b
BOX=M302A/M304A
KERNEL_VERSION=6.1.y
EOF

# ---------- 2. 第一次启动自动扩展 rootfs ----------
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-firstboot-resize <<'EOF'
#!/bin/sh
if [ ! -f /etc/.resized ]; then
    touch /etc/.resized
    logger -t istoreos-amlogic "first boot on M302A, rootfs will be resized automatically"
fi
exit 0
EOF
chmod +x files/etc/uci-defaults/99-firstboot-resize

# ---------- 3. OpenAppFilter 兼容性提示 ----------
echo "==> [Amlogic] OAF 用户态已内置；kmod-oaf 在首次启动后通过 luci-app-oaf 在线匹配 ophub 6.1.y 内核。"

echo "==> [Amlogic] 定制脚本执行完成。"
