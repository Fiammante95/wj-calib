#include <Arduino.h>
#include <Acquisition.h>

AnalogDigitalConverter::AnalogDigitalConverter()
{
  timer = 0;
  fsamp = 0;
  val = 0;
}

void AnalogDigitalConverter::timeSync()
{
  unsigned long deltaT = 1000000/fsamp;
  unsigned long currTime = micros();
  long timeToDelay = deltaT - (currTime - timer);
  if (timeToDelay > deltaT)
  {
    delay(timeToDelay / 1000);
    delayMicroseconds(timeToDelay % 1000);
  }
  else if (timeToDelay > 0)
  {
    delayMicroseconds(timeToDelay);
  }
  else
  {
      // timeToDelay is negative so we start immediately
  }
  timer = currTime + timeToDelay;
}

void AnalogDigitalConverter::sendToPC(int* data)
{
  byte* byteData = (byte*)(data);
  Serial.write(byteData, 2);
}

void AnalogDigitalConverter::sendToPC(double* data)
{
  byte* byteData = (byte*)(data);
  Serial.write(byteData, 4);
}
