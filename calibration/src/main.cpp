#include <Arduino.h>
#include <testlib.h>

void setup() {
  // put your setup code here, to run once:

  pinMode(2,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(500);
  toggle(2);
}
