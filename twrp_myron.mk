#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device: Xiaomi myron (sm8850_thales / Snapdragon 8 Elite)
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/omni/config/common.mk)
$(call inherit-product, device/xiaomi/myron/device.mk)

# ─────────────────────────────────────────────────────────
# Product identity
# Confirmed từ prop.default:
# ro.product.system.brand=Xiaomi
# ro.product.system.device=sm8850_thales
# ro.product.system.model=twrp_sm8850_thales
# ─────────────────────────────────────────────────────────
PRODUCT_DEVICE := myron
PRODUCT_NAME := twrp_myron
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 25102RKBEC
PRODUCT_MANUFACTURER := Xiaomi

# ─────────────────────────────────────────────────────────
# Build fingerprint — từ prop.default thực tế
# ro.build.id=BP2A.250605.031.A2
# ─────────────────────────────────────────────────────────
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="myron-user 15 AP3A.250605.031.A2 release-keys"

BUILD_FINGERPRINT := Xiaomi/myron/myron:15/AP3A.250605.031.A2/V999:user/release-keys
