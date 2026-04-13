# Binaries — myron v6 (COMPLETED)

Platform: **SM8850 / canoe** — NXP JavaCard KeyMint v3 + Weaver chain
Status: **Tất cả đã dump và xác nhận từ ROM thực tế**

## Xác nhận từ ROM dump (getprop + ps -A)

| Service | Name trong init | Binary |
|---|---|---|
| QTI KeyMint TEE | `vendor.keymint` | `/vendor/bin/hw/android.hardware.security.onekeymint-service-qti` |
| NXP Strongbox | `vendor.keymint-strongbox` | `/odm/bin/hw/android.hardware.security.keymint3-service.strongbox.nxp` |
| NXP SE HAL | `vendor.secure_element` | `/vendor/bin/hw/android.hardware.secure_element-service.qti` |
| NXP Weaver | `vendor.weaver_nxp` | `/odm/bin/hw/android.hardware.weaver-service.nxp-qti` |
| OMAPI | `com.android.se` (Java) | **KHÔNG có binary native** |

## Libs đã có đủ trong tree

### ODM lib64
- ese_weaver.so
- libjc_keymint3.nxp.so
- libjc_keymint_transport_nxp.so
- libkeymint_empty-nxp.so / libweaver_empty-nxp.so

### Vendor lib64 (từ ROM dump)
- libesesbprovision.so ✓
- libprovisioner_qti.so ✓
- libtrustedapploader.so ✓
- libcpion.so ✓
- libminijail.so ✓
- libavservices_minijail.so ✓
- vendor.xiaomi.hardware.mlipay-V1-ndk.so ✓
- libGPQeSE.so ✓
- libhidlbase.so ✓
- libutils.so ✓
- libcppbor_external.so ✓
- libsoft_attestation_cert.so ✓
- libkeymaster_messages.so ✓
- libkeymaster_portable.so ✓

## KHÔNG có trên ROM myron (đã xóa khỏi tree)
- libjc_weaver_transport.so → NXP tích hợp trong libjc_keymint_transport_nxp.so
- mi_weaver.so → không tồn tại trên canoe
- se_omapi binary → OMAPI = Java app com.android.se
