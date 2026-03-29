# 🦊 OrangeFox Recovery — Xiaomi myron (K90 Pro Max)

> Device tree cho **Xiaomi myron** chạy **Snapdragon 8 Elite (sm8850)**  
> Phân tích từ recovery.img thực tế — ramdisk boot header v4, LZ4 legacy

---

## Thông tin device

| | |
|---|---|
| Tên máy | Xiaomi K90 Pro Max |
| Codename | `myron` |
| Board | `sm8850_thales` |
| Platform | `xiaomi_sm8850` (sun) |
| Chip | Snapdragon 8 Elite (sm8850) |
| GPU | Adreno 840 |
| Arch | arm64 / oryon |
| Partition | A-only + Virtual A/B |
| Filesystem | EROFS (system/vendor), F2FS (data) |
| Encryption | FBE v2 + Thales KeyMint Strongbox (JavaCard HSM) |
| Boot header | v4 |
| Ramdisk | LZ4 Legacy |
| Android | 15 (API 35) |
| Recovery size | 100MB |

---

## Cấu trúc tree

```
android_device_xiaomi_myron/
├── BoardConfig.mk              # Board config chính
├── Android.mk / Android.bp     # Build system
├── AndroidProducts.mk          # Lunch targets
├── twrp_myron.mk               # Product definition
├── device.mk                   # Device packages
├── fox_myron.mk                # OrangeFox-specific flags
├── system.prop                 # System properties
├── recovery.fstab              # Partition mount table
├── vendorsetup.sh
├── odm/
│   ├── bin/
│   │   ├── prepdecrypt.sh      # Script chuẩn bị decrypt (từ stock)
│   │   ├── variant-script.sh
│   │   └── hw/                 # → CẦN COPY TỪ STOCK ROM
│   │       ├── android.hardware.security.keymint-service.strongbox
│   │       └── android.hardware.weaver-service
│   ├── lib64/                  # → CẦN COPY TỪ STOCK ROM
│   │   ├── ese_weaver_thales.so
│   │   ├── libjc_keymint-thales.so
│   │   └── libjc_keymint_transport-thales.so
│   └── etc/init/               # RC service files
│       ├── prepdecrypt.rc
│       ├── android.hardware.security.keymint-service.strongbox.rc
│       ├── android.hardware.weaver-service.rc
│       └── se_omapi.rc
├── recovery/root/
│   ├── init.recovery.qcom.rc   # Từ ramdisk thực tế
│   └── init.recovery.wifi.rc
└── prebuilt/
    └── kernel                  # → CẦN THÊM kernel Image
```

---

## Build

### 1. Sync OrangeFox source

```bash
mkdir -p ~/android/OrangeFox
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./orangefox_sync.sh --branch 12.1 --path ~/android/OrangeFox
```

### 2. Clone device tree

```bash
cd ~/android/OrangeFox
git clone https://github.com/YOUR_USERNAME/android_device_xiaomi_myron \
    -b ofox-12.1 device/xiaomi/myron
```

### 3. Thêm prebuilt kernel

```bash
# Lấy kernel từ stock ROM
adb pull /dev/block/bootdevice/by-name/boot boot.img
./out/host/linux-x86/bin/magiskboot unpack boot.img
cp kernel device/xiaomi/myron/prebuilt/kernel
```

### 4. Copy Thales libs từ stock ROM (BẮT BUỘC để decrypt)

```bash
# Kết nối device đang chạy stock ROM
adb pull /odm/lib64/ese_weaver_thales.so            device/xiaomi/myron/odm/lib64/
adb pull /odm/lib64/libjc_keymint-thales.so         device/xiaomi/myron/odm/lib64/
adb pull /odm/lib64/libjc_keymint_transport-thales.so device/xiaomi/myron/odm/lib64/
adb pull /odm/bin/hw/android.hardware.security.keymint-service.strongbox device/xiaomi/myron/odm/bin/hw/
adb pull /odm/bin/hw/android.hardware.weaver-service device/xiaomi/myron/odm/bin/hw/
adb pull /odm/bin/se_omapi                           device/xiaomi/myron/odm/bin/
```

### 5. Build

```bash
cd ~/android/OrangeFox
source build/envsetup.sh
lunch twrp_myron-eng
mka adbd recoveryimage -j$(nproc)
```

### 6. Flash

```bash
fastboot flash recovery out/target/product/myron/recovery.img
fastboot reboot recovery
```

---

## Nguyên nhân lỗi giải mã (phân tích từ ramdisk)

Device này dùng **Thales JavaCard HSM** cho encryption key management — đây là hardware security module đặc biệt, **không thể build từ source**.

### Chain decrypt của myron:

```
FBE unlock request
    → keymint-strongbox  (odm/bin/hw/)
        → ese_weaver_thales.so  (Thales SE lib)
            → libjc_keymint-thales.so  (JavaCard bridge)
                → Physical Thales SE chip
    → weaver-service  (odm/bin/hw/)
        → ese_weaver_thales.so
    → prepdecrypt.sh  (odm/bin/)
        → setprop crypto.ready 1
    → TWRP decrypt UI
```

### Các lỗi thường gặp và fix:

| Lỗi | Nguyên nhân | Fix |
|-----|-------------|-----|
| "Decryption unsuccessful" | Thiếu `ese_weaver_thales.so` | Copy từ stock ROM |
| "keymint-strongbox failed" | Thiếu Thales binary | Copy `android.hardware.security.keymint-service.strongbox` |
| "crypto.ready not set" | `prepdecrypt.sh` không chạy | Kiểm tra `init.recovery.qcom.rc` có trigger `odm.prepdecrypt` |
| Màn hình đen sau boot | Thiếu kernel phù hợp | Dùng kernel từ stock ROM |
| Touch không hoạt động | Thiếu touch KO modules | Thêm đúng `.ko` vào `TW_LOAD_VENDOR_MODULES` |

---

## TODO checklist

- [ ] Copy Thales libs từ stock ROM vào `odm/lib64/`
- [ ] Copy Thales binaries vào `odm/bin/hw/`
- [ ] Thêm kernel prebuilt vào `prebuilt/kernel`
- [ ] Cập nhật `BOARD_SUPER_PARTITION_SIZE` đúng với device
- [ ] Xác nhận tên `.ko` touchscreen và thêm vào `TW_LOAD_VENDOR_MODULES`
- [ ] Cập nhật `BUILD_FINGERPRINT` trong `twrp_myron.mk`
- [ ] Test decrypt và ghi log `/tmp/recovery.log`

---

## Debug decrypt

Sau khi boot recovery, kết nối ADB:

```bash
adb shell cat /tmp/recovery.log | grep -iE "decrypt|crypto|keymint|weaver|prepdecrypt"
adb shell getprop crypto.ready
adb shell getprop ro.crypto.state
adb shell getprop ro.crypto.type
```

---

## Credits

- Ramdisk analysis: phân tích từ recovery.img thực tế của device
- Reference: [OnePlus 15 tree](https://github.com/koaaN/android_device_oneplus_infiniti-orangefox) (cùng platform sm8850)
- [OrangeFox Recovery Project](https://orangefox.download)
