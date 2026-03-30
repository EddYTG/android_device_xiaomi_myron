#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device: Xiaomi myron (sm8850_thales / Snapdragon 8 Elite)
# Analyzed from: recovery.img ramdisk (boot header v4, LZ4 legacy)
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

# ─────────────────────────────────────────────────────────
# Build flags — Android 15 / OFox 12.1
# ─────────────────────────────────────────────────────────
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := \
    soong-libaosprecovery_defaults \
    soong-libguitwrp_defaults \
    soong-libminuitwrp_defaults \
    soong-vold_defaults

# ─────────────────────────────────────────────────────────
# Architecture — arm64 / oryon (SD8 Elite)
# ─────────────────────────────────────────────────────────
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := oryon

# ─────────────────────────────────────────────────────────
# Power / CPU scheduler (SD8 Elite)
# ─────────────────────────────────────────────────────────
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# ─────────────────────────────────────────────────────────
# Platform — sm8850 (Snapdragon 8 Elite)
# Confirmed from: ro.board.platform=xiaomi_sm8850
#                 ro.product.board=sun
# ─────────────────────────────────────────────────────────
PRODUCT_PLATFORM := sun
TARGET_BOARD_PLATFORM := sm8850
TARGET_BOARD_PLATFORM_GPU := qcom-adreno840
QCOM_BOARD_PLATFORMS += sm8850

# ─────────────────────────────────────────────────────────
# Bootloader
# ─────────────────────────────────────────────────────────
TARGET_BOOTLOADER_BOARD_NAME := myron
TARGET_NO_BOOTLOADER := true

# ─────────────────────────────────────────────────────────
# Kernel — prebuilt (boot header v4, page_size=4096, LZ4)
# Confirmed from: ramdisk analysis
# ─────────────────────────────────────────────────────────
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_RAMDISK_USE_LZ4 := true

# Kernel: compile từ source (không dùng prebuilt)
# Nếu muốn prebuilt: thêm lại TARGET_FORCE_PREBUILT_KERNEL và TARGET_PREBUILT_KERNEL
# và đặt file kernel vào prebuilt/kernel
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
endif


# Recovery image không chứa kernel riêng (A-only nhưng dùng init_boot)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := false

# ─────────────────────────────────────────────────────────
# A/B — device này A-only có recovery partition riêng
# Confirmed từ: ramdisk có /dev/block/bootdevice/by-name/recovery
# prepdecrypt.sh detect "recovery partition found"
# ─────────────────────────────────────────────────────────
AB_OTA_UPDATER := false
# Nhưng vẫn cần virtual_ab vì ro.virtual_ab.enabled=true
BOARD_USES_RECOVERY_AS_BOOT := false

# ─────────────────────────────────────────────────────────
# Partitions — confirmed từ ramdisk props
# ro.vendor.build.ab_ota_partitions=boot,dtbo,init_boot,odm,product,
# system,system_dlkm,system_ext,vbmeta,vbmeta_system,vendor,
# vendor_boot,vendor_dlkm
# ─────────────────────────────────────────────────────────
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600   # = 100MB, confirmed từ file size

BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Dynamic partitions
BOARD_SUPER_PARTITION_SIZE := 9126805504           # TODO: xác nhận từ device
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    odm

BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 9122611200

# EROFS (chuẩn Android 15 / SD8 Elite)
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower,$(p))))

# ─────────────────────────────────────────────────────────
# Verified Boot (AVB)
# ─────────────────────────────────────────────────────────
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# ─────────────────────────────────────────────────────────
# Crypto / FBE Decryption
# Confirmed: FBE present, keymint-strongbox, weaver-service
# odm/bin/hw/android.hardware.security.keymint-service.strongbox
# odm/bin/hw/android.hardware.weaver-service
# odm/lib64: ese_weaver_thales.so, libjc_keymint-thales.so
# ─────────────────────────────────────────────────────────
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2

# ─────────────────────────────────────────────────────────
# Recovery
# ─────────────────────────────────────────────────────────
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_INCLUDE_FASTBOOTD := true
TW_SKIP_ADDITIONAL_FSTAB := true

# ─────────────────────────────────────────────────────────
# Display — confirmed từ twres/ui.xml
# resolution: 1080x1920
# ─────────────────────────────────────────────────────────
TARGET_USES_VULKAN := true
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 1200
TW_MAX_BRIGHTNESS := 4094
TW_FRAMERATE := 120
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := true

# ─────────────────────────────────────────────────────────
# File system / Storage
# ─────────────────────────────────────────────────────────
RECOVERY_SDCARD_ON_DATA := true
TARGET_USES_MKE2FS := true
TW_ENABLE_FS_COMPRESSION := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INCLUDE_NTFS_3G := true
TW_NO_EXFAT_FUSE := true

# ─────────────────────────────────────────────────────────
# Tools
# ─────────────────────────────────────────────────────────
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_USE_TOOLBOX := true

# ─────────────────────────────────────────────────────────
# Debug — bật để phân tích log decrypt
# ─────────────────────────────────────────────────────────
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# ─────────────────────────────────────────────────────────
# Vibrator AIDL (bắt buộc SD8 Elite)
# Confirmed: vendor.xiaomi.hardware.vibratorfeature.service trong odm
# ─────────────────────────────────────────────────────────
TW_SUPPORT_INPUT_AIDL_HAPTICS := true

# ─────────────────────────────────────────────────────────
# OMAPI / Secure Element
# Confirmed: odm/bin/se_omapi, odm/lib64/ese_weaver_thales.so
# ─────────────────────────────────────────────────────────
TW_INCLUDE_OMAPI := true

# ─────────────────────────────────────────────────────────
# Vendor modules — load touch & sensor KO
# (Xác nhận từ odm/variant/myron firmware: focaltech, fts)
# Cần lấy đúng tên .ko từ vendor partition của device
# ─────────────────────────────────────────────────────────
TW_LOAD_VENDOR_MODULES := "oplus_bsp_tp_common.ko oplus_bsp_tp_focaltech.ko oplus_bsp_tp_ft3658u_spi.ko q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko gpr_dlkm.ko spf_core_dlkm.ko adsp_loader_dlkm.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# ─────────────────────────────────────────────────────────
# Misc TWRP
# ─────────────────────────────────────────────────────────
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone45/temp"

# ─────────────────────────────────────────────────────────
# USB — confirmed từ init.recovery.usb.rc
# VID=0x2717 (Xiaomi), ADB PID=0xD001
# ─────────────────────────────────────────────────────────
# TW_USB_VID := 18D1   # Dùng Google VID cho ADB
# TW_USB_PID := D001

# ─────────────────────────────────────────────────────────
# Security patch — bypass anti-rollback
# Confirmed từ prop.default: security_patch=2099-12-31
# ─────────────────────────────────────────────────────────
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1


