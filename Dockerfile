# Use a base image with the required tools (jq, mosquitto-clients)
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y jq mosquitto-clients && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Create the output directory
RUN mkdir output

# Copy the .htaccess file into the container
#COPY output/.htaccess /app/output/.htaccess

# Copy the script into the container
COPY mqtt2json.sh /app/mqtt2json.sh

# Make the script executable
RUN chmod +x /app/mqtt2json.sh

# Entrypoint for the script
CMD ["/app/mqtt2json.sh"]