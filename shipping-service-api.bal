import ballerina/http;
import ballerina/log;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/os;


final string dbservice = os:getEnv("DB_SERVICE");
final mysql:Client dbClient = check new(host = dbservice, user = "root", password = "password", port = 3306);

service /shipping on new http:Listener(9090) {

    resource function get shippingPrice/[string city](http:Caller caller, http:Request req) returns error? {
        sql:ParameterizedQuery query = `SELECT shippingPrice FROM booksdb.shipping WHERE city=${city}`;
        stream<record {}, error?> resultst = dbClient->query(query);

        boolean isFound = false;
        check resultst.forEach(function(record {} result) {
            isFound = true;
            json shippingInfo = {
                city : city,
                shippingPrice : result["shippingPrice"].toString()
            };

            error? response = caller->respond(shippingInfo);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        });

        if !isFound {
            http:Response err = new;
            err.statusCode = http:STATUS_NOT_FOUND;
            err.setPayload("Delivery unavailable for shipping address");
            error? response = caller->respond(err);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        }
    }
}
