#!/usr/bin/env bash

GIT_ISSUE=􀍷
GIT_DISCUSSION=􀒤
GIT_PULL_REQUEST=􀙡
GIT_COMMIT=􀡚

update() {
    source "$CONFIG_DIR/plugins/count_to_color.sh"
    source "$CONFIG_DIR/colors.sh"

    notifications="$(gh api notifications)"
    count="$(echo "$notifications" | jq 'length')"
    read -r labelcolor label <<< "$(count_to_color "$count")"

    args=(
        --set "$NAME" label="$label" label.color="$labelcolor" icon.color="$foreground"
        --remove '/github.notification\.*/'
    )

    prev_count=$(sketchybar --query "$NAME" | jq -r .label.value)
    # For sound to play around with:
    # afplay /System/Library/Sounds/Morse.aiff

    counter=0

    while read -r repo url type title
    do
        counter=$((counter + 1))
        padding=0

        # If there are no messages, still make a popup.
        if [ "${repo}" = "" ] && [ "${title}" = "" ]; then
            color=$BLUE
            icon=""
            url="https://www.github.com/"
            repo="Note"
            title="No new notifications"
        fi

        # Now create entry for this message in pop-up
        case "${type}" in
            "'Issue'")
                color=$GREEN
                icon=$GIT_ISSUE
                url="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
            "'Discussion'")
                color=$WHITE
                icon=$GIT_DISCUSSION
                url="https://www.github.com/notifications"
                ;;
            "'PullRequest'")
                color=$MAGENTA
                icon=$GIT_PULL_REQUEST
                url="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
            "'Commit'")
                color=$WHITE
                icon=$GIT_COMMIT
                url="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
        esac
        important="$(echo "$title" | grep -E -i "(deprecat|break|broke)")"
        if [ "$important" != "" ]; then
            color=$RED # if important, override color
            # If there is at least one important message, make bar icon red as well.
            args+=(--set "$NAME" icon.color="$alert")
        fi

        notification=(
            icon="$icon $(echo "$repo" | sed -e "s/^'//" -e "s/'$//"):"
            icon.color="$color"
            icon.padding_left="$padding"
            label="$(echo "$title" | sed -e "s/^'//" -e "s/'$//")"
            label.padding_right="$padding"
            position=popup.github
            drawing=on
            click_script="open $url; sketchybar --set github popup.drawing=off"
        )

        args+=(
            --clone "github.notification.$counter" github_popup_template
            --set "github.notification.$counter" "${notification[@]}"
        )
    done <<< "$(echo "$notifications" | jq -r '.[] | [.repository.name, .subject.latest_comment_url, .subject.type, .subject.title] | @sh')"

    sketchybar -m "${args[@]}" > /dev/null

    if [ "$count" != "$prev_count" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
        # Animate a jump.
        sketchybar --animate tanh 15 --set "$NAME" label.y_offset=-5 label.y_offset=5 label.y_offset=0
    fi
}

popup() {
    sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
    "routine"|"forced")
        update
        ;;
    "mouse.entered")
        popup on
        ;;
    "mouse.exited"|"mouse.exited.global")
        popup off
        ;;
    "mouse.clicked")
        if [ "$BUTTON" = "right" ]; then
            update
        fi
        ;;
esac
