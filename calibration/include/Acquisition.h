#include <Arduino.h>

struct AnalogDigitalConverter
{
  AnalogDigitalConverter();
  unsigned long timer;
  int fsamp;
  int val;
  void timeSync();
  void sendToPC(int* data);
  void sendToPC(double* data);

};
