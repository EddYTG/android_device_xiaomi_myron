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

# ─── ODM Decrypt chain — NXP JavaCard KeyMint v3 + Weaver ────────────────────
# Binaries (tên đúng từ ROM thực tế — confirmed từ files.zip dump)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp \
    $(DEVICE_PATH)/recovery/root/odm/bin/hw/android.hardware.weaver-service.nxp-qti:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.weaver-service.nxp-qti \
    $(DEVICE_PATH)/recovery/root/odm/bin/se_omapi:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/se_omapi

# ODM lib64 — NXP JavaCard libs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/lib64/ese_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/ese_weaver.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libjc_keymint3.nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint3.nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libjc_keymint_transport_nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint_transport_nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libkeymint_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libkeymint_empty-nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libkeymint_empty-thales.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libkeymint_empty-thales.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libweaver_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libweaver_empty-nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libweaver_empty-thales.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libweaver_empty-thales.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so

# Vendor lib64
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/lib_android_keymaster_keymint_utils_V3.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/lib_android_keymaster_keymint_utils_V3.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libmisight.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libmisight.so

# ─── Decrypt chain scripts ────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/bin/persist-alias-setup.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/persist-alias-setup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/secure-element-ta-setup.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/secure-element-ta-setup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/secure-element-followup.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/secure-element-followup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/decrypt-gate.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/decrypt-gate.sh

# ─── Init RC files ────────────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/android.hardware.weaver-service.nxp.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.weaver-service.nxp.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/se_omapi.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/se_omapi.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/persist-alias-setup.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/persist-alias-setup.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/secure-element-ta-setup.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/secure-element-ta-setup.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/secure-element-followup.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/secure-element-followup.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/decrypt-gate.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/decrypt-gate.rc

# ─── VINTF manifest fragments ─────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml
