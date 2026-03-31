#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# OrangeFox branch: 14.1 (Android 16 / SDK 36)
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/omni/config/common.mk)
$(call inherit-product, device/xiaomi/myron/device.mk)

PRODUCT_DEVICE       := myron
PRODUCT_NAME         := omni_myron
PRODUCT_BRAND        := Xiaomi
PRODUCT_MODEL        := POCO F8 Ultra
PRODUCT_MANUFACTURER := Xiaomi

# Fingerprint — from TWRP prop.default
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="myron-user 16 BP2A.250605.031.A2 OS3.0.303.0.WPMCNXM release-keys"

BUILD_FINGERPRINT := Xiaomi/myron/myron:16/BP2A.250605.031.A2/OS3.0.303.0.WPMCNXM:user/release-keys
