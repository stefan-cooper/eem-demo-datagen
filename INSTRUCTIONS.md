# setting up sources for Kafka APIs

1. Deploy an instance of ES on-prem
    * enable SCRAM-secured external listeners
2. Create the following topics (you could just rely on auto topic create, but creating them lets you choose the retention which is helpful)
    - WEATHER.ARMONK
    - WEATHER.HURSLEY
    - WEATHER.NORTHHARBOUR
    - WEATHER.PARIS
    - WEATHER.SOUTHBANK
3. Create SCRAM credentials with permissions to publish to those topics
4. Download the p12 CA for your ES cluster
5. Create a `docker-env` file based on the [template](https://github.com/dalelane/eem-demo-datagen/blob/main/sample-docker-env) and update it with the details for your ES cluster
    * _you'll need an API key for the Weather Company API to get it to run_
6. Run the data generator
    * replace `/location/of/your/es-cert.p12` with the absolute location of your file from step 4
```sh
docker run \
    -d \
    --env-file=docker-env \
    --mount type=bind,source=/root/cas/es-cert.p12,target=/location/of/your/es-cert.p12,readonly \
    quay.io/dale-lane/eem-demo-datagen:latest
```
7. Create AsyncAPIs in EEM
    * samples in [specs](https://github.com/dalelane/eem-demo-datagen/tree/main/specs/asyncapi) folder to help

# setting up sources for REST APIs

1. Run the API server
    * using the same `docker-env` file from the above instructions (only the WEATHER_APIKEY value is used)
    * modifying the external port if you need to
```sh
docker run \
    -d \
    --env-file=docker-env \
    -p 1880:1880 \
    quay.io/dale-lane/eem-demo-apis:latest
```

2. Create OpenAPIs in EEM
    * samples in [specs](https://github.com/dalelane/eem-demo-datagen/tree/main/specs/openapi) folder to help
