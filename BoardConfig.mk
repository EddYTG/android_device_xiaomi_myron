#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device : Xiaomi POCO F8 Ultra / Redmi K90 Pro Max (myron)
# SoC    : Snapdragon 8 Elite Gen 5 (SM8850 / sun)
# Branch : OrangeFox 14.1 (Android 16 / SDK 36)
#
# Confirmed from: TWRP 3.7.1_16 ramdisk + fastboot getvar all
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

# ─────────────────────────────────────────────────────────
# Build rules
# ─────────────────────────────────────────────────────────
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# ─────────────────────────────────────────────────────────
# Architecture — Oryon CPU (Snapdragon 8 Elite Gen 5)
# ─────────────────────────────────────────────────────────
TARGET_ARCH             := arm64
TARGET_ARCH_VARIANT     := armv8-a
TARGET_CPU_ABI          := arm64-v8a
TARGET_CPU_ABI2         :=
TARGET_CPU_VARIANT      := generic
TARGET_CPU_VARIANT_RUNTIME := oryon

ENABLE_CPUSETS    := true
ENABLE_SCHEDBOOST := true

# ─────────────────────────────────────────────────────────
# Platform
# Confirmed: ro.board.platform=xiaomi_sm8850, ro.product.board=sun
# ─────────────────────────────────────────────────────────
PRODUCT_PLATFORM      := sun
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_PLATFORM)
TARGET_NO_BOOTLOADER  := true
TARGET_USES_UEFI      := true

TARGET_BOARD_PLATFORM := xiaomi_sm8850
TARGET_BOARD_PLATFORM_GPU := qcom-adreno840
QCOM_BOARD_PLATFORMS  += xiaomi_sm8850

# ─────────────────────────────────────────────────────────
# Kernel — prebuilt GKI, boot header v4, vendor_boot style
# Confirmed: kernel_size=0 in boot img, kernel in vendor_boot
# ─────────────────────────────────────────────────────────
TARGET_KERNEL_ARCH        := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME   := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE     := 4096
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_PREBUILT_KERNEL    := $(DEVICE_PATH)/prebuilt/kernel
BOARD_MKBOOTIMG_ARGS      += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS      += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_RAMDISK_USE_LZ4     := true

# Kernel lives in vendor_boot — do NOT embed in recovery.img
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# ─────────────────────────────────────────────────────────
# A/B — device has DEDICATED recovery partition
#
# PROOF:
#   fastboot getvar partition-size:recovery_a = 0x6400000 (100MB)
#   recovery IS in AB_OTA_PARTITIONS but NOT used-as-boot
#   twrp.flags: /recovery emmc /dev/block/.../recovery
# ─────────────────────────────────────────────────────────
AB_OTA_UPDATER   := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm

BOARD_USES_RECOVERY_AS_BOOT             := false
BOARD_RECOVERY_NEEDS_BOOTLOADER_CONTROL := true

# ─────────────────────────────────────────────────────────
# Verified Boot (AVB)
# Confirmed: algorithm=NONE, auth_block_size=0 (unsigned build)
# ─────────────────────────────────────────────────────────
BOARD_AVB_ENABLE                           := true
BOARD_AVB_ALGORITHM                        := NONE
BOARD_AVB_RECOVERY_ALGORITHM               := NONE
BOARD_AVB_RECOVERY_ROLLBACK_INDEX          := 0
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 0

# ─────────────────────────────────────────────────────────
# Partition sizes — ALL confirmed from fastboot getvar all
#   recovery_a : 0x6400000  = 104857600  (100MB)
#   boot_a     : 0x6000000  = 100663296  (96MB)
#   vendor_boot: 0x6000000  = 100663296  (96MB)
#   init_boot  : 0x800000   = 8388608    (8MB)
#   super      : 0x360000000= 14495514624 (13.5GB)
# ─────────────────────────────────────────────────────────
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_BOOTIMAGE_PARTITION_SIZE         := 100663296
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE   := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE  := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE     := 104857600

BOARD_HAS_LARGE_FILESYSTEM         := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4         := true
TARGET_USERIMAGES_USE_F2FS         := true

# ─────────────────────────────────────────────────────────
# Dynamic partitions (super)
# ─────────────────────────────────────────────────────────
BOARD_SUPER_PARTITION_SIZE := 14495514624
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 14491320320
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    odm

# Workaround for vendor copy to recovery ramdisk
TARGET_COPY_OUT_VENDOR     := vendor
TARGET_COPY_OUT_ODM        := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

# EROFS confirmed from recovery.fstab in TWRP ramdisk
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower,$(p))))

# ─────────────────────────────────────────────────────────
# Crypto / FBE
# Confirmed from recovery.fstab:
#   fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0
#   keydirectory=/metadata/vold/metadata_encryption
#   metadata_encryption=aes-256-xts:wrappedkey_v0
# ─────────────────────────────────────────────────────────
BOARD_USES_METADATA_PARTITION    := true
BOARD_USES_QCOM_FBE_DECRYPTION   := true
TW_INCLUDE_CRYPTO                := true
TW_INCLUDE_CRYPTO_FBE            := true
TW_INCLUDE_FBE_METADATA_DECRYPT  := true
TW_USE_FSCRYPT_POLICY            := 2

# Security patch bypass (anti-rollback workaround)
PLATFORM_VERSION             := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH      := 2099-12-31
VENDOR_SECURITY_PATCH        := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH          := $(PLATFORM_SECURITY_PATCH)

# ─────────────────────────────────────────────────────────
# Recovery
# ─────────────────────────────────────────────────────────
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_FSTAB        := $(DEVICE_PATH)/recovery/root/recovery.fstab
TW_INCLUDE_FASTBOOTD         := true
TW_SKIP_ADDITIONAL_FSTAB     := true
TARGET_SYSTEM_PROP           += $(DEVICE_PATH)/system.prop

# ─────────────────────────────────────────────────────────
# Display
# Confirmed: 1200x2608, y_offset=111, h_offset=-111
# (from variant-script.sh in TWRP ramdisk)
# ─────────────────────────────────────────────────────────
TARGET_USES_VULKAN       := true
TW_THEME                 := portrait_hdpi
TW_FRAMERATE             := 120
TW_BRIGHTNESS_PATH       := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS    := 1200
TW_MAX_BRIGHTNESS        := 4094
TW_NO_SCREEN_BLANK       := true
TW_SCREEN_BLANK_ON_BOOT  := true
TW_Y_OFFSET              := 111
TW_H_OFFSET              := -111

# ─────────────────────────────────────────────────────────
# Storage
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
TW_INCLUDE_7ZA          := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPDUMP       := true
TW_INCLUDE_LPTOOLS      := true
TW_INCLUDE_REPACKTOOLS  := true
TW_INCLUDE_RESETPROP    := true
TW_USE_TOOLBOX          := true
TW_ENABLE_ALL_PARTITION_TOOLS := true
TW_USE_DMCTL            := true

# ─────────────────────────────────────────────────────────
# Debug
# ─────────────────────────────────────────────────────────
TARGET_USES_LOGD         := true
TWRP_INCLUDE_LOGCAT      := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# ─────────────────────────────────────────────────────────
# Vendor modules (kernel modules for touch / audio / ADSP)
# Touch: focaltech_touch_3683.ko (FTS touch IC confirmed from ramdisk)
# ─────────────────────────────────────────────────────────
TW_LOAD_VENDOR_MODULES := "focaltech_touch_3683.ko adsp_loader_dlkm.ko q6_dlkm.ko q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko gpr_dlkm.ko spf_core_dlkm.ko rproc_qcom_common.ko qcom_q6v5.ko qcom_q6v5_pas.ko qcom_sysmon.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
TW_LOAD_PREBUILT_MODULES_AT_FIRST  := true

# ─────────────────────────────────────────────────────────
# Vibrator (cs40l26 haptics confirmed from ramdisk init)
# ─────────────────────────────────────────────────────────
TW_SUPPORT_INPUT_AIDL_HAPTICS                      := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME               := "IVibrator/vibratorfeature"
TW_SUPPORT_INPUT_AIDL_HAPTICS_FW_COMPOSER          := false
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF              := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_INSTALL_LEGACY_CHECK := false

# ─────────────────────────────────────────────────────────
# Misc
# ─────────────────────────────────────────────────────────
TW_EXTRA_LANGUAGES    := true
TW_DEFAULT_LANGUAGE   := en
TW_INPUT_BLACKLIST    := "hbtp_vm"
TW_EXCLUDE_APEX       := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_HAS_EDL_MODE       := false
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone45/temp"
TW_BACKUP_EXCLUSIONS  := /data/fonts
TW_DEVICE_VERSION     := POCO_F8_Ultra
BOARD_SYSTEMSDK_VERSIONS := 34
