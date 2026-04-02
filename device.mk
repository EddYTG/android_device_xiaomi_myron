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

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# ─── API level ────────────────────────────────────────────────────────────────
BOARD_SHIPPING_API_LEVEL   := 35
PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_TARGET_VNDK_VERSION := 35

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

# ─────────────────────────────────────────────────────────────────────────────
# Recovery root files — ODM binaries (NXP JavaCard HSM / Weaver / Vibrator)
# CRITICAL for decryption: weaver-service.nxp-qti + keymint3.strongbox.nxp
# ─────────────────────────────────────────────────────────────────────────────

# ODM HAL binaries
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp \
    $(DEVICE_PATH)/odm/bin/hw/android.hardware.weaver-service.nxp-qti:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.weaver-service.nxp-qti \
    $(DEVICE_PATH)/odm/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service

# ODM libs (NXP JavaCard transport + weaver + miauthsecretd)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/odm/lib64/ese_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/ese_weaver.so \
    $(DEVICE_PATH)/odm/lib64/libjc_keymint3.nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint3.nxp.so \
    $(DEVICE_PATH)/odm/lib64/libjc_keymint_transport_nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint_transport_nxp.so \
    $(DEVICE_PATH)/odm/lib64/libkeymint_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libkeymint_empty-nxp.so \
    $(DEVICE_PATH)/odm/lib64/libweaver_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libweaver_empty-nxp.so \
    $(DEVICE_PATH)/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so
# NOTE: libtensorflowlite_touch_c.so intentionally excluded — touch AI inference only, not needed in recovery

# ODM init RC files
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc \
    $(DEVICE_PATH)/odm/etc/init/android.hardware.weaver-service.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.weaver-service.rc \
    $(DEVICE_PATH)/odm/etc/init/se_omapi.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/se_omapi.rc \
    $(DEVICE_PATH)/odm/etc/init/prepdecrypt.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/prepdecrypt.rc \
    $(DEVICE_PATH)/odm/etc/init/variant-script.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/variant-script.rc \
    $(DEVICE_PATH)/odm/etc/init/init.kernel.post_boot-sun.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/init.kernel.post_boot-sun.rc \
    $(DEVICE_PATH)/odm/etc/init/touch_report.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/touch_report.rc \
    $(DEVICE_PATH)/odm/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc

# ODM VINTF manifests
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml \
    $(DEVICE_PATH)/odm/etc/vintf/manifest/se_omapi.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/se_omapi.xml \
    $(DEVICE_PATH)/odm/etc/vintf/manifest/vendor.xiaomi.hardware.vibratorfeature.service.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/vendor.xiaomi.hardware.vibratorfeature.service.xml

# ODM vendor lib64 — miauthsecretd runtime copy (also needed by weaver at runtime)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so
