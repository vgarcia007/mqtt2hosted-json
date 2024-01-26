#!/bin/bash

# Output directory for JSON files
OUTPUT_DIR="/app/output"

# MQTT settings
CA_FILE="/app/certs/ca.crt"
CERT_FILE="/app/certs/freilinger.crt"
KEY_FILE="/app/certs/freilinger.key"
MQTT_HOST="mqtt.iot.komro.net"
MQTT_PORT=8883
MQTT_TOPIC="#"

# Subscribe to MQTT topic and save values to JSON files
mosquitto_sub --cafile $CA_FILE --cert $CERT_FILE --key $KEY_FILE -h $MQTT_HOST -p $MQTT_PORT -k 30 -v -t $MQTT_TOPIC | 
while IFS= read -r line; do
    # Extract the relevant data from MQTT message
    devEui=$(echo "$line" | jq -r '.devEui')
    timestamp=$(date +%s)
    
    # Loop through the keys in the "object" field
    keys=$(echo "$line" | jq -r '.object | keys_unsorted[]')

    # Create and save JSON files for each key
    for key in $keys; do
        value=$(echo "$line" | jq -r ".object[\"$key\"]")

        # Create JSON content
        json_content="{\"$key\": \"$value\", \"timestamp\": \"$timestamp\"}"

        # Save to a file
        echo "$json_content" > "$OUTPUT_DIR/$devEui-$key.json"
    done
done
