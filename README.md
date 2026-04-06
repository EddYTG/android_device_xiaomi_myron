# OrangeFox Recovery — Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)

## Device specs
| Item | Value |
|---|---|
| SoC | Snapdragon 8 Elite Gen 5 (SM8850 / sun) |
| CPU | Oryon (8 cores) |
| RAM | 12/16 GB |
| Storage | 256/512 GB UFS 4.0 |
| Display | 1200×2608, 120Hz OLED |
| Kernel | GKI 6.12 (Android 16) |
| A/B | Virtual A/B + dedicated recovery partition |
| Encryption | FBE (aes-256-xts + wrappedkey_v0) |
| KeyMint | TEE (vendor.keymint-qti) + Strongbox (Thales JavaCard via se_omapi) |
| Haptics | PMIC HV haptics (qcom-hv-haptics revision 5) |

## Build
```bash
source build/envsetup.sh
lunch twrp_myron-eng
mka recoveryimage
```

## Changelog (R11.3_260406 → FIXED)

### 🔴 Critical fixes (confirmed từ logcat/dmesg)

**[FIX-1] VINTF keymint conflict — root cause của cascade failure**
- `vendor/etc/vintf/manifest.xml`: xóa `IKeyMintDevice/default` duplicate
- `manifest.xml` chính + subfolder `manifest/*.xml` khai báo cùng HAL
  → `hwservicemanager` trả về -2147483648 → TẤT CẢ service fail cascade
- Fix: manifest.xml chỉ giữ `keymaster@4.1` HIDL (OFox parser) + gatekeeper + secure_element
- Subfolder `manifest/android.hardware.security.keymint-service-qti.xml` tự merge

**[FIX-2] Pin 100% (consequence của FIX-1)**
- Health AIDL service không đăng ký được do VINTF poisoned
- Sau FIX-1: `android.hardware.health-service.qti.xml` được merge → health OK
- Thêm `interface aidl IHealth/default` vào `health-service.qti.rc`

**[FIX-3] Weaver linker fail: ese_weaver.so not found**
- Pre-bake lib aliases vào ramdisk `/odm/lib64/`:
  - `ese_weaver.so` ← copy của `ese_weaver_thales.so`
  - `libjc_keymint3.nxp.so` ← copy của `libjc_keymint-thales.so`
  - `libjc_keymint_transport_nxp.so` ← copy của `libjc_keymint_transport-thales.so`
  - `lib_android_keymaster_keymint_utils_V3.so` ← copy từ `vendor/lib64/`

**[FIX-4] KeyMint-strongbox race condition**
- Thêm `disabled` vào `keymint-strongbox.rc` và `weaver-service.rc`
- Cả hai service giờ chỉ start khi được gọi tường minh (`twrp.variant.files_copied=1`)
- Thêm `interface aidl` declarations cho cả hai

**[FIX-5] Boot HAL fail STATUS=-3**
- Consequence của FIX-1 (VINTF unblocked)
- Thêm `interface aidl IBootControl/default` vào `boot-service.qti.rc`

**[FIX-6] secure_element crash loop "Unknown eSE HW"**
- `vendor.secure_element` không nhận ra Thales JavaCard trên myron
- Xóa `on init → start vendor.secure_element` để tránh crash loop
- `se_omapi` tự kết nối eSE trực tiếp (không cần vendor bridge)

**[FIX-7] Manifest fragment version conflict**
- Tất cả subfolder `*.xml` dùng `version="8.0"` → normalize về `"2.0"`
- `version="8.0"` không hợp lệ trong AOSP libvintf manifest schema

**[FIX-8] ld.config.txt path sai**
- `init.recovery.ldconfig.rc`: sửa path `/system/etc/ld.config.txt` → `/ld.config.txt`
- `/odm/lib64` đặt đầu search path trong tất cả linker namespace

**[FIX-9] se_omapi RC: thêm disabled + interface**
- `se_omapi.rc`: thêm `disabled`, start từ `twrp.variant.files_copied=1` trong `qcom.rc`

**[FIX-10] Vibrator: onrestart tên service sai**
- `vibratorfeature.service.rc`: `restart vibratorfeature` → `restart odm.vibratorfeature-service`
- Sửa persist path: `/mnt/vendor/persist/haptics` → `/persist/haptics`

### 🟡 Non-critical fixes

**[FIX-11] vendor.keymint-qti start timing**
- Xóa `on init → start vendor.keymint-qti` (quá sớm)
- Thay bằng `on property:init.svc.vendor.qseecomd=running`

**[FIX-12] Resolution**
- Log xác nhận: 1200×2608 là ĐÚNG
- `OF_SCREEN_H=2608`, `OF_STATUS_H=111` giữ nguyên
- `Scaling 1.111x` là expected behavior (OFox tự scale từ base 1080)

**[FIX-13] indeterminate033 missing**
- Bug trong OFox R11.3 theme source (không phải device tree)
- Không fix được ở device tree level

## Maintainer
Antuna — Unofficial build
