#!/bin/bash

echo "----------------------------------------------------------------------"
echo "UPDATING CONFIG..."
echo "----------------------------------------------------------------------"
echo " bootstrap address: "
echo "  $BOOTSTRAP_ADDRESS"
echo " truststore password:"
echo "  $SSL_PASSWORD"
echo "----------------------------------------------------------------------"

echo "Creating Connect config"
cp ./connect-configs/connect-config.template ./connect-configs/connect-config.properties
sed -i "s/%BOOTSTRAP_ADDRESS%/$BOOTSTRAP_ADDRESS/g" ./connect-configs/connect-config.properties
sed -i "s/%SSL_PASSWORD%/$SSL_PASSWORD/g"           ./connect-configs/connect-config.properties
echo ""

echo "----------------------------------------------------------------------"
echo "Starting Kafka Connect....."

CLASSPATH=/app/kafka_2.13-2.8.0/libs/*:/app/jars/* /app/kafka_2.13-2.8.0/bin/connect-standalone.sh \
    /app/connect-configs/connect-config.properties \
    /app/connector-configs/flight-landings \
    /app/connector-configs/flight-takeoffs \
