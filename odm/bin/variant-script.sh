#!/system/bin/sh
#=================================================
# Auto-set device properties based on hardware SKU
#=================================================
set -e

variant=$(getprop ro.boot.hardware.sku)
base_name="Xiaomi"
log_file="/tmp/recovery.log"

log() {
    echo "variant-props-override.sh: $1" | tee -a "$log_file"
}

#-------------------------------------------------
# Helper: set multiple vibrator-related properties
#-------------------------------------------------
set_vibrator_props() {
    resetprop ro.odm.mm.vibrator.audio_haptic_support "true"
    resetprop ro.odm.mm.vibrator.resonant_frequency "$1"
    resetprop ro.odm.mm.vibrator.slide_effect_protect_time "$2"
    resetprop ro.odm.mm.vibrator.sys_path "$3"
    resetprop ro.odm.mm.vibrator.device_type "$4"
    resetprop ro.vendor.mm.vibrator.sys_path "/sys/class/qcom-haptics"
}

#-------------------------------------------------
# Variant-specific configuration
#-------------------------------------------------
case "$variant" in
"myron")
    model="$base_name F8U"
    resetprop ro.twrp.device_version "POCO_F8_ULTRA"
    resetprop ro.twrp.y_offset "111"
    resetprop ro.twrp.h_offset "-111"
    resetprop vendor.display.enable_spr "1"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;

*)
    #-----------------------------------------
    # Default configuration
    #-----------------------------------------
    log "Unknown variant: $variant, applying default configuration (SM8850)"
    variant="SM8850"
    model="SM8850"
    set_vibrator_props "170" "35" "/sys/class/qcom-haptics" "agm"
    ;;
esac

#-------------------------------------------------
# Common configuration
#-------------------------------------------------
echo "$model" >/config/usb_gadget/g1/strings/0x409/product
resetprop vendor.usb.product_string "$model"
mkdir -p /usbotg

#-------------------------------------------------
# Set product & model properties
#-------------------------------------------------
device_props=(
    ro.build.product
    ro.product.device
    ro.product.odm.device
    ro.product.vendor.device
    ro.product.product.device
    ro.product.system_ext.device
    ro.product.system.device
    ro.product.bootimage.device
    ro.product.name
    ro.product.odm.name
    ro.product.vendor.name
    ro.product.product.name
    ro.product.system_ext.name
    ro.product.system.name
)

model_props=(
    ro.product.model
    ro.product.odm.model
    ro.product.vendor.model
    ro.product.product.model
    ro.product.system_ext.model
    ro.product.system.model
)

for prop in "${device_props[@]}"; do
    resetprop "$prop" "$variant"
done

for prop in "${model_props[@]}"; do
    resetprop "$prop" "$model"
done

#-------------------------------------------------
# Copy variant-specific files
#-------------------------------------------------
cp -rf /odm/variant/$variant/odm/* /odm
chmod -R 755 /odm/bin/*
setprop twrp.variant.files_copied "1"

#-------------------------------------------------
# Done
#-------------------------------------------------
log "Applied variant props for: $model ($variant)"
exit 0
