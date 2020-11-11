#include <Arduino.h>

//Constants:

const int fsamp = 10; //Hz
const int dT = 1000/fsamp; //ms

int reading;
int time_now = 0;
int shift = 0;
long timestamp = 0;

void setup(){
  Serial.begin(9600);

}

void loop() {

    shift = millis() - time_now;

    if(shift >= dT)
    {

        time_now = millis();

        //Serial.print(" " + String(shift));
        Serial.println(analogRead(A0));


      }




}
/*

#include "HX711.h"

// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 4;
const int LOADCELL_SCK_PIN = 5;

const int fsamp = 10; //Hz
const int dT = 1000/fsamp; //ms

int reading;
int time_now = 0;
int shift = 0;
long timestamp = 0;

int i = 1;

HX711 scale;

void setup() {
  Serial.begin(57600);
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  pinMode(13,OUTPUT);
  digitalWrite(13,HIGH);

}

void loop() {

    shift = millis() - time_now;

    if(shift >= dT)
    {
      if (scale.is_ready())
      {
        time_now = millis();

        //Serial.print(" " + String(shift));
        Serial.println(scale.read());


      }


  }

}
*/
