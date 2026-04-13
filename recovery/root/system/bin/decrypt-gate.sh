#!/system/bin/sh
# decrypt-gate.sh — myron (PATCHED v6 từ ROM dump thực tế)
#
# 4 service names thực tế xác nhận từ getprop trên ROM:
#   vendor.keymint          ← android.hardware.security.onekeymint-service-qti
#   vendor.keymint-strongbox ← android.hardware.security.keymint3-service.strongbox.nxp
#   vendor.secure_element   ← android.hardware.secure_element-service.qti
#   vendor.weaver_nxp       ← android.hardware.weaver-service.nxp-qti
#
# OMAPI = com.android.se Java app — KHÔNG poll, tự start theo framework

log_step() {
    log -t twrp-decrypt-gate "myron: $1"
}

setprop twrp.myron.decrypt_gate 1
log_step "delay start; waiting 8s for HALs to init"
sleep 8

MAX_TRIES=12
try=0
while [ $try -lt $MAX_TRIES ]; do
    s1=$(getprop init.svc.vendor.keymint)
    s2=$(getprop init.svc.vendor.keymint-strongbox)
    s3=$(getprop init.svc.vendor.secure_element)
    s4=$(getprop init.svc.vendor.weaver_nxp)

    log_step "try=$try keymint=$s1 strongbox=$s2 secure_element=$s3 weaver_nxp=$s4"

    if [ "$s1" = "running" ] && [ "$s2" = "running" ] && \
       [ "$s3" = "running" ] && [ "$s4" = "running" ]; then
        log_step "all 4 services running → starting prepdecrypt"
        setprop ctl.start odm.prepdecrypt
        exit 0
    fi

    sleep 2
    try=$((try + 1))
done

log_step "TIMEOUT after $((MAX_TRIES * 2 + 8))s — firing prepdecrypt anyway"
setprop ctl.start odm.prepdecrypt
