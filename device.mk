#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# Branch: OrangeFox 14.1
# SoC   : Snapdragon 8 Elite Gen 5 (SM8850 / canoe)
#
# SPDX-License-Identifier: Apache-2.0
#
# v6 — PATCHED from ROM dump:
#   - service names corrected (vendor.keymint, vendor.weaver_nxp)
#   - se_omapi removed (OMAPI = Java app com.android.se on myron)
#   - all missing libs added from ROM dump
#   - libjc_weaver_transport.so / mi_weaver.so removed (not on ROM)
#
# v6.1 — BUILD FIX:
#   - Removed all PRODUCT_COPY_FILES targeting $(TARGET_COPY_OUT_RECOVERY)
#   - Root cause: PRODUCT_COPY_FILES installs odm/ dirs into out/recovery/root/
#     BEFORE the ramdisk rsync step. rsync then tries to replace those populated
#     real directories with the symlink at out/root/odm → "cannot delete non-empty
#     directory" → build fails at ramdisk_files-timestamp.
#   - Fix: all recovery/root/ files are already copied by the build system via
#     "cp -rf device/xiaomi/myron/recovery/root → out/recovery/root/" which runs
#     AFTER rsync. PRODUCT_COPY_FILES was redundant and conflicting.
#

DEVICE_PATH := device/xiaomi/myron

# ─── Inheritance ──────────────────────────────────────────────────────────────
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# ─── API level ────────────────────────────────────────────────────────────────
BOARD_SHIPPING_API_LEVEL   := 34
PRODUCT_SHIPPING_API_LEVEL := 34

# ─── Dynamic partitions ───────────────────────────────────────────────────────
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_VIRTUAL_AB_OTA         := true

# ─── Fuse passthrough ─────────────────────────────────────────────────────────
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

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
