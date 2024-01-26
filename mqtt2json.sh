#!/bin/bash

# Output directory for JSON files
OUTPUT_DIR="/app/output"

# MQTT settings
CA_FILE="/app/certs/ca.crt"
CERT_FILE="/app/certs/client.crt"
KEY_FILE="/app/certs/client.key"
MQTT_HOST="mqtt.iot.komro.net"
MQTT_PORT=8883
MQTT_TOPIC="#"

# Subscribe to MQTT topic and save values to JSON files
mosquitto_sub --cafile $CA_FILE --cert $CERT_FILE --key $KEY_FILE -h $MQTT_HOST -p $MQTT_PORT -k 30 -t $MQTT_TOPIC | 
while IFS= read -r line; do
    # Extract the relevant data from MQTT message
    echo "got message"
    echo "Content of \$line: $line"
    sanitized_line=$(echo $line | tr -cd '[:print:]')
    echo "Content of \$sanitized_line: $sanitized_line"

    devEui=$(echo '$sanitized_line' | jq -r '.devEui')
    timestamp=$(date +%s)
    
    # Loop through the keys in the "object" field
    keys=$(echo '$sanitized_line' | jq -r '.object | keys_unsorted[]')
    echo "$keys"

    # Create and save JSON files for each key
    for key in $keys; do
        value=$(echo '$sanitized_line' | jq -r ".object[\"$key\"]")
        echo "$key: $value"

        # Create JSON content
        json_content="{\"$key\": \"$value\", \"timestamp\": \"$timestamp\"}"

        # Save to a file
        echo "$json_content" > "$OUTPUT_DIR/$devEui-$key.json"
    done
done
