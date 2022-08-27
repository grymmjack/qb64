cd "$(dirname "$0")"
./QBLOCKS &
osascript -e 'tell application "Terminal" to close (every window whose name contains "QBLOCKS_start.command")' &
osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
exit
