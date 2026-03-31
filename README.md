# OrangeFox Recovery — Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
## Branch: 14.1 (Android 16 / SDK 36)

| Field | Value |
|---|---|
| Codename | myron |
| SoC | Snapdragon 8 Elite (SM8850 / sun) |
| Android | 16 (SDK 36) |
| Recovery partition | Dedicated 100MB `/recovery_a/_b` |
| super size | 14495514624 (13.5GB) — from `fastboot getvar all` |

## Build
```bash
source build/envsetup.sh
export FOX_VIRTUAL_AB_DEVICE=1
lunch omni_myron-eng
mka recoveryimage
```

## GitHub Actions workflow
```yaml
- name: Building OrangeFox
  run: |
    export ALLOW_MISSING_DEPENDENCIES=true
    export FOX_VIRTUAL_AB_DEVICE=1   ← BẮT BUỘC
    lunch omni_myron-eng && make clean && mka recoveryimage
```

## Fixes vs auto-generated tree
| Flag | Auto-gen (sai) | Tree này (đúng) |
|---|---|---|
| BOARD_USES_RECOVERY_AS_BOOT | true | false |
| TARGET_BOARD_PLATFORM | canoe | sm8850 |
| BOARD_SUPER_PARTITION_SIZE | 9126805504 | 14495514624 |
| BOARD_BOOTIMAGE_PARTITION_SIZE | 104857600 | 100663296 |
| BOARD_SYSTEMIMAGE_PARTITION_TYPE | ext4 | erofs |
| BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE | ext4 | f2fs |
| PRODUCT_NAME | twrp_myron | omni_myron |
