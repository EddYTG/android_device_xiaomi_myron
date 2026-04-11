#!/system/bin/sh
# decrypt-gate.sh — myron
# Poll 4 services cần thiết cho FBE decrypt, sau đó fire prepdecrypt

sleep 8

MAX_TRIES=8
try=0
while [ $try -lt $MAX_TRIES ]; do
    s1=$(getprop init.svc.vendor.keymint)
    s2=$(getprop init.svc.vendor.keymint-strongbox)
    s3=$(getprop init.svc.vendor.secure_element)
    s4=$(getprop init.svc.odm.se_omapi)

    if [ "$s1" = "running" ] && [ "$s2" = "running" ] && \
       [ "$s3" = "running" ] && [ "$s4" = "running" ]; then
        setprop ctl.start odm.prepdecrypt
        exit 0
    fi

    sleep 2
    try=$((try + 1))
done

# Timeout — thử start prepdecrypt anyway
setprop ctl.start odm.prepdecrypt
