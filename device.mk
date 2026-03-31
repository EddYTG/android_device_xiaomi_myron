# Copyright (C) 2026 OrangeFox Recovery Project
# SPDX-License-Identifier: Apache-2.0

LOCAL_PATH := device/xiaomi/myron

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B confirmed
PRODUCT_VIRTUAL_AB_OTA := true

PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

$(call inherit-product, $(LOCAL_PATH)/fox_myron.mk)
