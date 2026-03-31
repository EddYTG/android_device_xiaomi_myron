# OrangeFox Recovery — Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)

## Device Info
| Field | Value |
|---|---|
| Codename | myron |
| SoC | Snapdragon 8 Elite (SM8850 / sun) |
| Recovery | **Dedicated** `/dev/block/bootdevice/by-name/recovery` |
| Boot type | A/B (VAB) with dedicated recovery — NOT recovery-as-boot |
| Screen | 1200×2608 RGBX_8888 |
| Encryption | FBE v2, Thales Keymint Strongbox + Weaver |

## Build Command
```bash
source build/envsetup.sh
lunch twrp_myron-eng
mka recoveryimage
```

## GitHub Actions — CRITICAL
```yaml
BUILD_TARGET: recoveryimage   ← MUST BE THIS
# NOT: bootimage  ← causes bootloop
```

## Why the Old Tree Bootlooped

| Flag | Old (wrong) | New (correct) |
|---|---|---|
| `BOARD_USES_RECOVERY_AS_BOOT` | `true` | `false` |
| GitHub `BUILD_TARGET` | `bootimage` | `recoveryimage` |

**Evidence from TWRP ramdisk:**
1. `twrp.flags`: `/recovery emmc /dev/block/bootdevice/by-name/recovery`
2. `prop.default` AB_OTA list does **not** include `recovery`
3. Image = exactly 100MB = `BOARD_RECOVERYIMAGE_PARTITION_SIZE`
4. `kernel_size = 0` → GKI-style recovery, kernel in vendor_boot

## All Data Verified From TWRP 3.7.1_16 Ramdisk
- **Image header**: kernel_size=0, ramdisk LZ4 legacy, os_version=99.87.36
- **AVB**: algorithm=NONE, auth_block_size=0 (unsigned)
- **prop.default**: all platform props, USB IDs, API levels, security patch
- **recovery.fstab**: exact FBE flags, partition layout
- **twrp.flags**: exact partition list including /recovery dedicated
- **RC files**: exact init sequence, service names, LD_LIBRARY_PATH
- **variant-script.sh**: y_offset=111, h_offset=-111, vibrator=qcom-haptics
- **odm/**: Thales blobs, focaltech firmware, vibrator service
