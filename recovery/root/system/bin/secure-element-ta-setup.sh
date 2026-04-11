#!/system/bin/sh
# secure-element-ta-setup.sh — myron
# Stage firmware TAs từ /firmware/image/ vào /tmp/secure_element_fwroot/
# Sau đó set prop twrp.myron.fix22zr.ready=1 để trigger start strongbox/se_omapi

STAGING="/tmp/secure_element_fwroot/image"
FIRMWARE="/firmware/image"

# Chờ firmware partition mount (twrp.modules.loaded=true đã mount ở on property)
sleep 18

mkdir -p "$STAGING"
chmod 0755 /tmp/secure_element_fwroot
chmod 0755 "$STAGING"

# Copy TAs vào staging
if [ -d "$FIRMWARE" ]; then
    cp "$FIRMWARE"/* "$STAGING"/ 2>/dev/null
    chmod 0644 "$STAGING"/*  2>/dev/null
fi

setprop twrp.myron.fix22zr.ta_staged 1
setprop twrp.myron.fix22zr.ready 1
