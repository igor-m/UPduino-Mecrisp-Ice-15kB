// Example: An sketch for generating 4 random pulse trains
// Used with UPduino Mecrisp-Ice j1a CPU interrupts testing
// J1a: 4 rising edge interrupts driven by the PA0-PA3 outputs
// Tested with BluePill under stm32duino
// Provided as-is
// No warranties of any kind are provided
// IgorM 6-Feb-2018

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

GPIOA->regs->ODR = 0;                   // all 4 outputs low

delay(3000);
Serial.begin(115200);
Serial.println("START in 10secs..");

delay(10000);                           // in this time you must start the Forth's side

Serial.println("Generating..");

int32_t i;
int32_t pattern;
uint32_t counter0 = 0;
uint32_t counter1 = 0;
uint32_t counter2 = 0;
uint32_t counter3 = 0;

for( i=0; i<1000000; i++ ){

  delayMicroseconds(5);                 // 100kHz max events rate

  pattern = random(16) & 0x0F;          // generate a random pattern - 4 bits

  GPIOA->regs->ODR = pattern;           // issue all 4 bits at once

  if (pattern & 0x01) counter0++;       // count the pulses
  if (pattern & 0x02) counter1++;
  if (pattern & 0x04) counter2++;
  if (pattern & 0x08) counter3++;

  delayMicroseconds(5);

  GPIOA->regs->ODR = 0;                 // clear all 4 bits

    }

Serial.print("END.. ");                     // print out the numbers of pulses for each INTR
Serial.print(counter0); Serial.print(" ");
Serial.print(counter1); Serial.print(" ");
Serial.print(counter2); Serial.print(" ");
Serial.println(counter3);

}


void loop() {
}

// START in 10secs..
// Generating..
// END.. 500430 499213 500949 499856

