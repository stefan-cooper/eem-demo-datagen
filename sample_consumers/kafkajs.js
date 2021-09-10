const { Kafka } = require('kafkajs');
const avro = require('avro-js');

const kafka = new Kafka({
  clientId: '<client_id_for_api>',
  brokers: ['<eem_gateway_endpoint>'],
  ssl: {
    ca: '<path_to_gw_cert>.pem'
  },
  sasl: {
    mechanism: 'plain',
    username: '<subscribed_app_api_key>',
    password: '<subscribed_app_api_secret>'
  }
});

const topic = 'FLIGHT.TAKEOFFS'
const consumer = kafka.consumer({ groupId: Math.floor(Math.random()*1000).toString() });

const startConsumer = async () => {
  await consumer.connect();
  await consumer.subscribe({ topic, fromBeginning: true });
 
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        topic,
        partition,
        offset: message.offset,
        key: message.key,
        value: message.value.toString()
      })
    },
  })
}
 
startConsumer().catch(console.error)