#!/usr/bin/env bash

clipboard_mode() {
    if [ "$ROFI_RETV" = "0" ]; then
        cliphist list | while IFS= read -r line; do
            id="${line%%	*}"
            content="${line#*	}"

            if [[ "$content" == *"[[ binary data"* ]]; then
                printf '󰋩 IMAGE: %s\0info\x1f%s\n' "$id" "$id"
            else
                printf '%s\0info\x1f%s\n' "$content" "$id"
            fi
        done
    else
        cliphist decode "$ROFI_INFO" | wl-copy
        exit 0
    fi
}

export -f clipboard_mode

if [ -z "$ROFI_RETV" ]; then
    rofi -modi "clipboard:$0" \
         -show clipboard \
         -theme ~/.config/rofi/clipboard.rasi
else
    clipboard_mode "$@"
fi
