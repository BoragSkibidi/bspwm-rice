#!/usr/bin/env bash

select_player() {
    local player status
    local -a players=()

    while IFS= read -r player; do
        [[ -n $player ]] && players+=("$player")
    done < <(playerctl --list-all)

    for status in Playing Paused; do
        for player in "${players[@]}"; do
            if [[ $(playerctl --player="$player" status 2>/dev/null) == "$status" ]]; then
                printf '%s\n' "$player"
                return 0
            fi
        done
    done

    if ((${#players[@]})); then
        printf '%s\n' "${players[0]}"
        return 0
    fi

    return 1
}

player=$(select_player) || exit 1

case $1 in
    status)
        playerctl --player="$player" status
        ;;
    metadata)
        playerctl --player="$player" metadata --format '{{artist}} - {{title}}'
        ;;
    play-pause|previous|next)
        playerctl --player="$player" "$1"
        ;;
    *)
        printf 'Usage: %s {status|metadata|play-pause|previous|next}\n' "$0" >&2
        exit 2
        ;;
esac
