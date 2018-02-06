// Example: An sketch for generating 4 random pulse trains
// Used with UPduino Mecrisp-Ice j1a CPU interrupts testing
// J1a: 4 rising edge interrupts driven by the PA1-PA4 outputs
// Tested with BluePill under stm32duino
// Provided as-is
// No warranties of any kind are provided
// IgorM 6-Feb-2018

#include "Arduino.h"

#define INT0 PA1
#define INT1 PA2
#define INT2 PA3
#define INT3 PA4

void setup() {

pinMode(INT0, OUTPUT);
pinMode(INT1, OUTPUT);
pinMode(INT2, OUTPUT);
pinMode(INT3, OUTPUT);

digitalWrite(INT0, LOW);
digitalWrite(INT1, LOW);
digitalWrite(INT2, LOW);
digitalWrite(INT3, LOW);

delay(3000);
Serial.begin(115200);

Serial.println("START in 5secs..");
delay(5000);
Serial.println("Generating..");

int32_t i;

for( i=1; i<1000000; i++ ){

  delayMicroseconds(10+random(100));
  digitalWrite(INT1, HIGH);
  delayMicroseconds(10+random(100));
  digitalWrite(INT3, HIGH);
  delayMicroseconds(10+random(100));
  digitalWrite(INT0, HIGH);
  delayMicroseconds(10+random(100));
  digitalWrite(INT2, HIGH);

  delayMicroseconds(10+random(100));
  digitalWrite(INT0, LOW);
  delayMicroseconds(10+random(100));
  digitalWrite(INT3, LOW);
  delayMicroseconds(10+random(100));
  digitalWrite(INT1, LOW);
  delayMicroseconds(10+random(100));
  digitalWrite(INT2, LOW);
}

Serial.println("END..");

}

void loop() {
}
