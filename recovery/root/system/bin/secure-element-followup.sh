#!/system/bin/sh
# secure-element-followup.sh — myron v6
# Deferred sidecar: chạy sau khi SE chain (secure_element + keymint-strongbox) start
# OMAPI = com.android.se Java app — không liên quan ở đây

sleep 5
# Không cần thêm gì trên myron — chain NXP đơn giản hơn pudding/thales
setprop twrp.myron.secelt.followup_done 1
