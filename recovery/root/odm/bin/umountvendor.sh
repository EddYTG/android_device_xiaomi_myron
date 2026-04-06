#!/system/bin/sh
umount -f -l /vendor
echo "I:umountvendor.sh: Force umount /vendor" >> /tmp/recovery.log
