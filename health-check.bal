import ballerina/http;
import ballerina/log;


service / on new http:Listener(9091) {

    isolated resource function get liveness(http:Caller caller, http:Request req) {
        var result = caller->respond("Liveness Check : Success");
        if (result is error) {
            log:printError("Error while responding to shipping-service liveness check", result);
        }
    }
}