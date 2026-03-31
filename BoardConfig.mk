#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device : Xiaomi POCO F8 Ultra / Redmi K90 Pro Max (myron)
# SoC    : Snapdragon 8 Elite (sm8850 / sun)
#
# ═══════════════════════════════════════════════════════════
# VERIFIED 100% FROM TWRP 3.7.1_16 RAMDISK BYTE-BY-BYTE
# ═══════════════════════════════════════════════════════════
#
# Image analysis:
#   magic        = ANDROID!
#   header_size  = 1584  → boot header v4
#   kernel_size  = 0     → NO kernel in image (GKI style)
#   ramdisk_size = 68608201 bytes (65.4 MB), LZ4 legacy
#   os_version   = 99.87.36
#   patch_level  = 2099-12
#   image_size   = 104857600 bytes = 100 MB exactly
#   AVB footer   : present, algorithm=NONE, unsigned
#   Ramdisk at   : page offset 4096 (standard recovery layout)
#
# prop.default analysis:
#   ro.board.platform         = xiaomi_sm8850
#   ro.product.board          = sun
#   ro.virtual_ab.enabled     = true
#   ro.virtual_ab.compression.enabled = true
#   ro.product.first_api_level = 35
#   ro.board.first_api_level  = 35
#   ro.board.api_level        = 202504
#   ro.build.ab_update        = true
#   AB_OTA list: boot,dtbo,init_boot,odm,product,system,
#                system_dlkm,system_ext,vbmeta,vbmeta_system,
#                vendor,vendor_boot,vendor_dlkm
#                → "recovery" NOT in list → DEDICATED partition
#
# twrp.flags confirmation:
#   /recovery emmc /dev/block/bootdevice/by-name/recovery
#   → BOARD_USES_RECOVERY_AS_BOOT := false  ← THIS WAS THE BOOTLOOP BUG
#   → BUILD_TARGET must be: recoveryimage
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
# Architecture
# Confirmed: ro.bionic.arch=arm64, cpu_variant=generic
# Runtime: oryon (SD8 Elite)
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
# ro.board.platform=xiaomi_sm8850, ro.product.board=sun
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
# Kernel (prebuilt)
# Confirmed: boot header v4, page_size=4096, LZ4 ramdisk
# kernel_size=0 → BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE=true
# Kernel lives in vendor_boot, not in recovery.img
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

# Confirmed: kernel_size=0 in actual image → recovery.img has no kernel
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# ─────────────────────────────────────────────────────────
# A/B + DEDICATED RECOVERY PARTITION
#
# ╔══════════════════════════════════════════════════════╗
# ║  ROOT CAUSE OF PREVIOUS BOOTLOOP:                    ║
# ║  Old tree: BOARD_USES_RECOVERY_AS_BOOT := true       ║
# ║  → build merges recovery into boot.img               ║
# ║  → flashing to /boot, but device reads from /recovery║
# ║  → BOOTLOOP                                          ║
# ║                                                      ║
# ║  PROOF from ramdisk:                                 ║
# ║  1. twrp.flags: /recovery emmc .../by-name/recovery  ║
# ║  2. AB_OTA list does NOT include "recovery"          ║
# ║  3. Image is 100MB = BOARD_RECOVERYIMAGE_PARTITION   ║
# ║  4. This is a dedicated recovery partition device    ║
# ╚══════════════════════════════════════════════════════╝
#
# AB_OTA_PARTITIONS from prop.default (exact):
# boot,dtbo,init_boot,odm,product,system,system_dlkm,
# system_ext,vbmeta,vbmeta_system,vendor,vendor_boot,
# vendor_dlkm  ← "recovery" is NOT here
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

# CRITICAL FIX — was "true" before, caused bootloop
BOARD_USES_RECOVERY_AS_BOOT             := false
BOARD_RECOVERY_NEEDS_BOOTLOADER_CONTROL := true
# DO NOT set BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT

# ─────────────────────────────────────────────────────────
# Partitions
# Confirmed: image = 100MB = 104857600 bytes exactly
# ─────────────────────────────────────────────────────────
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_BOOTIMAGE_PARTITION_SIZE         := 100663296
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE   := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE  := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE     := 104857600

BOARD_HAS_LARGE_FILESYSTEM       := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4       := true
TARGET_USERIMAGES_USE_F2FS       := true

# Dynamic partitions
# Confirmed: ro.boot.dynamic_partitions=true
BOARD_SUPER_PARTITION_SIZE := 14495514624
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions

# Partition list from prop.default AB list (minus system_dlkm which is in twrp.flags)
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    odm

BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 14491320320

# All dynamic partitions use erofs (confirmed from recovery.fstab in ramdisk)
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower,$(p))))

# ─────────────────────────────────────────────────────────
# AVB
# Confirmed from AVB footer analysis:
#   magic=AVBf, version=1.0
#   algorithm_type=0 (NONE), auth_block_size=0 (unsigned)
#   flags=0x00000000
# ─────────────────────────────────────────────────────────
BOARD_AVB_ENABLE                           := true
BOARD_AVB_ALGORITHM                        := NONE
BOARD_AVB_RECOVERY_ALGORITHM               := NONE
BOARD_AVB_RECOVERY_ROLLBACK_INDEX          := 0
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 0

# ─────────────────────────────────────────────────────────
# Crypto / FBE
# Confirmed from recovery.fstab in ramdisk (exact):
#   fileencryption=aes-256-xts:aes-256-cts:
#                  v2+inlinecrypt_optimized+wrappedkey_v0
#   keydirectory=/metadata/vold/metadata_encryption
#   metadata_encryption=aes-256-xts:wrappedkey_v0
#
# Services confirmed from odm ramdisk:
#   - android.hardware.security.keymint-service.strongbox
#     (Thales/NXP StrongBox Keymint v3)
#   - android.hardware.weaver-service
#   - ese_weaver_thales.so, libjc_keymint-thales.so
#   - prepdecrypt.sh present and active
#   - odm.prepdecrypt starts on ro.crypto.state=encrypted
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
TARGET_RECOVERY_FSTAB         := $(DEVICE_PATH)/recovery/root/recovery.fstab
TW_INCLUDE_FASTBOOTD          := true
TW_SKIP_ADDITIONAL_FSTAB      := true
# API 35 (ro.product.first_api_level=35) cần flag này
TW_NO_LEGACY_PROPS            := true

# ─────────────────────────────────────────────────────────
# Display
# Confirmed from portrait.xml + prop.default:
#   ro.minui.pixel_format=RGBX_8888
#   Screen: 1200x2608
#   Brightness: /sys/class/backlight/panel0-backlight/brightness
# y_offset/h_offset from variant-script.sh:
#   ro.twrp.y_offset=111, ro.twrp.h_offset=-111
# ─────────────────────────────────────────────────────────
TARGET_USES_VULKAN       := true
TW_THEME                 := portrait_hdpi
TARGET_SCREEN_WIDTH      := 1200
TARGET_SCREEN_HEIGHT     := 2608
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
# Confirmed from ramdisk init.recovery.qcom.rc:
#   - Touch: focaltech_touch_3683.ko (firmware in odm/variant/myron)
#   - ADSP: adsp_loader_dlkm.ko, q6*.ko, snd_event_dlkm.ko etc.
#   - WiFi modules loaded separately via cp-wifi-ko.sh
#     (cnss_prealloc, cnss2, cfg80211, etc. — NOT via TW_LOAD_VENDOR_MODULES)
# ─────────────────────────────────────────────────────────
TW_LOAD_VENDOR_MODULES := "focaltech_touch_3683.ko adsp_loader_dlkm.ko q6_dlkm.ko q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko gpr_dlkm.ko spf_core_dlkm.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# ─────────────────────────────────────────────────────────
# Vibrator
# Confirmed from odm/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service
# variant-script.sh: sys_path=/sys/class/qcom-haptics, device_type=agm
# cs40l26 firmware present in ramdisk lib/firmware/
# ─────────────────────────────────────────────────────────
TW_SUPPORT_INPUT_AIDL_HAPTICS                      := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FW_COMPOSER          := false
TW_SUPPORT_INPUT_AIDL_HAPTICS_INSTALL_LEGACY_CHECK := false

# ─────────────────────────────────────────────────────────
# Misc
# Confirmed from variant-script.sh:
#   ro.twrp.device_version=POCO_F8_ULTRA
# ro.boot.hardware.sku: myron detection
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
# Security patch bypass
# Confirmed from prop.default (exact values):
#   ro.build.version.release=99.87.36
#   ro.build.version.security_patch=2099-12-31
#   ro.vendor.build.security_patch=2099-12-31
# ─────────────────────────────────────────────────────────
PLATFORM_VERSION             := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH      := 2099-12-31
VENDOR_SECURITY_PATCH        := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH          := $(PLATFORM_SECURITY_PATCH)
