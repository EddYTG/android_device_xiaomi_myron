#!/system/bin/sh
# persist-alias-setup.sh — myron
# Tạo symlink /persist → /mnt/vendor/persist sau khi persist được mount

PERSIST_SRC="/mnt/vendor/persist"
PERSIST_DST="/persist"

# Poll đến khi persist mount xong
i=0
while [ $i -lt 20 ]; do
    if grep -q "$PERSIST_SRC" /proc/mounts 2>/dev/null; then
        break
    fi
    sleep 1
    i=$((i + 1))
done

if [ ! -e "$PERSIST_DST" ]; then
    ln -s "$PERSIST_SRC" "$PERSIST_DST"
fi

setprop odm.persist.alias.done 1
