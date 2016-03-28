#!/bin/sh

# toilet.sh
#  An incomplete reimplementation of the TOIlet text-to-ASCII-art converter,
#  written completely in (hopefully) POSIX-compliant shell script.

# Copyright 2016 n.st (https://github.com/n-st/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


while [ $# -gt 0 ]
do
    key="$1"

    case $key in
        -f)
            if [ $# -gt 1 ]
            then
                figlet_font_file="$2"
                shift # past argument
            fi
            ;;
        *)
            if [ -n "$input_string" ]
            then
                input_string="$input_string $1"
            else
                input_string="$1"
            fi
        ;;
    esac
    shift # past argument or value
done


if [ -z "$figlet_font_file" ]
then
    printf '%s\n' "No font file specified. Aborting." 1>&2
    exit 1
fi

if [ ! -f "$figlet_font_file" ]
then
    # Maybe the user gave us the font name instead of the full path?
    # Try a few default paths and extensions:
    if [ -f "/usr/share/figlet/${figlet_font_file}.flf" ]
    then
        figlet_font_file="/usr/share/figlet/${figlet_font_file}.flf"
    fi
    if [ -f "/usr/share/figlet/${figlet_font_file}.tlf" ]
    then
        figlet_font_file="/usr/share/figlet/${figlet_font_file}.tlf"
    fi
fi

if [ ! -f "$figlet_font_file" ]
then
    printf '%s\n' "Font file '$figlet_font_file' does not exit. Aborting." 1>&2
    exit 1
fi


# parse figlet header
figlet_header=$(head -n 1 "$figlet_font_file")
figlet_signature=$(printf '%.5s' "$figlet_header")
if [ "$figlet_signature" != "flf2a" ] && [ "$figlet_signature" != "tlf2a" ]
then
    printf '%s\n' "Input file is neither a FIGlet font nor a TOIlet font. Aborting." 1>&2
    exit 1
fi
# get character height
character_height=$(printf '%s\n' "$figlet_header" | cut -f 2 -d ' ')
# get nosmush letter
hardblank=$(printf '%.6s' "$figlet_header" | tail -c 1)
# get comment line count
comment_linecount=$(printf '%s\n' "$figlet_header" | cut -f 6 -d ' ')


# for each letter representation line
i=0; while [ "$i" -lt $character_height ]
do
    # for each input letter:
    printf "$input_string" | sed -e 's/\(.\)/\1\
/g' | \
    while IFS= read -r letter
    do
        # determine its ascii value
        letter_ord=$(printf '%d\n' \'"$letter")

        # letters start at ASCII code 32 (space) and linearly continue up to 126 (~)
        [ $letter_ord -lt 32 ] || [ $letter_ord -gt 126 ] && continue

        # determine the starting offset for the matching figlet letter
        # start_offset = 1 line offset for `tail -n +x` + 1 header line + x comment lines + <however many letter there are before our required letter> + <which representation line we're currently printing>
        start_offset=$((1+1+comment_linecount+((letter_ord-32)*character_height)+i))

        letter_line=$(tail -n "+$start_offset" "$figlet_font_file" | head -n 1)

        # get terminator character (rightmost char in all letter lines)
        terminator_char=$(printf '%s' "$letter_line" | tail -c 1)

        printf '%s' "$letter_line" | sed "s/[${terminator_char}]//g;s/[$hardblank]/ /g"

    done | tr -d '\n'

    printf '\n'

    i=$((i+1))
done
