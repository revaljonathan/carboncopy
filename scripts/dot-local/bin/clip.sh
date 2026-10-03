#!/usr/bin/env bash

cliphist list | fzf \
    --delimiter='\t' \
    --with-nth=2.. \
    --color=base16,fg+:200,bg+:-1,border:bright-black,pointer:200 \
    --layout=reverse \
    --preview='id={1}; line=$(cliphist list | awk -v i="$id" "\$1==i" | cut -f2-)
        case "$line" in
            "[[ binary data"*)
                cliphist decode "$id" > /tmp/cliphist-preview
                chafa --format=sixel --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" /tmp/cliphist-preview
                ;;
            *)
                cliphist decode "$id" | head -c 3000
                ;;
        esac' \
    --preview-window='right:70%:wrap:border:sharp' \
| cliphist decode | wl-copy
