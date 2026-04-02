#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# Branch: OrangeFox 14.1 (Android 16 / SDK 36)
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

# ─── Inheritance ──────────────────────────────────────────────────────────────
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# ─── API level ────────────────────────────────────────────────────────────────
BOARD_SHIPPING_API_LEVEL   := 34
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_TARGET_VNDK_VERSION := 34

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

# ─── OrangeFox config ─────────────────────────────────────────────────────────
$(call inherit-product, $(DEVICE_PATH)/fox_myron.mk)

# ─────────────────────────────────────────────────────────────────────────────
# Recovery root files — Vendor binaries
# (from TWRP 3.7.1_16 ramdisk — same vendor partition as sm8850)
# CRITICAL for Keymint / Gatekeeper / qseecomd to work during decryption
# ─────────────────────────────────────────────────────────────────────────────

# Vendor init RC files
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.boot-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.boot-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.gatekeeper-service-qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.gatekeeper-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.health-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.health-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.security.keymint-service-qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.security.keymint-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/qseecomd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/qseecomd.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/ssgtzd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/ssgtzd.rc

# Vendor VINTF manifests (CRITICAL for Keymint version detection)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service-qti.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service-qti.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.weaver-service.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.weaver-service.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.health-service.qti.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.health-service.qti.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/boot-service.qti.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/boot-service.qti.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml

# Vendor misc configs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/charger_fw_fstab.qti:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/charger_fw_fstab.qti \
    $(DEVICE_PATH)/recovery/root/vendor/etc/gpfspath_oem_config.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/gpfspath_oem_config.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/ssg/ta_config.json:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/ssg/ta_config.json \
    $(DEVICE_PATH)/recovery/root/vendor/etc/ueventd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/ueventd.rc

# WiFi configs (peach_v2 = sm8850 WiFi chipset path)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/wifi/peach_v2/WCNSS_qcom_cfg.ini \
    $(DEVICE_PATH)/recovery/root/vendor/etc/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/wifi/wpa_supplicant.conf

# WiFi ko loader script
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/bin/cp-wifi-ko.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/cp-wifi-ko.sh

# System VINTF framework manifest
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml
