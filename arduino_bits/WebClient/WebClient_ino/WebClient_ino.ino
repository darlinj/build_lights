#include <SPI.h>
#include <Ethernet.h>

// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress server(10,63,210,232); 

// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
EthernetClient client;

char buffer[5] = "";
boolean receiving_body = false;
String status = "";

// query spacing managment
const unsigned long request_period = 30000;
unsigned long last_connected = 0;
boolean http_connected = false;

void setup() {
 // Open serial communications and wait for port to open:
  Serial.begin(9600);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;)
      ;
  }
  // give the Ethernet shield a second to initialize:
  delay(1000);
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (!client.connected() && (millis() - last_connected > request_period)){
    http_connect();
  }
  
  if (client.available()) {
    char c = client.read();
    add_to_buffer(c);
    if(strcmp(buffer,"\r\n\r\n") == 0) {
      receiving_body = true;
    }
    if(receiving_body == true){
     status += c;
    }
  }

  // if the server's disconnected, stop the client:
  if (http_connected && !client.connected()) {
    receiving_body = false;
    http_disconnect();
    status = "";
  }
}

void add_to_buffer(char c) {
  buffer[0] = buffer[1];
  buffer[1] = buffer[2];
  buffer[2] = buffer[3];
  buffer[3] = c;
}

void http_disconnect(){
    Serial.println("Finished");
    Serial.println(status);
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    http_connected = false;
}

void http_connect(){
  Serial.println("connecting...");

  // if you get a connection, report back via serial:
  if (client.connect(server, 80)) {
    Serial.println("connected");
    // Make a HTTP request:
    client.println("GET / HTTP/1.0");
    client.println();
    http_connected = true;
    last_connected = millis();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }
}
