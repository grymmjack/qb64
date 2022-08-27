cd "$(dirname "$0")"
./CHR_EX &
osascript -e 'tell application "Terminal" to close (every window whose name contains "CHR_EX_start.command")' &
osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
exit
