#include <Arduino.h>
#include <testlib.h>

void toggle(int pin)
{
  digitalWrite(pin,!digitalRead(pin));
}
