#!/system/bin/sh
# variant-script.sh — POSIX sh compatible (no bash arrays)
# Auto-set device properties based on hardware SKU
LOGFILE=/tmp/recovery.log
log_msg() { echo "variant-props-override.sh: $1" >> "$LOGFILE"; }

VARIANT=$(getprop ro.boot.hardware.sku)
BASE_NAME="Xiaomi"

set_vibrator_props() {
    resetprop ro.odm.mm.vibrator.audio_haptic_support "true"
    resetprop ro.odm.mm.vibrator.resonant_frequency "$1"
    resetprop ro.odm.mm.vibrator.slide_effect_protect_time "$2"
    resetprop ro.odm.mm.vibrator.sys_path "$3"
    resetprop ro.odm.mm.vibrator.device_type "$4"
    resetprop ro.vendor.mm.vibrator.sys_path "/sys/class/qcom-haptics"
}

case "$VARIANT" in
"myron")
    MODEL="${BASE_NAME} F8U"
    resetprop ro.twrp.device_version "POCO_F8_ULTRA"
    resetprop ro.twrp.y_offset "111"
    resetprop ro.twrp.h_offset "-111"
    resetprop vendor.display.enable_spr "1"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;
*)
    log_msg "Unknown variant: $VARIANT, applying default (SM8850)"
    VARIANT="SM8850"
    MODEL="SM8850"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;
esac

# USB gadget
echo "$MODEL" > /config/usb_gadget/g1/strings/0x409/product
resetprop vendor.usb.product_string "$MODEL"
mkdir -p /usbotg

# Device props
for PROP in ro.build.product ro.product.device ro.product.odm.device \
            ro.product.vendor.device ro.product.product.device \
            ro.product.system_ext.device ro.product.system.device \
            ro.product.bootimage.device ro.product.name ro.product.odm.name \
            ro.product.vendor.name ro.product.product.name \
            ro.product.system_ext.name ro.product.system.name; do
    resetprop "$PROP" "$VARIANT"
done

# Model props
for PROP in ro.product.model ro.product.odm.model ro.product.vendor.model \
            ro.product.product.model ro.product.system_ext.model ro.product.system.model; do
    resetprop "$PROP" "$MODEL"
done

# Copy variant files
cp -rf /odm/variant/${VARIANT}/odm/* /odm/
chmod -R 755 /odm/bin/*

# Signal done — triggers keymint/weaver/wifi services in init.recovery.qcom.rc
setprop twrp.variant.files_copied "1"

log_msg "Applied variant props for: $MODEL ($VARIANT)"
exit 0
