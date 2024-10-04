import ballerina/io;
import ballerina/log;

// public function main() {
//     io:println("Hello, World!");
// }

import ballerinax/kafka;

kafka:ConsumerConfiguration consumerConfiguration = {
    groupId: "group-id-2",
    topics: ["quickstart-events"],
    pollingInterval: 1,
    autoCommit: false
    // clientId: "new-client"
};

listener kafka:Listener kafkaListener = new (kafka:DEFAULT_URL, consumerConfiguration);

service on kafkaListener {
    remote function onConsumerRecord(kafka:Caller caller, kafka:BytesConsumerRecord[] records) {
        // processes the records
        foreach kafka:BytesConsumerRecord item in records {
            string data = check string:fromBytes(item.value);
            io:println("Received: ", data);
        } on fail var e {
        	log:printError("Error while reading records ", 'error = e);
        }

        // commits the offsets manually
        kafka:Error? commitResult = caller->commit();

        if commitResult is kafka:Error {
            log:printError("Error occurred while committing the offsets for the consumer ", 'error = commitResult);
        }
    }
}