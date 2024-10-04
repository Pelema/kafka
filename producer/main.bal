import ballerina/io;
import ballerina/log;
import ballerinax/kafka;

kafka:ProducerConfiguration producerConfiguration = {
    clientId: "basic-producer",
    acks: "all",
    retryCount: 3
};

kafka:Producer kafkaProducer = check new ("host.docker.internal:9092", producerConfiguration);

public function main() {

    // log:printInfo("Running main function");

    // string[] events = ["Event one", "Event two", "Event three"];

    // foreach string event in events {
    //     do {
    //         log:printInfo("Running loop: " + event);

    //         check kafkaProducer->send({
    //             topic: "quickstart-events",
    //             value: event.toBytes()
    //         });

    //         log:printInfo("Sent event");

    //     } on fail var e {
    //         // io:print("Something went wrong: " + e.message());
    //         log:printError("Something went wrong", 'error = e);

    //     }
    // }

    while (true) {
        string event = io:readln("Enter message to send:");

        if (event == "quit") {
            return;
        }

        do {
            check kafkaProducer->send({
                topic: "quickstart-events",
                value: event.toBytes()
            });
        } on fail var e {
            // io:print("Something went wrong: " + e.message());
            log:printError("Something went wrong", 'error = e);

        }
    }

}
