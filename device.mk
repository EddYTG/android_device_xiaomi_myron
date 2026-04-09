#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# Branch: OrangeFox 14.1
# SoC   : Snapdragon 8 Elite Gen 5 (SM8850 / sun)
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

# ─── Inheritance ──────────────────────────────────────────────────────────────
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# ─── API level ────────────────────────────────────────────────────────────────
# ro.board.first_api_level=202504 (format YYYYMM, April 2025 — NOT an integer API level)
# ro.bootimage.build.version.sdk=36 → Android 16
BOARD_SHIPPING_API_LEVEL   := 34
PRODUCT_SHIPPING_API_LEVEL := 34

# ─── Dynamic partitions ───────────────────────────────────────────────────────
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_VIRTUAL_AB_OTA         := true

# ─── Fuse passthrough ─────────────────────────────────────────────────────────
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# ─── OrangeFox-specific settings ─────────────────────────────────────────────
$(call inherit-product, $(LOCAL_PATH)/fox_myron.mk)

# ─── Soong namespaces ─────────────────────────────────────────────────────────
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# ─── lptools ──────────────────────────────────────────────────────────────────
PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

# ─── Release key ──────────────────────────────────────────────────────────────
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/releasekey

# ─────────────────────────────────────────────────────────────────────────────
# Haptics: myron dùng qcom-hv-haptics (PMIC-based) — confirmed từ /proc/modules:
#   qcom_hv_haptics 118784 1 - Live
# cs40l26 KHÔNG có trong /vendor_dlkm/lib/modules/ → không phải kernel module
# vibratorfeature binary dùng PAL → qcom-hv-haptics path, KHÔNG đọc /lib/firmware/
# → KHÔNG cần prebuilt firmware files trong recovery ramdisk
# ─────────────────────────────────────────────────────────────────────────────

