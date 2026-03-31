#!/system/bin/sh
# cp-wifi-ko.sh — EXACT copy from TWRP 3.7.1_16 ramdisk (system/bin/cp-wifi-ko.sh)
LOGFILE=/tmp/recovery.log
log_msg() { echo "[cp-wifi-ko] $1" >> "$LOGFILE"; }
log_msg "Starting WiFi KO copy for myron"
VARIANT_DIR=/odm/variant/myron
ODM_WIFI=/odm/wifi/modules
mkdir -p "$ODM_WIFI"
if [ -d "$VARIANT_DIR/odm/wifi/modules" ]; then
    cp -r "$VARIANT_DIR/odm/wifi/modules/." "$ODM_WIFI/"
    log_msg "Copied from $VARIANT_DIR"
else
    log_msg "No variant modules, skipping"
fi
setprop twrp.cpko true
log_msg "Done"
