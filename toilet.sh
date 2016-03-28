#!/bin/sh

figlet_font_file="/usr/share/figlet/smblock.tlf"
input_string="Hello World"

# parse figlet header
figlet_header=$(head -n 1 "$figlet_font_file")
figlet_signature=$(printf '%s\n' "$figlet_header" | head -c 5)
if [ "$figlet_signature" != "flf2a" ] && [ "$figlet_signature" != "tlf2a" ]
then
    printf "Input file is neither a FIGlet font nor a TOIlet font. Aborting." 1>&2
    exit 1
fi
# get character height
character_height=$(printf '%s\n' "$figlet_header" | cut -f 2 -d ' ')
# get nosmush letter
hardblank=$(printf '%s\n' "$figlet_header" | head -c 6 | tail -c 1)
# get comment line count
comment_linecount=$(printf '%s\n' "$figlet_header" | cut -f 6 -d ' ')

# for each letter representation line
i=0; while [ "$i" -lt $character_height ]
do
    current_line=""

    # for each input letter:
    while IFS= read -r letter
    do
        # determine its ascii value
        letter_ord=$(printf '%d\n' \'"$letter")

        # letters start at ASCII code 32 (space) and linearly continue up to 126 (~)
        [ $letter_ord -lt 32 ] || [ $letter_ord -gt 126 ] && continue

        # determine the starting offset for the matching figlet letter
        # start_offset = 1 line offset for `tail -n +x` + 1 header line + x comment lines + <however many letter there are before our required letter> + <which representation line we're currently printing>
        start_offset=$((1+1+comment_linecount+((letter_ord-32)*character_height)+i))

        current_line="$current_line"$(tail -n "+$start_offset" "$figlet_font_file" | head -n 1)

    done <<EOF
$(printf "$input_string" | sed -e 's/\(.\)/\1\
/g')
EOF

    # get terminator character (rightmost char in all letter lines)
    terminator_char=$(printf '%s' "$current_line" | tail -c 1)

    printf '%s\n' "$current_line" | sed "s/[${terminator_char}]//g;s/[$hardblank]/ /g"

    i=$((i+1))
done
