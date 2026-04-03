#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# Branch: OrangeFox 14.1
# SoC   : Snapdragon 8 Elite Gen 5 (SM8850 / sun)
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/myron

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(DEVICE_PATH)/device.mk)

PRODUCT_DEVICE       := myron
PRODUCT_NAME         := twrp_myron
PRODUCT_BRAND        := Xiaomi
PRODUCT_MODEL        := POCO F8 Ultra
PRODUCT_MANUFACTURER := Xiaomi

# Fingerprint — confirmed from stock ROM getprop:
#   ro.bootimage.build.fingerprint=Redmi/myron/myron:16/BQ2A.250705.001-BP2A.250605.031.A3/OS3.0.303.0.WPMCNXM:user/release-keys
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="myron-user 16 BQ2A.250705.001-BP2A.250605.031.A3 OS3.0.303.0.WPMCNXM release-keys"

BUILD_FINGERPRINT := Redmi/myron/myron:16/BQ2A.250705.001-BP2A.250605.031.A3/OS3.0.303.0.WPMCNXM:user/release-keys

# ─── OrangeFox display (mk-side vars) ─────────────────────────────────────────
# Confirmed: 1200x2608, notch offset 111 (variant-script.sh + bootconfig)
TW_STATUS_ICONS_ALIGN := center
TW_Y_OFFSET           := 111
TW_H_OFFSET           := -111
