#!/bin/bash

# Set the public directory path and Discord webhook URL
PUBLIC_DIR="/app/public"
DISCORD_WEBHOOK_URL=""

# Get the current year and month
YEAR_MONTH=$(date +"%Y-%m")

# Define the file name and marker file
FILE_NAME="${YEAR_MONTH}.xlsx"
MARKER_FILE="${PUBLIC_DIR}/${FILE_NAME}.sent"

# Full path to the file
FILE_PATH="${PUBLIC_DIR}/${FILE_NAME}"

# Check if the file exists and hasn't been sent before
if [ -f "$FILE_PATH" ]; then
    if [ -f "$MARKER_FILE" ]; then
        echo "File $FILE_NAME has already been sent. Skipping."
    else
        echo "File $FILE_NAME found and not sent before. Sending to Discord..."

        # Use curl to send the file and capture the HTTP status code
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
            -H "Content-Type: multipart/form-data" \
            -F "file=@${FILE_PATH}" \
            "$DISCORD_WEBHOOK_URL")

        # Check if the status code indicates success
        if [ "$HTTP_STATUS" -eq 200 ]; then
            echo "File $FILE_NAME sent successfully."

            # Create the marker file to indicate the file was sent
            touch "$MARKER_FILE"
        else
            echo "Failed to send file $FILE_NAME. Response: $RESPONSE"
        fi
    fi
else
    echo "File $FILE_NAME does not exist. Nothing to send."
fi
