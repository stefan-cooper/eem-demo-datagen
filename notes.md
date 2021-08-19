```sh
docker build -t eem-demo-datagen .

docker run \
    --env-file=docker-env \
    --mount type=bind,source=/location/of/your/kafka/truststore.p12,target=/app/cas/cert.p12,readonly \
    eem-demo-datagen
```
