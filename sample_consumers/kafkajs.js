const { Kafka } = require('kafkajs');
const avro = require('avro-js');

const kafka = new Kafka({
  clientId: '742ccee8-503c-4141-b35b-57157501c443',
  // clientId: '2af312cb-e7ec-4a61-bd77-5c089cbffbe5',
  brokers: ['apic1-egw-event-gw-client-cp4i.apps.ocp46.tec.uk.ibm.com:443'],
  ssl: {
    rejectUnauthorized: false,
    ca: '/Users/stefancooper/Documents/GitHub/testfestq3/src/certs/techjamgw.pem'
  },
  sasl: {
    mechanism: 'plain',
    username: '6086a41aab1e79b348bdb3c9b0b45b19',
    password: 'fca4260e6baac98e0ae54cda64db2228'
  }
});

const topic = 'FLIGHT.LANDINGS';
// const topic = 'FLIGHT.TAKEOFFS'
const consumer = kafka.consumer({ groupId: Math.floor(Math.random()*1000).toString() });
const payloadType = avro.parse('/Users/stefancooper/Documents/GitHub/eem-demo-datagen/events/flightlandings.avsc');

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