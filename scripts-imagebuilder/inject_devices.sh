#!/bin/bash
#
# ImageBuilder 自定义设备注入脚本
# 在 ImageBuilder 工作目录中执行，注入 panther-x2 / g68-plus / r68p 三个设备的定义
#

set -e

IB_DIR="$1"
REPO_ROOT="$2"

if [ -z "$IB_DIR" ] || [ ! -d "$IB_DIR" ]; then
    echo "用法: $0 <imagebuilder目录> <仓库根目录>"
    exit 1
fi

cd "$IB_DIR"

TARGET="rockchip"
SUBTARGET="armv8"

echo "========================================"
echo "注入自定义设备到 ImageBuilder"
echo "ImageBuilder 目录: $IB_DIR"
echo "仓库根目录: $REPO_ROOT"
echo "========================================"

# ============================================================
# 1. legacy.mk —— 设备定义
# ============================================================
LEGACY_MK="target/linux/${TARGET}/image/legacy.mk"
mkdir -p "$(dirname "$LEGACY_MK")"
if [ ! -f "$LEGACY_MK" ]; then
    echo "# Created by custom ImageBuilder workflow" > "$LEGACY_MK"
fi

echo ""
echo "[1/4] 注入设备定义到 $LEGACY_MK"

append_device_block() {
    local devname="$1"
    if grep -q "$devname" "$LEGACY_MK"; then
        echo "  - $devname 已存在，跳过"
        return 0
    fi
    echo "  + 添加 $devname"
    # 从 stdin 读取块内容
    cat >> "$LEGACY_MK"
}

# Panther-X2 (RK3566)
append_device_block "panther_panther-x2" <<'DEV_EOF'

define Device/panther_panther-x2
$(call Device/Legacy/rk3566,$(1))
  DEVICE_VENDOR := PanthX
  DEVICE_MODEL := Panther-X2
  DEVICE_DTS := rk3568/rk3566-panther-x2
  DEVICE_PACKAGES := kmod-r8125 kmod-nvme kmod-scsi-core
  SUPPORTED_DEVICES += panther,panther-x2
endef
TARGET_DEVICES += panther_panther-x2
DEV_EOF

# NSY G68-Plus (RK3568)
append_device_block "nsy_g68-plus" <<'DEV_EOF'

define Device/nsy_g68-plus
$(call Device/Legacy/rk3568,$(1))
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68-Plus
  DEVICE_DTS := rk3568/rk3568-nsy-g68-plus
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7916-firmware kmod-switch-rtl8367s kmod-nvme kmod-scsi-core
  SUPPORTED_DEVICES += nsy,g68-plus
endef
TARGET_DEVICES += nsy_g68-plus
DEV_EOF

# R68P (RK3568 单网口)
append_device_block "r68p_r68p" <<'DEV_EOF'

define Device/r68p_r68p
$(call Device/Legacy/rk3568,$(1))
  DEVICE_VENDOR := R68P
  DEVICE_MODEL := R68P RK3568 Box
  DEVICE_DTS := rk3568/rk3568-r68p
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-usb-net-rtl8152 kmod-usb-net-rndis
  SUPPORTED_DEVICES += r68p,rk3568 radxa,rock-3a
endef
TARGET_DEVICES += r68p_r68p
DEV_EOF

# ============================================================
# 2. 复制自定义 DTS
# ============================================================
echo ""
echo "[2/4] 复制自定义 DTS 文件"
# OpenWrt rockchip/armv8 平台中 RK3566/RK3568/RK3588 各有独立的 dts 子目录
# 本项目目前只有 RK3568 系列（含 RK3566 设备 DTS，内核统一放在 rk3568/ 子目录）
DTS_TARGET="target/linux/${TARGET}/dts/rk3568"
mkdir -p "$DTS_TARGET"

for dts in "$REPO_ROOT"/configfiles/dts/rk3568/*.dts; do
    [ -f "$dts" ] || continue
    fname=$(basename "$dts")
    # 跳过 Amlogic 误放的 DTS 和上游已存在的 rock-3a
    case "$fname" in
        meson-gxl-*|rk3568-rock-3a*) continue ;;
    esac
    cp -f "$dts" "$DTS_TARGET/$fname"
    echo "  + rk3568/$fname"
done


# ============================================================
# 3. 02_network 板级网卡配置
# ============================================================
echo ""
echo "[3/4] 注入 02_network 板级网卡配置"
NET_DIR="target/linux/${TARGET}/${SUBTARGET}/base-files/etc/board.d"
NET_FILE="${NET_DIR}/02_network"
mkdir -p "$NET_DIR"

if [ ! -f "$NET_FILE" ]; then
    cat > "$NET_FILE" <<'NETEOF'
#!/bin/sh
#
# Copyright (C) 2016 OpenWrt.org
#

. /lib/functions/uci-defaults.sh

board_config_update

case "$(board_name)" in
esac

board_config_flush

exit 0
NETEOF
fi
chmod +x "$NET_FILE"

if ! grep -q 'r68p,rk3568' "$NET_FILE"; then
    # 在 esac 行之前插入我们的三个板型
    sed -i 's/^esac$/"r68p,rk3568")\n\tucidef_set_interface_lan "eth0" "dhcp"\n\t;;\n\n"panther,panther-x2")\n\tucidef_set_interfaces_lan_wan "eth0" "eth1"\n\t;;\n\n"nsy,g68-plus")\n\tucidef_set_interfaces_lan_wan "lan1 lan2 lan3 lan4" "wan"\n\t;;\nesac/' "$NET_FILE"
    echo "  + 网卡绑定已注入"
else
    echo "  - 网卡绑定已存在，跳过"
fi

# ============================================================
# 4. 注入 g68-plus 的 MT7916 EEPROM 固件 + files 目录
# ============================================================
echo ""
echo "[4/4] 注入额外固件文件和 files 目录"
FILES_DIR="files"
mkdir -p "${FILES_DIR}/lib/firmware/mediatek"
EEPROM_SRC="$REPO_ROOT/configfiles/nsy-g68-plus/mt7916_eeprom.bin"
if [ -f "$EEPROM_SRC" ]; then
    cp -f "$EEPROM_SRC" "${FILES_DIR}/lib/firmware/mediatek/"
    echo "  + mt7916_eeprom.bin"
fi

if [ -d "$REPO_ROOT/files" ]; then
    cp -a "$REPO_ROOT/files"/. "${FILES_DIR}/" 2>/dev/null || true
    echo "  + 已合并仓库自定义 files 目录"
fi

echo ""
echo "========================================"
echo "设备注入完成"
echo "========================================"
echo "legacy.mk 中当前 TARGET_DEVICES:"
grep "^TARGET_DEVICES +=" "$LEGACY_MK" | tail -10
