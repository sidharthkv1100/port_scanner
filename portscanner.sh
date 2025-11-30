if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <target_ip_or_domain> <start_port> <end_port>"
    exit 1
fi

TARGET=$1
START_PORT=$2
END_PORT=$3

# Validate that start and end ports are numbers
if ! [[ "$START_PORT" =~ ^[0-9]+$ ]] || ! [[ "$END_PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: start_port and end_port must be numbers."
    exit 1
fi

if [ "$START_PORT" -lt 1 ] || [ "$END_PORT" -gt 65535 ] || [ "$START_PORT" -gt "$END_PORT" ]; then
    echo "Error: Port range must be between 1 and 65535 and start_port <= end_port."
    exit 1
fi

echo "Scanning $TARGET from port $START_PORT to $END_PORT..."
echo

for (( PORT=$START_PORT; PORT<=$END_PORT; PORT++ ))
do
    # Try connecting using bash's /dev/tcp feature
    timeout 1 bash -c "echo >/dev/tcp/$TARGET/$PORT" 2>/dev/null

    if [ $? -eq 0 ]; then
    echo "Port $PORT is OPEN"
else
    echo "Port $PORT is CLOSED"
    fi
done

echo
echo "Scan complete."
