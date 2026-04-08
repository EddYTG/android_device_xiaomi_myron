# OrangeFox Recovery — Xiaomi myron
## POCO F8 Ultra / Redmi K90 Pro Max

| Field | Value |
|---|---|
| Codename | myron |
| SoC | Snapdragon 8 Elite Gen 5 (SM8850 / sun) |
| Branch | OrangeFox 14.1 (Android 16 / SDK 36) |
| Recovery partition | Dedicated 100MB `/recovery_a/_b` |
| super size | 14495514624 (13.5GB) — confirmed `fastboot getvar all` |
| Display | 1200×2608, y_offset=111, h_offset=-111 |
| Touch IC | Focaltech FTS (focaltech_touch_3683.ko) |
| Haptics | RTP Effects (canoe platform) |
| Crypto | FBE v2, NXP Keymint Strongbox + Weaver |

## Status
- [x] ADB
- [x] Decryption (FBE v2 / Thales Strongbox)
- [x] Display (1200×2608)
- [x] Fastbootd
- [x] Flashing (erofs/f2fs)
- [x] MTP
- [x] Sideload
- [x] USB-OTG
- [x] Vibrator (CS40L26 haptics)
- [x] WiFi (peach_v2 chipset)
- [x] KernelSU / KernelSU-Next / SukiSU

## Build locally

```bash
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_VIRTUAL_AB_DEVICE=1
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
lunch omni_myron-eng
mka recoveryimage
```

## GitHub Actions

Use `.github/workflows/build.yml` — trigger **workflow_dispatch** from GitHub Actions tab.

Default inputs are pre-filled for this repo/branch.

## Key fixes vs auto-generated tree

| Flag | Auto-gen (wrong) | This tree (correct) |
|---|---|---|
| `BOARD_USES_RECOVERY_AS_BOOT` | true | false |
| `TARGET_BOARD_PLATFORM` | canoe / sm8850 | xiaomi_sm8850 |
| `TARGET_BOOTLOADER_BOARD_NAME` | myron | sun |
| `BOARD_SUPER_PARTITION_SIZE` | 9126805504 | 14495514624 |
| `BOARD_BOOTIMAGE_PARTITION_SIZE` | 104857600 | 100663296 |
| `BOARD_SYSTEMIMAGE_PARTITION_TYPE` | ext4 | erofs |
| `BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE` | ext4 | f2fs |
| `PRODUCT_NAME` | twrp_myron | omni_myron |
| `OF_STATUS_H` | 100 | 111 |
| vendor binaries | missing | present (Keymint/qseecomd/WiFi) |
| `vendorsetup.sh` | missing | present (all FOX_ vars) |
| `build.yml` | missing | present (OFRP 14.1 workflow) |

## Tree based on

- sm8750 (Snapdragon 8 Elite / Xiaomi) OrangeFox 14.1 — working reference
- TWRP 3.7.1_16 ramdisk extracted from myron working image
- `fastboot getvar all` output from myron device
