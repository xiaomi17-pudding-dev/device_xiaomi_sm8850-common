#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/xiaomi/sm8850-common',
    'hardware/qcom-caf/sm8850',
    'hardware/qcom-caf/wlan',
    'hardware/xiaomi',
    'vendor/qcom/opensource/dataservices',
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


# Libraries shipped in both vendor and system_ext: the vendor module gets a suffix
lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.diaghal-V1-ndk': lib_fixup_vendor_suffix,
    'vendor.qti.ImsRtpService-V2-ndk': lib_fixup_vendor_suffix,
    'vendor.qti.qccsyshal_aidl-V1-ndk': lib_fixup_vendor_suffix,
}


blob_fixups: blob_fixups_user_type = {
    # The stock fm interface libraries are installed as *_stock.so: some ROMs build libraries with
    # the same names from source
    'vendor/bin/hw/android.hardware.bluetooth@aidl-service-qti': blob_fixup()
        .replace_needed('vendor.qti.hardware.fm-V1-ndk.so', 'vendor.qti.hardware.fm-V1-ndk_stock.so'),
    'vendor/lib64/libbt-hidlclient.so': blob_fixup()
        .replace_needed('vendor.qti.hardware.fm@1.0.so', 'vendor.qti.hardware.fm@1.0_stock.so'),
    # Stock blobs link older versions of stable AIDL interfaces than LineageOS
    # builds; point them at the newest frozen version instead of shipping both.
    'vendor/lib64/libqti-perfd.so': blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V12-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so'),
    (
        'vendor/bin/hw/audiohalservice.qti',
        'vendor/bin/hw/vendor.qti.hardware.display.composer-service',
        'vendor/bin/poweropt-service',
        'vendor/lib64/hw/libaudiocorehal.qti.so',
        'vendor/lib64/hw/libaudioeffecthal.qti.so',
        'vendor/lib64/libaudiocloudctrl.so',
        'vendor/lib64/libdemura_oem_plugin.so',
        'vendor/lib64/liblearningmodule.so',
        'vendor/lib64/libpowercore.so',
        'vendor/lib64/libsdmcore.so',
        'vendor/lib64/libxlog.so',
        'vendor/lib64/soundfx/libquasar.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    # libsdmclient is BOLT-optimized; newer patchelf moves its program
    # headers to a file offset that does not match PT_PHDR, and the linker
    # then finds no PT_DYNAMIC (composer fails to start).
    'vendor/lib64/libsdmclient.so': blob_fixup()
        .patchelf_version('0_9')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    # libcodec2_aidl_noisurface (frameworks/av) uses media.c2 V2; services on
    # libcodec2_aidl stay on V1 like the source library
    'vendor/bin/hw/vendor.qti.media.c2@1.0-service': blob_fixup()
        .replace_needed('android.hardware.media.c2-V1-ndk.so', 'android.hardware.media.c2-V2-ndk.so'),
    (
        'vendor/bin/qguard',
        'vendor/lib64/libqcodec2_utils.so',
        'vendor/lib64/libwfddisplayconfig_vendor.so',
    ): blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V5-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so'),
    'vendor/bin/trusteduilistener': blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V7-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so')
        .replace_needed('vendor.qti.hardware.systemhelperaidl-V1-ndk.so', 'vendor.qti.hardware.systemhelperaidl-V2-ndk.so'),
    (
        'vendor/lib64/libTrustedUIAIDL.so',
        'vendor/lib64/libops.so',
    ): blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V7-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so'),
    (
        'vendor/lib64/libcamerapoweroptfeature.so',
        'vendor/lib64/libgamepoweroptfeature.so',
        'vendor/lib64/liboffscreenpoweroptfeature.so',
        'vendor/lib64/libpsmoptfeature.so',
        'vendor/lib64/libvideooptfeature.so',
    ): blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V5-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/lib64/libdolbyui.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V6-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'vendor/lib64/libqti-qape-engine.so': blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V12-ndk.so', 'vendor.qti.hardware.display.config-V18-ndk.so'),
    # The stock IR service is installed under its own name
    'vendor/etc/init/android.hardware.ir-service.xiaomi.rc': blob_fixup()
        .regex_replace(r'android\.hardware\.ir-service\.example', 'android.hardware.ir-service.xiaomi'),
    # The stock display_boot service runs the renamed stock script
    'vendor/etc/init/init.qti.display_boot_stock.rc': blob_fixup()
        .regex_replace(r'/vendor/bin/init\.qti\.display_boot\.sh', '/vendor/bin/init.qti.display_boot_stock.sh'),
    # Android 17 changed BluetoothAudioSession::IsSessionReady() and dropped
    # audio_utils::mutex_get_enable_flag(); the LineageOS compat shims provide them
    'vendor/lib64/libaudioserviceexampleimpl.so': blob_fixup()
        .add_needed('libaudioutils_shim.so')
        .add_needed('libbluetooth_audio_session_aidl_shim.so'),
    # Bypass fatal NetID check and retry timeout for autonomous IMS PDN
    'vendor/lib64/lib-imsdpl.so': blob_fixup()
        .sig_replace(
            '3f 23 03 d5 ff c3 01 d1 fd 7b 02 a9 fa 67 03 a9 f8 5f 04 a9 f6 57 05 a9 f4 4f 06 a9 fd 83 00 91 55 d0 3b d5',
            '41 00 00 b4 3f 00 00 f9 20 00 80 52 c0 03 5f d6 f8 5f 04 a9 f6 57 05 a9 f4 4f 06 a9 fd 83 00 91 55 d0 3b d5',
        )
        .sig_replace(
            '99 15 00 b4 f7 0b 40 b9',
            'f7 0b 40 b9 59 08 00 b4',
        ),
}  # fmt: skip

module = ExtractUtilsModule(
    'sm8850-common',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
