# overview

Two Docker images are available
- one runs Kafka producers that each produces stream of events to a Kafka cluster that you set up:
    - flight takeoff and landing events
        - frequency: every few seconds
        - topics: FLIGHT.LANDINGS, FLIGHT.TAKEOFFS
    - stock prices for tech companies
        - frequency: every minute
        - topics: STOCK.APPLE, STOCK.GOOGLE, STOCK.IBM, STOCK.MICROSOFT, STOCK.SALESFORCE
    - weather conditions at IBM locations
        - frequency: every 15 minutes
        - topics: WEATHER.ARMONK, WEATHER.HURSLEY, WEATHER.NORTHHARBOUR, WEATHER.PARIS, WEATHER.SOUTHBANK
- one hosts REST APIs

These are used in demos of Event Endpoint Management to provide "real" APIs that can be managed.

## setting up sources for Kafka APIs

1. Deploy an instance of ES on-prem
    * enable SCRAM-secured external listeners
    * sample in [specs](https://github.com/dalelane/eem-demo-datagen/blob/main/specs/eventstreams/kafka.yaml) folder to help - _note that the sample uses ephemeral storage_
2. Create the following topics (you could just rely on auto topic create, but creating them lets you choose the retention which is helpful)
    * samples in [specs](https://github.com/dalelane/eem-demo-datagen/blob/main/specs/eventstreams/topics.yaml) folder to help
    - FLIGHT.LANDINGS
    - FLIGHT.TAKEOFFS
    - WEATHER.ARMONK
    - WEATHER.HURSLEY
    - WEATHER.NORTHHARBOUR
    - WEATHER.PARIS
    - WEATHER.SOUTHBANK
    - STOCK.APPLE
    - STOCK.GOOGLE
    - STOCK.IBM
    - STOCK.MICROSOFT
    - STOCK.SALESFORCE
3. Create SCRAM credentials with permissions to publish to those topics
    * sample in [specs](https://github.com/dalelane/eem-demo-datagen/blob/main/specs/eventstreams/user.yaml) folder to help - _note that it creates an all-access API key_
4. Download the p12 CA for your ES cluster
5. Create a `docker-env` file based on the [template](https://github.com/dalelane/eem-demo-datagen/blob/main/sample-docker-env) and update it with the details for your ES cluster
    * _you'll need API keys for the Weather Company API and AlphaVantage API to get it to run_
6. Run the data generator
    * replace `/location/of/your/es-cert.p12` with the absolute location of your file from step 4
```sh
docker run -d --env-file=docker-env \
    --mount type=bind,source=/location/of/your/es-cert.p12,target=/app/cas/cert.p12,readonly \
    quay.io/dale-lane/eem-demo-datagen
```
7. Create AsyncAPIs in EEM
    * samples in [specs](https://github.com/dalelane/eem-demo-datagen/tree/main/specs/asyncapi) folder to help

## setting up sources for REST APIs

1. Run the API server
    * using the same `docker-env` file from the above instructions (only the WEATHER_APIKEY value is used)
    * modifying the external port if you need to
```sh
docker run -d --env-file=docker-env \
    -p 1880:1880 \
    quay.io/dale-lane/eem-demo-apis
```

2. Create OpenAPIs in EEM
    * samples in [specs](https://github.com/dalelane/eem-demo-datagen/tree/main/specs/openapi) folder to help
