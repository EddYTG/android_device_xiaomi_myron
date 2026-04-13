#!/system/bin/sh
# secure-element-ta-setup.sh — myron
# Stage firmware TAs từ /firmware/image/ vào /tmp/secure_element_fwroot/image/
# Sau đó set twrp.myron.fix22zr.ready=1 → trigger restart strongbox/se_omapi

STAGING_ROOT="/tmp/secure_element_fwroot"
STAGING_DIR="$STAGING_ROOT/image"
FIRMWARE_DIR="/firmware/image"
FALLBACK_DIR="/system/bin/twrp_secure_element_ta"

log_step() {
    log -t twrp-secelt "myron-ta-setup: $1"
}

log_step "starting, waiting 18s for /firmware mount"
sleep 18

# Kiểm tra /firmware/image có tồn tại không
if [ ! -d "$FIRMWARE_DIR" ]; then
    log_step "ERROR: $FIRMWARE_DIR not found — /firmware not mounted?"
    # Vẫn set ready để decrypt-gate không block mãi
    setprop twrp.myron.fix22zr.ta_staged 0
    setprop twrp.myron.fix22zr.ready 1
    exit 1
fi

# Tạo staging dir
rm -rf "$STAGING_ROOT"
mkdir -p "$STAGING_DIR"
chmod 0755 "$STAGING_ROOT"
chmod 0755 "$STAGING_DIR"
log_step "staging dir created"

# Copy fallback stubs trước (nếu có)
if [ -d "$FALLBACK_DIR" ]; then
    cp -af "$FALLBACK_DIR/." "$STAGING_DIR/" 2>/dev/null
    log_step "fallback stubs copied"
fi

# Copy real firmware TAs (override fallback)
cp -af "$FIRMWARE_DIR/." "$STAGING_DIR/"
log_step "firmware TAs copied rc=$?"

chmod 0644 "$STAGING_DIR"/* 2>/dev/null

# Verify key TAs
for ta in \
    st_eseservice.b00 eseservice.b00 gpqese.b00 \
    FD719D50-FFFB-11EB-9A03-0242AC130003.b00 \
    FD719D50-FFFB-11EB-9A03-0242AC130003.mdt \
    32552B22-89FE-42B4-8A45-A0C4E2DB0326.b00 \
    32552B22-89FE-42B4-8A45-A0C4E2DB0326.mdt \
    05B04A44-BF30-42DF-9E2F-B366B980ED19.b00 \
    05B04A44-BF30-42DF-9E2F-B366B980ED19.mdt
do
    if [ -f "$STAGING_DIR/$ta" ]; then
        log_step "staged OK: $ta"
    else
        log_step "staged MISSING: $ta"
    fi
done

setprop twrp.myron.fix22zr.ta_staged 1
setprop twrp.myron.fix22zr.ready 1
log_step "done — strongbox/se chain will restart"
