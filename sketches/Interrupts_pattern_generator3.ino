// Example: An sketch for generating 4 random concurrent pulse trains
// Used with UPduino Mecrisp-Ice j1a CPU interrupts testing
// J1a: 4 rising edge interrupts driven by the PA0-PA3 outputs
// Tested with BluePill under stm32duino
// Provided as-is
// No warranties of any kind are provided
// IgorM 8-Feb-2018

#include "Arduino.h"

#define INT0 PA0
#define INT1 PA1
#define INT2 PA2
#define INT3 PA3

void setup()
{
pinMode(INT0, OUTPUT);
pinMode(INT1, OUTPUT);
pinMode(INT2, OUTPUT);
pinMode(INT3, OUTPUT);

GPIOA->regs->ODR = 0;

delay(3000);
Serial.begin(115200);
Serial.println("START in 10secs..");

delay(10000);

Serial.println("Generating 100 million 4bit patterns..");

uint32_t i;
uint32_t counter0 = 0;
uint32_t counter1 = 0;
uint32_t counter2 = 0;
uint32_t counter3 = 0;
uint32_t p0 = 0;
uint32_t p1 = 0;

for( i=0; i<100000000; i++ ){

 GPIOA->regs->ODR = p0;  // send the pattern

 delayMicroseconds(2);

  p1 = random(16) & 0x0F;

 GPIOA->regs->ODR = p1;  // send the pattern

 delayMicroseconds(2);

 // detect the rising edge of the signals

  if ( !(p0 & 0x01) && (p1 & 0x01) ) counter0++;
  if ( !(p0 & 0x02) && (p1 & 0x02) ) counter1++;
  if ( !(p0 & 0x04) && (p1 & 0x04) ) counter2++;
  if ( !(p0 & 0x08) && (p1 & 0x08) ) counter3++;

  p0 = p1;

}

Serial.print("END.. ");
Serial.print(counter0); Serial.print(" ");
Serial.print(counter1); Serial.print(" ");
Serial.print(counter2); Serial.print(" ");
Serial.println(counter3);

}

void loop() {
}

// START in 10secs..
// Generating 100 million 4bit patterns..
// END.. 24999042 24996164 24999905 25000560

