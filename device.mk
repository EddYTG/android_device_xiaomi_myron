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

# ─── ODM Decrypt chain — NXP KeyMint3 + Weaver ───────────────────────────────
# Confirmed from ROM dump: NXP architecture, not Thales
# service names: vendor.keymint / vendor.keymint-strongbox / vendor.secure_element / vendor.weaver_nxp

# ODM binaries
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp \
    $(DEVICE_PATH)/recovery/root/odm/bin/hw/android.hardware.weaver-service.nxp-qti:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/hw/android.hardware.weaver-service.nxp-qti

# ODM lib64 — NXP JavaCard libs (confirmed from ROM)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/lib64/ese_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/ese_weaver.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libjc_keymint3.nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint3.nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libjc_keymint_transport_nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libjc_keymint_transport_nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libkeymint_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libkeymint_empty-nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libkeymint_empty-thales.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libkeymint_empty-thales.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libweaver_empty-nxp.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libweaver_empty-nxp.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libweaver_empty-thales.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libweaver_empty-thales.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/vendor.xiaomi.hardware.miauthsecretd-V1-ndk.so

# ─── Decrypt chain scripts ────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/bin/secure-element-ta-setup.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/secure-element-ta-setup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/secure-element-followup.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/secure-element-followup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/decrypt-gate.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/decrypt-gate.sh

# ─── Init RC files ────────────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.security.keymint3-service.strongbox.nxp.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/android.hardware.weaver-service.nxp.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/android.hardware.weaver-service.nxp.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/secure-element-ta-setup.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/secure-element-ta-setup.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/secure-element-followup.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/secure-element-followup.rc \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/decrypt-gate.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/decrypt-gate.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.security.onekeymint-service-qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.security.onekeymint-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/android.hardware.secure_element-service.qti.rc

# ─── VINTF manifest fragments ─────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.keymint3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.security.sharedsecret3-service.strongbox.nxp.xml \
    $(DEVICE_PATH)/recovery/root/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/vintf/manifest/android.hardware.weaver-service.nxp.xml

# ─── Platform canoe — manifest + post_boot ────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest_canoe.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest_canoe.xml \
    $(DEVICE_PATH)/recovery/root/odm/bin/init.kernel.post_boot-canoe_default_6_2.sh:$(TARGET_COPY_OUT_RECOVERY)/root/odm/bin/init.kernel.post_boot-canoe_default_6_2.sh \
    $(DEVICE_PATH)/recovery/root/odm/etc/init/init.kernel.post_boot-canoe.rc:$(TARGET_COPY_OUT_RECOVERY)/root/odm/etc/init/init.kernel.post_boot-canoe.rc

# ─── Vendor libs — đã dump từ ROM myron ──────────────────────────────────────
# Nhóm 1: eSE provision chain
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libesesbprovision.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libesesbprovision.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libprovisioner_qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libprovisioner_qti.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libGPQeSE.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libGPQeSE.so

# Nhóm 2: TA loader chain
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libtrustedapploader.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libtrustedapploader.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcpion.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcpion.so

# Nhóm 3: Sandbox
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libminijail.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libminijail.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libavservices_minijail.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libavservices_minijail.so

# Nhóm 4: Xiaomi auth
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/vendor.xiaomi.hardware.mlipay-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/vendor.xiaomi.hardware.mlipay-V1-ndk.so

# Nhóm 5: KeyMint dependencies (từ ROM dump)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libhidlbase.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libhidlbase.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libutils.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcppbor_external.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcppbor_external.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_messages.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_messages.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_portable.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_portable.so

# Nhóm 6: Vendor libs từ CN tree (đã có sẵn)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/android.hardware.security.keymint-V4-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.security.keymint-V4-ndk.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/lib_android_keymaster_keymint_utils_V3.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/lib_android_keymaster_keymint_utils_V3.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint_remote_prov_support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint_remote_prov_support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint_support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint_support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcrypto.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcrypto.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libmisight.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libmisight.so

# ─── vendor.qti.hardware.secureprocessor ─────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/bin/hw/vendor.qti.hardware.secureprocessor:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/hw/vendor.qti.hardware.secureprocessor

# ─── ODM touch libs ───────────────────────────────────────────────────────────
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtensorflowlite_touch_c.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtensorflowlite_touch_c.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtouchreport.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtouchreport.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtouchreport_alg.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtouchreport_alg.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtouchreport_alg_fts.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtouchreport_alg_fts.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtouchreport_hal.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtouchreport_hal.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/libtouchreport_sensor.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/libtouchreport_sensor.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/sensors.touch.detect.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/sensors.touch.detect.so \
    $(DEVICE_PATH)/recovery/root/odm/lib64/vendor.xiaomi.hw.touchfeature-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/odm/lib64/vendor.xiaomi.hw.touchfeature-V1-ndk.so
