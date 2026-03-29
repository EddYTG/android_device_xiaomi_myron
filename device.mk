#
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device: Xiaomi myron (sm8850_thales)
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/myron

# Shipping API level — confirmed: ro.product.first_api_level=35
BOARD_SHIPPING_API_LEVEL := 35
PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_TARGET_VNDK_VERSION := 35

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B — confirmed: ro.virtual_ab.enabled=true
PRODUCT_VIRTUAL_AB_OTA := true

# LP tools
PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# OFox specific
$(call inherit-product, $(LOCAL_PATH)/fox_myron.mk)
