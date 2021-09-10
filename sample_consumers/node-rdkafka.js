const kafka = require('node-rdkafka');

let driver_options = {
  'metadata.broker.list': ['<eem_gateway_endpoint>'],
  'security.protocol': 'SASL_SSL',
  'ssl.ca.location':'<path_to_gw_cert>.pem',
  'sasl.mechanism': 'PLAIN',
  'sasl.username': '<subscribed_app_api_key>',
  'sasl.password': '<subscribed_app_api_secret>',
  'client.id': '<client_id_for_api>',
  'group.id': '1'
};

let topic_options = {}

let consumer = new kafka.KafkaConsumer(driver_options, topic_options);

consumer.connect(null, function(err) {
  if (err !== null) {
    console.log("ERROR: " + err);
  }
});

consumer.on('ready', function(arg) {
  consumer.subscribe(["FLIGHT.TAKEOFFS"]);
  consumer.consume();
});

consumer.on('data', function(data) {
  const { value, topic, partition, key, offset } = data
  console.log({
    topic,
    partition,
    offset,
    key,
    value: value.toString()
  })
});

consumer.on('disconnect', function() {
  console.log('consumer disconnected')
});