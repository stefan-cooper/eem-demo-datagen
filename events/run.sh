#!/bin/bash

echo "----------------------------------------------------------------------"
echo "UPDATING CONFIG..."
echo "----------------------------------------------------------------------"
echo " bootstrap address: "
echo "  $BOOTSTRAP_ADDRESS"
echo " username:"
echo "  $KAFKA_USERNAME"
echo " password:"
echo "  $KAFKA_PASSWORD"
echo " truststore password:"
echo "  $SSL_PASSWORD"
echo " weather API key:"
echo "  $WEATHER_APIKEY"
echo " alphavantage API key:"
echo "  $STOCK_APIKEY"
echo "----------------------------------------------------------------------"

echo "Creating Connect config"
cp ./connect-configs/connect-config.template ./connect-configs/connect-config.properties
sed -i "s/%BOOTSTRAP_ADDRESS%/$BOOTSTRAP_ADDRESS/g" ./connect-configs/connect-config.properties
sed -i "s/%USERNAME%/$KAFKA_USERNAME/g"             ./connect-configs/connect-config.properties
sed -i "s/%PASSWORD%/$KAFKA_PASSWORD/g"             ./connect-configs/connect-config.properties
sed -i "s/%SSL_PASSWORD%/$SSL_PASSWORD/g"           ./connect-configs/connect-config.properties
echo ""

echo "Updating Connector configs"
sed -i "s/%PASSWORD%/$WEATHER_APIKEY/g" ./connector-configs/weather-*
sed -i "s/%PASSWORD%/$STOCK_APIKEY/g" ./connector-configs/stock-*
echo ""

echo "----------------------------------------------------------------------"
echo "Starting Kafka Connect....."

CLASSPATH=/app/kafka_2.13-2.8.0/libs/*:/app/jars/* /app/kafka_2.13-2.8.0/bin/connect-standalone.sh \
    /app/connect-configs/connect-config.properties \
    /app/connector-configs/weather-armonk \
    /app/connector-configs/weather-hursley \
    /app/connector-configs/weather-northharbour \
    /app/connector-configs/weather-paris \
    /app/connector-configs/weather-southbank \
    /app/connector-configs/flight-landings \
    /app/connector-configs/flight-takeoffs \
    /app/connector-configs/stock-apple \
    /app/connector-configs/stock-google \
    /app/connector-configs/stock-ibm \
    /app/connector-configs/stock-microsoft \
    /app/connector-configs/stock-salesforce
