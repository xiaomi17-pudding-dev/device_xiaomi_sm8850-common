#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/xiaomi/sm8850-common

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    dtbo \
    product \
    boot \
    init_boot \
    vendor \
    vendor_boot \
    vendor_dlkm \
    system_dlkm \
    system_ext \
    system \
    recovery \
    odm \
    pvmfw \
    vbmeta \
    vbmeta_system

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := oryon

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := canoe
TARGET_NO_BOOTLOADER := true

# Display
TARGET_USES_VULKAN := true
# The stock composer and its interfaces are composer3 V4 (the source display HAL follows it)
SOONG_CONFIG_qtidisplay_composer_version := v3_4

# Filesystem
TARGET_FS_CONFIG_GEN += $(COMMON_PATH)/config.fs
# The Qualcomm vendor AIDs, unless the ROM's Qualcomm common layer already defines them
ifeq ($(filter device/qcom/common/config.fs,$(TARGET_FS_CONFIG_GEN)),)
TARGET_FS_CONFIG_GEN += $(COMMON_PATH)/config_qcom.fs
endif
# All stock logical partitions are EROFS; userdata is f2fs
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

BOARD_USES_METADATA_PARTITION := true

# Hardware
# Enables the LineageOS Qualcomm integration; canoe is in its UM_6_12 family
# (hardware/qcom-caf/common/qcom_defs.mk), which selects hardware/qcom-caf/sm8850.
BOARD_USES_QCOM_HARDWARE := true

# Build: the stock QTVM proxy client and its Rust libraries (see proprietary-files.txt)
# can only be copied as files
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Kernel
# Stock boot images (OS3.0.335.0.XPCEUXM): header v4, page size 4096, LZ4 (legacy)
# ramdisks; the cmdline below is the stock vendor_boot cmdline (device appends swinfo).
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := video=vfb:640x400,bpp=32,memsize=3072000 erofs.reserved_pages=64
# Stock vendor_boot bootconfig (androidboot.hardware=qcom selects init.qcom.rc and the qcom HALs)
BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    androidboot.load_modules_parallel=true \
    androidboot.hypervisor.protected_vm.supported=true \
    androidboot.hypervisor.version=gunyah \
    androidboot.vendor.qspa=true \
    androidboot.serialconsole=0
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_RAMDISK_USE_LZ4 := true

# Kernel prebuilts (kernel headers, DTB, DTBO, modules) from the device's kernel repo
include $(COMMON_PATH)/kernel/kernel-platform.mk
BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_USES_SYSTEM_DLKMIMAGE := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_PVMFWIMAGE_PARTITION_SIZE := 1048576
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
# Super partition (stock lpdump: 13421772800 bytes; groups qti_dynamic_partitions_a/_b,
# maximum 13411287040 each). mi_ext (Xiaomi-only) is not built.
BOARD_SUPER_PARTITION_SIZE := 13421772800
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 13411287040
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    odm \
    product \
    system \
    system_dlkm \
    system_ext \
    vendor \
    vendor_dlkm

# Platform
TARGET_BOARD_PLATFORM := canoe

# Power: the device mode hook of the QTI power HAL (see power/), for power HALs built with
# Android.mk; the LineageOS one takes it from the qtipower soong config (common.mk)
TARGET_POWERHAL_MODE_EXT := $(COMMON_PATH)/power/power-mode.cpp

# Properties
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor.prop
TARGET_PRODUCT_PROP += $(COMMON_PATH)/product.prop
TARGET_SYSTEM_EXT_PROP += $(COMMON_PATH)/system_ext.prop

# Recovery
# Dedicated A/B recovery partition (stock recovery.img: header v4, ramdisk only)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# RIL: the stock Qualcomm qcrild provides the radio HALs
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level: the boot image carries the stock prebuilt kernel, so it reports the
# stock patch level like the vendor image
BOOT_SECURITY_PATCH := 2026-09-01
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# SEPolicy
include device/qcom/sepolicy_vndr/SEPolicy.mk
# sepolicy/vendor is derived from the stock vendor policy; sepolicy/integration holds the
# rules that stock blobs need on top of it with LineageOS-built services and platform policy
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(COMMON_PATH)/sepolicy/vendor \
    $(COMMON_PATH)/sepolicy/integration

# Verified Boot: the stock layout (OS3.0.335.0.XPCEUXM). vbmeta chains boot (3), recovery (1)
# and vbmeta_system (2: product, system, system_ext) and holds the hashes of the rest;
# boot and vbmeta_system use the security patch date as rollback index, recovery 1.
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_VBMETA_SYSTEM := product system system_ext
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# VINTF
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(wildcard hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml) \
    hardware/xiaomi/vintf/xiaomi_framework_compatibility_matrix.xml \
    $(COMMON_PATH)/device_framework_matrix.xml

# WiFi (built from source like other LineageOS Qualcomm devices). Stock loads all three
# qca_cld3 variants (kiwi_v2, peach_v2, wcn7750) from vendor_dlkm at boot, so the HAL never
# loads a driver module itself and WIFI_DRIVER_DEFAULT is not set.
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_AWARE := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_FEATURE_HOSTAPD_11AX := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Inherit the proprietary files
include vendor/xiaomi/sm8850-common/BoardConfigVendor.mk
