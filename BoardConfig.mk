#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device : Xiaomi F8U / POCO F8 Ultra / Redmi K90 Pro Max (myron)
# SoC    : Snapdragon 8 Elite (sm8850 / sun)
# Source : Extracted from working TWRP 3.7.1_16 ramdisk + log analysis
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

# ─────────────────────────────────────────────────────────
# Build flags
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
TARGET_ARCH         := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI      := arm64-v8a
TARGET_CPU_ABI2     :=
TARGET_CPU_VARIANT  := generic
TARGET_CPU_VARIANT_RUNTIME := oryon

ENABLE_CPUSETS   := true
ENABLE_SCHEDBOOST := true

# ─────────────────────────────────────────────────────────
# Platform — sm8850 (Snapdragon 8 Elite)
# Confirmed: ro.board.platform=xiaomi_sm8850, ro.product.board=sun
# ─────────────────────────────────────────────────────────
PRODUCT_PLATFORM      := sun
TARGET_BOARD_PLATFORM := sm8850
TARGET_BOARD_PLATFORM_GPU := qcom-adreno840
QCOM_BOARD_PLATFORMS  += sm8850

# ─────────────────────────────────────────────────────────
# Bootloader
# ─────────────────────────────────────────────────────────
TARGET_BOOTLOADER_BOARD_NAME := myron
TARGET_NO_BOOTLOADER         := true

# ─────────────────────────────────────────────────────────
# Kernel — prebuilt (boot header v4, page_size=4096, LZ4)
# Confirmed from TWRP ramdisk analysis
# ─────────────────────────────────────────────────────────
TARGET_KERNEL_ARCH        := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME   := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE     := 4096
BOARD_MKBOOTIMG_ARGS      += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS      += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_RAMDISK_USE_LZ4     := true

TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
endif

# Recovery image has its own kernel (NOT ramdisk-in-vendor_boot)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := false

# ─────────────────────────────────────────────────────────
# A/B — device has dedicated recovery partition (slotted)
# Confirmed: /dev/block/bootdevice/by-name/recovery_a in log
# ro.boot.slot_suffix=_a, ro.boot.dynamic_partitions=true
# ro.virtual_ab.enabled=true
# ─────────────────────────────────────────────────────────
AB_OTA_UPDATER   := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    recovery \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm

# Device has dedicated recovery partition — NOT recovery-as-boot
BOARD_USES_RECOVERY_AS_BOOT              := false
# Do NOT set BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT for this device
BOARD_RECOVERY_NEEDS_BOOTLOADER_CONTROL  := true

# ─────────────────────────────────────────────────────────
# Partitions
# Confirmed from TWRP log partition table
# /boot    96MB  = 100663296
# /recovery 100MB = 104857600
# ─────────────────────────────────────────────────────────
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_BOOTIMAGE_PARTITION_SIZE         := 100663296    # 96MB confirmed from log
BOARD_RECOVERYIMAGE_PARTITION_SIZE     := 104857600    # 100MB confirmed from log

BOARD_HAS_LARGE_FILESYSTEM       := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4       := true
TARGET_USERIMAGES_USE_F2FS       := true

# Dynamic partitions
# Note: verify BOARD_SUPER_PARTITION_SIZE against your device with:
#   adb shell cat /proc/partitions | grep super
BOARD_SUPER_PARTITION_SIZE := 11274289152
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions

# CONFIRMED from TWRP log: dm-0..dm-7 = mi_ext,odm,product,system,system_dlkm,system_ext,vendor,vendor_dlkm
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    system_dlkm \
    product \
    vendor \
    vendor_dlkm \
    odm \
    mi_ext

BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 11270094848

# EROFS — confirmed from TWRP log (all super partitions = erofs)
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
# Confirmed: FBE v2, keymint-strongbox, weaver-service
# fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0
# keydirectory=/metadata/vold/metadata_encryption
# metadata_encryption=aes-256-xts:wrappedkey_v0
# ─────────────────────────────────────────────────────────
BOARD_USES_METADATA_PARTITION    := true
BOARD_USES_QCOM_FBE_DECRYPTION   := true
TW_INCLUDE_CRYPTO                := true
TW_INCLUDE_CRYPTO_FBE            := true
TW_INCLUDE_FBE_METADATA_DECRYPT  := true
TW_USE_FSCRYPT_POLICY            := 2

# ─────────────────────────────────────────────────────────
# Recovery
# ─────────────────────────────────────────────────────────
TARGET_RECOVERY_PIXEL_FORMAT  := RGBX_8888
TARGET_RECOVERY_QCOM_RTC_FIX  := true
TW_INCLUDE_FASTBOOTD          := true
TW_SKIP_ADDITIONAL_FSTAB      := true

# ─────────────────────────────────────────────────────────
# Display
# Confirmed from TWRP log: width=1200, height=2608
# Brightness path confirmed: /sys/class/backlight/panel0-backlight/brightness
# ─────────────────────────────────────────────────────────
TARGET_USES_VULKAN      := true
TW_THEME                := portrait_hdpi
TARGET_SCREEN_WIDTH     := 1200
TARGET_SCREEN_HEIGHT    := 2608
TW_FRAMERATE            := 120
TW_BRIGHTNESS_PATH      := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS   := 1200
TW_MAX_BRIGHTNESS       := 4094
TW_NO_SCREEN_BLANK      := true
TW_SCREEN_BLANK_ON_BOOT := true

# ─────────────────────────────────────────────────────────
# File system / Storage
# ─────────────────────────────────────────────────────────
RECOVERY_SDCARD_ON_DATA   := true
TARGET_USES_MKE2FS        := true
TW_ENABLE_FS_COMPRESSION  := true
TW_INCLUDE_FUSE_EXFAT     := true
TW_INCLUDE_FUSE_NTFS      := true
TW_INCLUDE_NTFS_3G        := true
TW_NO_EXFAT_FUSE          := true

# ─────────────────────────────────────────────────────────
# Tools
# ─────────────────────────────────────────────────────────
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPDUMP       := true
TW_INCLUDE_LPTOOLS      := true
TW_INCLUDE_REPACKTOOLS  := true
TW_INCLUDE_RESETPROP    := true
TW_USE_TOOLBOX          := true

# ─────────────────────────────────────────────────────────
# Debug
# ─────────────────────────────────────────────────────────
TARGET_USES_LOGD         := true
TWRP_INCLUDE_LOGCAT      := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# ─────────────────────────────────────────────────────────
# Vendor modules
# CORRECTED: focaltech_touch_3683.ko (confirmed from TWRP log)
# NOT oplus_bsp_tp_* (those don't exist on this device)
# ─────────────────────────────────────────────────────────
TW_LOAD_VENDOR_MODULES := "focaltech_touch_3683.ko adsp_loader_dlkm.ko q6_dlkm.ko q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko gpr_dlkm.ko spf_core_dlkm.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# ─────────────────────────────────────────────────────────
# Vibrator AIDL (required for SD8 Elite)
# Confirmed: vendor.xiaomi.hardware.vibratorfeature.service in odm
# ─────────────────────────────────────────────────────────
TW_SUPPORT_INPUT_AIDL_HAPTICS := true

# ─────────────────────────────────────────────────────────
# Misc TWRP
# ─────────────────────────────────────────────────────────
TW_EXTRA_LANGUAGES    := true
TW_DEFAULT_LANGUAGE   := en
TW_INPUT_BLACKLIST    := "hbtp_vm"
TW_EXCLUDE_APEX       := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone45/temp"
TW_DEVICE_VERSION     := POCO_F8_ULTRA

# ─────────────────────────────────────────────────────────
# Security patch — bypass anti-rollback
# Confirmed from TWRP prop.default: 2099-12-31
# ─────────────────────────────────────────────────────────
PLATFORM_VERSION            := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH     := 2099-12-31
VENDOR_SECURITY_PATCH       := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH         := $(PLATFORM_SECURITY_PATCH)
