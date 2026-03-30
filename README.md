# OrangeFox Recovery — Xiaomi F8U / POCO F8 Ultra / Redmi K90 Pro Max

**Codename:** `myron`  
**SoC:** Snapdragon 8 Elite (sm8850 / sun)  
**Android:** 16 (SDK 36), Kernel 6.12  
**Partition type:** A/B with dedicated recovery partition + Virtual A/B  

---

## Tree source

All files in this tree are extracted from **working TWRP 3.7.1_16-myron** ramdisk + TWRP boot log analysis.  
No guesswork — every config value is confirmed from the live device.

---

## Build instructions

```bash
# 1. Set up OrangeFox build environment (AOSP 12.1 / OFox R12.1)
source build/envsetup.sh

# 2. Sync device tree
cd device && mkdir xiaomi && cd xiaomi
# Place this tree as: device/xiaomi/myron

# 3. Build
lunch twrp_myron-eng
mka recoveryimage -j$(nproc)

# Output: out/target/product/myron/recovery.img
```

---

## Key fixes vs original bootlooping tree

| File | What was wrong | Fixed |
|------|---------------|-------|
| `BoardConfig.mk` | `TW_LOAD_VENDOR_MODULES` had `oplus_bsp_tp_*.ko` (nonexistent) | → `focaltech_touch_3683.ko` |
| `BoardConfig.mk` | `BOARD_BOOTIMAGE_PARTITION_SIZE` was 104857600 (wrong) | → 100663296 (96MB actual) |
| `BoardConfig.mk` | Dynamic partition list missing `vendor_dlkm`, `system_dlkm`, `mi_ext` | → all 8 partitions added |
| `recovery.fstab` | `slotselect` was removed (device IS A/B) | → restored from TWRP ramdisk verbatim |

---

## Device confirmed properties (from live TWRP log + ramdisk)

```
ro.board.platform          = xiaomi_sm8850
ro.product.board           = sun
ro.boot.slot_suffix        = _a         ← TRUE A/B device
ro.virtual_ab.enabled      = true
ro.boot.dynamic_partitions = true
ro.crypto.type             = file       ← FBE v2
fbe.filenames              = aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0
Screen                     = 1200×2608  RGBX_8888
Kernel                     = 6.12, boot header v4, LZ4 ramdisk
AB OTA partitions          = boot,dtbo,init_boot,odm,product,recovery,
                             system,system_dlkm,system_ext,vbmeta,
                             vbmeta_system,vendor,vendor_boot,vendor_dlkm
Touch driver               = focaltech_touch_3683.ko (FTS series)
Security patch (TWRP)      = 2099-12-31
```

---

## Partition layout (from TWRP log)

```
/boot           96MB   /dev/block/bootdevice/by-name/boot_a
/recovery      100MB   /dev/block/bootdevice/by-name/recovery_a
/vendor_boot    96MB   /dev/block/bootdevice/by-name/vendor_boot_a
/init_boot       8MB   /dev/block/bootdevice/by-name/init_boot_a
/dtbo           32MB   /dev/block/bootdevice/by-name/dtbo_a
/data          f2fs    /dev/block/sda34                       (FBE encrypted)
/metadata      f2fs    /dev/block/sda20
/cache         ext4    /dev/block/sda32  (rescue partition)
/persist       ext4    /dev/block/sdf8
Super logical partitions (dm-0..dm-7):
  mi_ext  odm  product  system  system_dlkm  system_ext  vendor  vendor_dlkm
  All format: erofs (read-only)
```

---

## Maintainer

Update `OF_MAINTAINER` in `fox_myron.mk`.
