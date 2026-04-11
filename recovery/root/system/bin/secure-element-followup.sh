#!/system/bin/sh
# secure-element-followup.sh — myron
# Deferred: dọn dẹp sidecars không cần cho decrypt
# Chạy sau khi vendor.secure_element/keymint-strongbox/se_omapi đã start

sleep 5
# Không cần làm gì thêm trên myron — chain đơn giản hơn pudding
setprop twrp.myron.secelt.followup_done 1
