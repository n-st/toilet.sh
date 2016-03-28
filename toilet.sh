#!/bin/sh

# toilet.sh
#  An incomplete reimplementation of the TOIlet text-to-ASCII-art converter,
#  written completely in (hopefully) POSIX-compliant shell script.

# Copyright 2016 n.st (https://github.com/n-st/) and izabera (irc.freenode.net/#bash)
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
                figlet_font_directory="$2"
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


if [ -z "$figlet_font_directory" ]
then
    printf '%s\n' "No font specified. Aborting." 1>&2
    exit 1
fi

if [ ! -d "$figlet_font_directory" ]
then
    printf '%s\n' "Font directory '$figlet_font_directory' does not exit. Aborting." 1>&2
    exit 1
fi

paste -d'\0' $(
    # for each input letter:
    printf '%s\n' "$input_string" | sed -e 's/./&\
/g' |
    while read -r letter
    do
        [ "$letter" ] || continue

        # determine its ascii value
        letter_ord=$(printf '%d\n' \'"$letter")

        printf '%s\n' "${figlet_font_directory}/${letter_ord}.letter"

    done
)
