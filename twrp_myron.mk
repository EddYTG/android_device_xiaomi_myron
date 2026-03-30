#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi F8U / POCO F8 Ultra / Redmi K90 Pro Max (myron)
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/xiaomi/myron/device.mk)

# Product identity
PRODUCT_DEVICE       := myron
PRODUCT_NAME         := twrp_myron
PRODUCT_BRAND        := Xiaomi
PRODUCT_MODEL        := Xiaomi F8U
PRODUCT_MANUFACTURER := Xiaomi

# Build fingerprint — from working TWRP prop.default
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="myron-user 16 BQ2A.250705.001-BP2A.250605.031.A3 OS3.0.303.0.WPMCNXM release-keys"

BUILD_FINGERPRINT := Redmi/myron/myron:16/BQ2A.250705.001-BP2A.250605.031.A3/OS3.0.303.0.WPMCNXM:user/release-keys
