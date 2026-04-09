#!/system/bin/sh
#=================================================
# Auto-set device properties based on hardware SKU
# POSIX sh compatible (mksh safe — no bash arrays)
#=================================================

VARIANT=$(getprop ro.boot.hardware.sku)
BASE_NAME="Xiaomi"
LOG_FILE="/tmp/recovery.log"

log() {
    echo "variant-script: $1" | tee -a "$LOG_FILE"
}

#-------------------------------------------------
# Variant-specific configuration
#-------------------------------------------------
case "$VARIANT" in
"myron")
    MODEL="$BASE_NAME F8U"
    resetprop ro.twrp.device_version "POCO_F8_ULTRA"
    resetprop ro.twrp.y_offset "111"
    resetprop ro.twrp.h_offset "-111"
    resetprop vendor.display.enable_spr "1"
    resetprop ro.odm.mm.vibrator.audio_haptic_support "true"
    resetprop ro.odm.mm.vibrator.resonant_frequency "170"
    resetprop ro.odm.mm.vibrator.slide_effect_protect_time "35"
    resetprop ro.odm.mm.vibrator.sys_path "/sys/class/qcom-haptics"
    resetprop ro.odm.mm.vibrator.device_type "agm"
    resetprop ro.vendor.mm.vibrator.sys_path "/sys/class/qcom-haptics"
    ;;
*)
    log "Unknown variant: $VARIANT, applying default configuration (myron fallback)"
    VARIANT="myron"
    MODEL="$BASE_NAME F8U"
    resetprop ro.odm.mm.vibrator.audio_haptic_support "true"
    resetprop ro.odm.mm.vibrator.resonant_frequency "170"
    resetprop ro.odm.mm.vibrator.slide_effect_protect_time "35"
    resetprop ro.odm.mm.vibrator.sys_path "/sys/class/qcom-haptics"
    resetprop ro.odm.mm.vibrator.device_type "agm"
    resetprop ro.vendor.mm.vibrator.sys_path "/sys/class/qcom-haptics"
    ;;
esac

#-------------------------------------------------
# Common configuration
#-------------------------------------------------
echo "$MODEL" > /config/usb_gadget/g1/strings/0x409/product 2>/dev/null || true
resetprop vendor.usb.product_string "$MODEL"
mkdir -p /usbotg

#-------------------------------------------------
# Set product & model properties (POSIX sh loop)
#-------------------------------------------------
for prop in \
    ro.build.product \
    ro.product.device \
    ro.product.odm.device \
    ro.product.vendor.device \
    ro.product.product.device \
    ro.product.system_ext.device \
    ro.product.system.device \
    ro.product.bootimage.device \
    ro.product.name \
    ro.product.odm.name \
    ro.product.vendor.name \
    ro.product.product.name \
    ro.product.system_ext.name \
    ro.product.system.name
do
    resetprop "$prop" "$VARIANT"
done

for prop in \
    ro.product.model \
    ro.product.odm.model \
    ro.product.vendor.model \
    ro.product.product.model \
    ro.product.system_ext.model \
    ro.product.system.model
do
    resetprop "$prop" "$MODEL"
done

#-------------------------------------------------
# Copy variant-specific files (overlay onto /odm)
# /odm is a ramdisk dir (writable) at this stage
# Only copy if variant dir exists
#-------------------------------------------------
VARIANT_SRC="/odm/variant/$VARIANT/odm"
if [ -d "$VARIANT_SRC" ]; then
    cp -rf "$VARIANT_SRC/." /odm/ && log "Copied variant files from $VARIANT_SRC"
    chmod -R 755 /odm/bin/ 2>/dev/null || true
    [ -d /odm/lib64 ] && chmod 644 /odm/lib64/*.so 2>/dev/null || true
    [ -d /odm/firmware ] && chmod 644 /odm/firmware/* 2>/dev/null || true
else
    log "WARNING: No variant dir at $VARIANT_SRC — skipping overlay copy"
fi

#-------------------------------------------------
# Signal that variant files are ready
# KeyMint / Weaver / touch_report chain depends on this prop
#-------------------------------------------------
setprop twrp.variant.files_copied "1"

log "Applied variant props for: $MODEL ($VARIANT)"
exit 0
