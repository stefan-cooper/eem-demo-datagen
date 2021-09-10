// Requires to be used in a java project / env

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.CommonClientConfigs;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.config.SslConfigs;

public class SampleApplication {
  public static final void main(String args[]) {  
    Properties props = new Properties();

    props.put("bootstrap.servers", "<eem_gateway_endpoint>");
    props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
    props.put("value.deserializer", "org.apache.kafka.common.serialization.ByteArrayDeserializer");
    props.put("auto.offset.reset", "earliest");

    props.put("group.id", "1");
    props.put("client.id", "<client_id_for_api>");

    props.put(CommonClientConfigs.SECURITY_PROTOCOL_CONFIG, "SASL_SSL");

    props.put(SaslConfigs.SASL_MECHANISM, "PLAIN");
    props.put(SaslConfigs.SASL_JAAS_CONFIG, "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"<subscribed_app_api_key>\" password=\"<subscribed_app_api_secret>\";");

    props.put(SslConfigs.SSL_TRUSTSTORE_LOCATION_CONFIG, "<path_to_gw_cert>.p12");
    props.put(SslConfigs.SSL_TRUSTSTORE_PASSWORD_CONFIG, "<p12_password>");
    props.put(SslConfigs.SSL_TRUSTSTORE_TYPE_CONFIG, "PKCS12");

    KafkaConsumer consumer = new KafkaConsumer<String, byte[]>(props);
    consumer.subscribe(Collections.singletonList("FLIGHT.TAKEOFFS"));
    try {
      while(true) {
        ConsumerRecords<String, byte[]> records = consumer.poll(Duration.ofSeconds(1));
        for (ConsumerRecord<String, byte[]> record : records) {
            byte[] value = record.value();
            String key = record.key();
            ObjectMapper om = new ObjectMapper();
            JsonNode jsonNode = om.readTree(value);
            // Do something with your JSON data
            Object somefield = jsonNode.get("flight");
          }
        }
    } catch (Exception e) {
      e.printStackTrace();
      consumer.close();
      System.exit(1);
    }   
  }
}