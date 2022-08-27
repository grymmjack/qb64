cd "$(dirname "$0")"
./wiki-ex1 &
osascript -e 'tell application "Terminal" to close (every window whose name contains "wiki-ex1_start.command")' &
osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
exit
