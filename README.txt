        _             _   _          _               _
       | |_    ___   (_) | |   ___  | |_       ___  | |__
       | __|  / _ \  | | | |  / _ \ | __|     / __| | '_ \
       | |_  | (_) | | | | | |  __/ | |_   _  \__ \ | | | |
        \__|  \___/  |_| |_|  \___|  \__| (_) |___/ |_| |_|


    ==========================================================

             _          ___   ____    ____   ____   _  __
            /_\        / _ \ / __ \  / __/  /  _/  | |/_/
           / _ \      / ___// /_/ / _\ \   _/ /   _>  <
          /_/ \_\    /_/    \____/ /___/  /___/  /_/|_|

        __         __   __    _____    ___    ___   _         _
  ___  / /  ___   / /  / /   |_   _|  / _ \  |_ _| | |  ___  | |_
 (_-< / _ \/ -_) / /  / /      | |   | (_) |  | |  | | / -_) |  _|
/___//_//_/\__/ /_/  /_/       |_|    \___/  |___| |_| \___|  \__|

              ~~ Prepared font directory branch ~~~


toilet.sh is an incomplete reimplementation of the TOIlet text-to-ASCII-art
converter, written completely in (hopefully) POSIX-compliant shell script.

toilet.sh can read FIGlet and TOIlet font files (.flf, .tlf), based on the
format description at [1].
For the sake of simplicity, it ignores all character composition rules, so it
basically behaves like `toilet -W`.

This branch relies on a pre-created font directory to create the ASCII art.
The directory must be named after the font's name and contain one file per
letter, with a filename of '%d.letter', where %d is the decimal representation
of the letter's ASCII value.

Use `toilet-prepare-font.sh` to create these directories (using the usual -f
parameter).

Supported parameters:
    -f <font file>
        Required. Specifies the font file to use.
        The argument can either be a full path or a font name (which is
        searched for in /usr/share/figlet/).


[1]: https://github.com/Marak/asciimo/issues/3#issuecomment-65028586
