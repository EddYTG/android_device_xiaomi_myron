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
# Confirmed: ro.product.first_api_level=35, ro.board.first_api_level=35 (getprop)
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

# ─── Required modules ─────────────────────────────────────────────────────────
TWRP_REQUIRED_MODULES += \
    prebuilt

# ─────────────────────────────────────────────────────────────────────────────
# Haptics firmware (cs40l26) — prebuilt, NOT in recovery/root/
# All other recovery root files are in recovery/root/ (SM8750 pattern)
# Confirmed: ro.odm.mm.vibrator.device_type=agm, resonant_frequency=170 (getprop)
# ─────────────────────────────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26.wmfw:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26.wmfw \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-calib.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-calib.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-calib.wmfw:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-calib.wmfw \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-a2h.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-a2h.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-a2h1.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-a2h1.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-dbc.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-dbc.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-dvl.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-dvl.bin \
    $(DEVICE_PATH)/prebuilt/lib/firmware/cs40l26-svc.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/cs40l26-svc.bin
