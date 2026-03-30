#
# Copyright (C) 2026 OrangeFox Recovery Project
# Device: Xiaomi myron (sm8850_thales)
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/myron

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B
PRODUCT_VIRTUAL_AB_OTA := true

# LP tools
PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# OFox specifics
$(call inherit-product, $(LOCAL_PATH)/fox_myron.mk)
