# Generated from the stock firmware (HyperOS OS3.0.335.0.XPCEUXM): vendor/etc/group and vendor/etc/fs_config_files, limited to shipped files.
# The Qualcomm vendor AIDs and files, as in the Qualcomm common layer of some ROMs.

[AID_VENDOR_QTI_DIAG]
value:2901

[AID_VENDOR_QDSS]
value:2902

[AID_VENDOR_RFS]
value:2903

[AID_VENDOR_RFS_SHARED]
value:2904

[AID_VENDOR_ADPL_ODL]
value:2905

[AID_VENDOR_QRTR]
value:2906

[AID_VENDOR_THERMAL]
value:2907

[AID_VENDOR_FASTRPC]
value:2908

[AID_VENDOR_QTR]
value:2909

[AID_VENDOR_NXP_STRONGBOX]
value:2910

[AID_VENDOR_NXP_WEAVER]
value:2911

[AID_VENDOR_SSGTZD]
value:2912

[AID_VENDOR_THALES_STRONGBOX]
value:2913

[AID_VENDOR_QCC]
value:2914

[AID_VENDOR_NXP_AUTHSECRET]
value:2915

[AID_VENDOR_THALES_WEAVER]
value:2916

[vendor/bin/imsdaemon]
mode: 0755
user: AID_RADIO
group: AID_RADIO
caps: NET_BIND_SERVICE WAKE_ALARM BLOCK_SUSPEND

[vendor/bin/ims_rtp_daemon]
mode: 0755
user: AID_RADIO
group: AID_RADIO
caps: NET_BIND_SERVICE
