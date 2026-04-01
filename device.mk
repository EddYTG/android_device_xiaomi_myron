# Copyright (C) 2026 OrangeFox Recovery Project
# SPDX-License-Identifier: Apache-2.0

DEVICE_PATH := device/xiaomi/myron

# Shipping API
BOARD_SHIPPING_API_LEVEL   := 35
PRODUCT_SHIPPING_API_LEVEL := 35

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_VIRTUAL_AB_OTA         := true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Packages
PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

# OrangeFox config
$(call inherit-product, $(DEVICE_PATH)/fox_myron.mk)

# ─────────────────────────────────────────────────────────
# Recovery root files — Vendor (from TWRP 3.7.1_16 ramdisk)
# These are CRITICAL for Keymint/Gatekeeper/qseecomd to work
# ─────────────────────────────────────────────────────────

# Vendor init RC files (services: qseecomd, keymint, gatekeeper, etc.)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.boot-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.boot-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.gatekeeper-service-qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.gatekeeper-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.health-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.health-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.security.keymint-service-qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.security.keymint-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/qseecomd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/qseecomd.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/ssgtzd.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/ssgtzd.rc

# Vendor VINTF manifests — CRITICAL for TWRP Keymint version detection
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

# WiFi configs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/wifi/peach_v2/WCNSS_qcom_cfg.ini \
    $(DEVICE_PATH)/recovery/root/vendor/etc/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/wifi/wpa_supplicant.conf

# WiFi ko script — MUST be in /system/bin (service path in init.recovery.wifi.rc)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/bin/cp-wifi-ko.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/cp-wifi-ko.sh

# System VINTF framework manifest
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml
