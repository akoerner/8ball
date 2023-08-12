#!/usr/bin/env bash

set -euo pipefail

echoerr (){ printf "%s" "$@" >&2;}
exiterr (){ printf "%s\n" "$@" >&2; exit 1;}

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -f "${SCRIPT_DIRECTORY}/responses.txt" ]; then
    exiterr "Error: responses.txt file not found."
fi


printf_center() {
    local string="$1"
    local terminal_width
    terminal_width=$(tput cols)

    while IFS=$'\n' read -r line; do
        local string_length=${#line}
        local padding_length=$(( (terminal_width - string_length) / 2 ))
        
        printf "\n%*s%s" $padding_length "" "$line"
    done <<< "$string"
}

get_random_number() {
    local min="$1"
    local max="$2"
    curl -s "https://www.random.org/integers/?num=1&min=${min}&max=${max}&col=1&base=10&format=plain&rnd=new"
}

get_total_responses() {
    wc -l < "${SCRIPT_DIRECTORY}/responses.txt"
}

think(){
    random_think_number="$(get_random_number 1 5)"
    smoke=$(cat "${SCRIPT_DIRECTORY}/smoke.txt")

    printf_center "${smoke}"
    printf_center "Consulting the ether..."
    random_line_number="$(get_random_number 1 $(get_total_responses))"
    for (( i=1; i<=random_think_number; i++ )); do
        sleep 1
        echo -n "."
    done
    clear
    printf_center "Answer has become clear..."
    sleep 2s
    message=$(sed "${random_line_number}q;d" "${SCRIPT_DIRECTORY}/responses.txt")
    echo ""
    _8ball="$(cat "${SCRIPT_DIRECTORY}/8ball.txt")"
    printf_center "${_8ball}"
    echo ""
    printf_center "${message}"
    echo ""
}

think
