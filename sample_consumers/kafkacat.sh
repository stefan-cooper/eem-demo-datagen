kafkacat -J -G "1" \
  -b "<eem_gateway_endpoint>" \
  -X client.id="<client_id_for_api>" \
  -X security.protocol="SASL_SSL" \
  -X ssl.ca.location="<path_to_gw_cert>.pem" \
  -X sasl.mechanisms="PLAIN" \
  -X sasl.username="<subscribed_app_api_key>" \
  -X sasl.password="<subscribed_app_api_secret>" \
  -X auto.offset.reset="earliest" \
  "FLIGHT.TAKEOFFS"