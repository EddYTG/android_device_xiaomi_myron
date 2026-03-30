LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_DEVICE),myron)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif
