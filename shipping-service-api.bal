import ballerina/http;
import ballerina/log;

service /shipping on new http:Listener(9090) {

    resource function get shippingPrice/[string city](http:Caller caller, http:Request req) {
        map<json> shippingList = {
            "colombo": {
                city: "colombo",
                shippingPrice: "200"
            },
            "kandy": {
                city: "kandy",
                shippingPrice: "300"
            },
            "matara": {
                city: "matara",
                shippingPrice: "400"
            }
        };

        json shippingDetail = shippingList[city];
        if shippingDetail is () {
            http:Response err = new;
            err.statusCode = http:STATUS_NOT_FOUND;
            err.setPayload("Delivery unavailable for shipping address");
            error? response = caller->respond(err);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        } else {
            error? response = caller->respond(shippingDetail);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        }
    }
}
