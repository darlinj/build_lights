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
String current_status = "";
String last_status = "other";

// query spacing managment
const unsigned long request_period = 5000;
unsigned long last_connected = 0;
boolean http_connected = false;

//leds - These need to be not pins 10,11, or 12 because the eternet sheild uses those. 
//     - Also not pins 0 and 1 as these are "special"
int green = 2;
int red = 3;

void setup() {

  pinMode(red, OUTPUT);     
  pinMode(green, OUTPUT);     
 // Open serial communications and wait for port to open:
  Serial.begin(9600);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  
  Serial.println("Starting");
 
  Serial.println("Init network");  
  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {

    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;)
      ;
  }
  
  // give the Ethernet shield a second to initialize:
  delay(1000);

  Serial.println("Configured network");

}

void loop()
{
  if (!client.connected() && (millis() - last_connected > request_period)){
    http_connect();
  }
  
  if (client.available()) {
    consume_character();
  }

   light_the_lights();

  // if the server's disconnected, stop the client:
  if (http_connected && !client.connected()) {
    receiving_body = false;
    last_status = current_status;
    current_status = "";
    http_disconnect();
  }
}

void light_the_lights(){
  if(last_status == "red"){
    digitalWrite(red, HIGH);
    digitalWrite(green, LOW);
  }
  else { 
    if(last_status == "green"){
      digitalWrite(green, HIGH);
      digitalWrite(red, LOW);
    }
    else {
      digitalWrite(green, LOW);
      digitalWrite(red, LOW);
    }
  }
}

void consume_character(){
  char c = client.read();
  add_to_buffer(c);
  if(receiving_body == true){
   current_status += c;
  }
  if(strcmp(buffer,"\r\n\r\n") == 0) {
    receiving_body = true;
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
    Serial.println("Status is " + last_status);
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
