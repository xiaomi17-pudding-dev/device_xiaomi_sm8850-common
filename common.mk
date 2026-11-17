#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Qualcomm common product configuration (remote file system links for the modem and DSPs,
# vendor linker configuration) of hardware/qcom-caf; ROMs with their own Qualcomm common
# layer do not ship it
$(call inherit-product-if-exists, hardware/qcom-caf/common/common.mk)

PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# AVF: the virtualization service (com.android.virt with early_virtmgr). The stock
# AvfQcvmManager starts the trusted VMs (ro.vendor.qtvm.auto.start) through it.
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# AVF: pvmfw (stock vbmeta holds its hash descriptor)
PRODUCT_BUILD_PVMFW_IMAGE := true

# API levels
BOARD_SHIPPING_API_LEVEL := 202504
PRODUCT_SHIPPING_API_LEVEL := 36

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Kernel
PRODUCT_ENABLE_UFFD_GC := true

# Mount points of the firmware partitions in the stock fstab (vendor is read-only, so the
# directories must exist in the image); the modem's rfs link points at modem_firmware as on stock
$(call soong_config_set,rfs,mpss_firmware_symlink_target,modem_firmware)

PRODUCT_PACKAGES += \
    product_vm-system_mountpoint \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint \
    vendor_modemfirmware_mountpoint \
    vendor_soccp_firmware_mountpoint \
    vendor_vm-system_mountpoint

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    NcmTetheringOverlay \
    NfcResCommon \
    SecureElementResCommon \
    TelecomResCommon \
    TelephonyResCommon \
    WifiResCommon

# Parts: colour modes, touch polling rate and orientation, thermal profile tile, through the
# stock displayfeature and touchfeature services
PRODUCT_PACKAGES += \
    XiaomiParts

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Platform: also needed by product configuration (e.g. a QCOM common product layer)
TARGET_BOARD_PLATFORM := canoe

# Product characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Rootdir
PRODUCT_PACKAGES += \
    coresight_reset_source_sink.sh \
    exec-debug-diag.sh \
    flash.sh \
    flash_before.sh \
    init.class_main.sh \
    init.crda.sh \
    init.kernel.extra_free_kbytes.sh \
    init.kernel.init_boot-memory.sh \
    init.kernel.post_boot-alor.sh \
    init.kernel.post_boot-alor_5_1.sh \
    init.kernel.post_boot-alor_5_2.sh \
    init.kernel.post_boot-alor_6_1.sh \
    init.kernel.post_boot-alor_default_6_2.sh \
    init.kernel.post_boot-canoe.sh \
    init.kernel.post_boot-canoe_5_1.sh \
    init.kernel.post_boot-canoe_5_2.sh \
    init.kernel.post_boot-canoe_6_1.sh \
    init.kernel.post_boot-canoe_default_6_2.sh \
    init.kernel.post_boot-memory.sh \
    init.kernel.post_boot.sh \
    init.mdm.sh \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.early_boot.sh \
    init.qcom.efs.sync.sh \
    init.qcom.post_boot.sh \
    init.qcom.sdio.sh \
    init.qcom.sensors.sh \
    init.qcom.sh \
    init.qcom.usb.sh \
    init.qcrild.sh \
    init.qti.ese.strongbox.sh \
    init.qti.kernel.debug-alor.sh \
    init.qti.kernel.debug-canoe.sh \
    init.qti.kernel.debug.sh \
    init.qti.kernel.early_debug-canoe.sh \
    init.qti.kernel.early_debug.sh \
    init.qti.kernel.sh \
    init.qti.keymaster.sh \
    init.qti.media.sh \
    init.qti.qcv.sh \
    init.qti.write.sh \
    init.xiaomi.modem.cust.sh \
    init.xiaomi.modem.sh \
    qca6234-service.sh \
    start_subsys.sh \
    system_dlkm_modprobe.sh \
    ufs_ffu.sh \
    vendor.qti.diag.sh \
    vendor_modprobe.sh

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.batterysecret.rc \
    init.mi_ambient.rc \
    init.mi_thermald.rc \
    init.qcom.factory.rc \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.qti.kernel.rc \
    init.qti.kernel.target.rc \
    init.qti.ufs.rc \
    init.target.rc \
    init.recovery.hardware.rc \
    init.recovery.qcom.rc \
    miui.factoryreset.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/xiaomi \
    vendor/qcom/opensource/usb/etc

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/sm8850-common/sm8850-common-vendor.mk)

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    hostapd_cli \
    libwifi-hal \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_cli \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# HALs built from source (stock binaries share these module names)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider-V1-external-service \
    android.hardware.drm-service-lazy.clearkey \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery \
    android.hardware.sensors-service.multihal \
    android.hardware.usb-service.qti \
    android.hardware.usb.gadget-service.qti \
    sensors.dynamic_sensor_hal \
    sensors.xiaomi.v2 \
    usb_compositions.conf \
    vendor.qti.hardware.memtrack-service \
    vendor.qti.qspa-service

# Audio: the stock AudioReach stack ships as blobs (see proprietary-files.txt); only
# ABI-neutral parts are built from source, as in other LineageOS Xiaomi SM8850 trees.
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default \
    audioeffectservice_qti.xml \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libaudiohalvendorextn \
    libpaleventnotifier \
    libpalipcservice \
    libsndcardparser \
    manifest_audiocorehal_default.xml \
    qtiaudiohalvendorextn

PRODUCT_PACKAGES += \
    libbundleaidl \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libloudnessenhanceraidl \
    libreverbaidl \
    libvisualizeraidl

# Fingerprint: the hardware/xiaomi AIDL service loads the stock Xiaomi HAL module (V2 ABI)
# in-process and forwards the framework's under-display touches through libudfpshandler.
# The stock mfp-daemon waits for HyperOS's SystemUI to signal those touches instead.
$(call soong_config_set,XIAOMI_BIOMETRICS_FINGERPRINT,IMPL_VER,V2)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi \
    libudfpshandler

# IPA: ipacm and its configs built from hardware/qcom-caf/sm8850/data-ipa-cfg-mgr
# (configs identical to stock)
PRODUCT_PACKAGES += \
    ipacm \
    IPACM_Filter_cfg.xml \
    IPACM_cfg.xml

# Power: QTI power HAL built from vendor/qcom/opensource/power; it uses the stock
# powerhint.xml and perf HAL (vendor.qti.hardware.perf2). The device mode hook switches the
# touch controller's double tap to wake and screen-off fingerprint detection.
PRODUCT_PACKAGES += \
    android.hardware.power-service-qti

$(call soong_config_set,qtipower,mode_ext_lib,//$(LOCAL_PATH):libpowermode-ext-xiaomi)

# Sensors: the Xiaomi sub-HAL adds the UDFPS long press sensor next to the stock sub-HALs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_ODM)/etc/sensors/hals.conf

# Stock symlinks that point outside the vendor image
PRODUCT_PACKAGES += \
    firmware_wlan_kiwi_v2_wlan_mac.bin_symlink \
    firmware_wlan_peach_v2_wlan_mac.bin_symlink \
    firmware_wlan_wcn7750_wlan_mac.bin_symlink \
    firmware_wlanmdsp.otaupdate_symlink \
    rfs_msm_mpss_readonly_mbnconfig_symlink

# Vendor binder: Android 17 only adds vndservicemanager for shipping API level 29 or lower,
# but the stock vendor services (OS3.0.335.0.XPCEUXM) use /dev/vndbinder
PRODUCT_PACKAGES += \
    vndservicemanager

# Telephony: Qualcomm telephony framework built from vendor/codeaurora/telephony; the stock
# IMS apps in system_ext use it
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# The stock IMS apps call android.telephony.TelephonyBaseUtilsStub.isMiuiRom()
PRODUCT_PACKAGES += \
    xiaomi-telephony-stub

PRODUCT_BOOT_JARS += \
    xiaomi-telephony-stub

# Thermal: QTI thermal HAL built from hardware/qcom-caf/thermal; stock thermal configs stay
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# Vendor variants of the libraries that stock vendor and odm blobs link. Blobs with
# DISABLE_DEPS only list them in REQUIRED, which installs the system variant, and the
# vendor linker namespace cannot load those.
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice-V1-ndk.vendor \
    android.hardware.audio.core-V2-ndk.vendor \
    android.hardware.audio.core-V3-ndk.vendor \
    android.hardware.audio.core.sounddose-V1-ndk.vendor \
    android.hardware.audio.core.sounddose-V3-ndk.vendor \
    android.hardware.audio.effect-V3-ndk.vendor \
    android.hardware.biometrics.common-V4-ndk.vendor \
    android.hardware.bluetooth.audio-V5-ndk.vendor \
    android.hardware.camera.common-V1-ndk.vendor \
    android.hardware.common-V2-ndk.vendor \
    android.hardware.contexthub-V3-ndk.vendor \
    android.hardware.drm-V1-ndk.vendor \
    android.hardware.graphics.composer3-V4-ndk.vendor \
    android.hardware.health-V1-ndk.vendor \
    android.hardware.health@2.0.vendor \
    android.hardware.health@2.1.vendor \
    android.hardware.media.c2-V1-ndk.vendor \
    android.hardware.media.c2-V2-ndk.vendor \
    android.hardware.media.c2@1.0.vendor \
    android.hardware.media.c2@1.1.vendor \
    android.hardware.media.c2@1.2.vendor \
    android.hardware.nfc-V1-ndk.vendor \
    android.hardware.power@1.2.vendor \
    android.hardware.radio-V4-ndk.vendor \
    android.hardware.radio-V5-ndk.vendor \
    android.hardware.radio.config-V4-ndk.vendor \
    android.hardware.radio.data-V4-ndk.vendor \
    android.hardware.radio.messaging-V4-ndk.vendor \
    android.hardware.radio.modem-V4-ndk.vendor \
    android.hardware.radio.network-V4-ndk.vendor \
    android.hardware.radio.sim-V4-ndk.vendor \
    android.hardware.radio.voice-V4-ndk.vendor \
    android.hardware.secure_element-V1-ndk.vendor \
    android.hardware.security.rkp-V3-ndk.vendor \
    android.hardware.security.secureclock-V1-ndk.vendor \
    android.hardware.security.sharedsecret-V1-ndk.vendor \
    android.hardware.sensors-V3-ndk.vendor \
    android.hardware.thermal-V1-ndk.vendor \
    android.hardware.thermal@2.0.vendor \
    android.hardware.wifi-V3-ndk.vendor \
    android.media.audio.common.types-V4-ndk.vendor \
    libalsautilsv2.vendor \
    libcodec2_aidl.vendor \
    libcodec2_aidl_noisurface.vendor \
    libcodec2_hidl@1.0.vendor \
    libcodec2_hidl@1.1.vendor \
    libcodec2_hidl@1.2.vendor \
    libmediautils_vendor.vendor \
    libmemunreachable.vendor \
    libtinyalsav2.vendor \
    qti-audio-types-aidl-V1-ndk.vendor \
    vendor.qti.hardware.agm-V1-ndk \
    vendor.qti.hardware.bluetooth.audio-V1-ndk.vendor \
    vendor.qti.hardware.display.aiqe-V3-ndk.vendor \
    vendor.qti.hardware.display.color-V1-ndk.vendor \
    vendor.qti.hardware.display.composer3-V4-ndk.vendor \
    vendor.qti.hardware.display.config-V13-ndk.vendor \
    vendor.qti.hardware.display.config-V18-ndk.vendor \
    vendor.qti.hardware.display.postproc-V1-ndk.vendor \
    vendor.qti.hardware.pal-V1-ndk \
    vendor.qti.hardware.servicetracker@1.0.vendor \
    vendor.qti.hardware.servicetracker@1.1.vendor \
    vendor.qti.hardware.systemhelper@1.0.vendor \
    vendor.qti.hardware.systemhelperaidl-V2-ndk.vendor
