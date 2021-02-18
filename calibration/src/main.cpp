#include <Arduino.h>

// //Constants:
//
// const int fsamp = 10; //Hz
// const int dT = 1000/fsamp; //ms
//
// int reading;
// int time_now = 0;
// int shift = 0;
// long timestamp = 0;
// int counter = 0;
// int T = 100; //s
//
// int N = T*fsamp;
//
// void setup(){
//   Serial.begin(115200);
//   delay(10000);
//   Serial.println("Start Acquisition");
//
// }
//
// void loop() {
//
//
//     if(millis() - time_now >= dT && counter < N)
//     {
//
//         time_now = millis();
//         counter++;
//         Serial.println(analogRead(A0));
//         //Serial.print(" " + String(shift));
//
//     }
//
//
// }



// ****************************************************************************

/*
 * IRremote: IRreceiveDemo - demonstrates receiving IR codes with IRrecv
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Initially coded 2009 Ken Shirriff http://www.righto.com/
 */

 int sensorPin = A0;   // select the analog input pin for the photoresistor
 int laserPin = 10;


 void setup() {
   Serial.begin(9600);
   analogWrite(laserPin,200);
 }


 void loop() {
   Serial.println(analogRead(sensorPin));
   delay(100);
 }

// **************************************************************************

// #include "HX711.h"
//
// // HX711 circuit wiring
// const int LOADCELL_DOUT_PIN = 4;
// const int LOADCELL_SCK_PIN = 5;
//
// const int fsamp = 80; //Hz
// const int dT = 1000/fsamp; //ms
//
// int reading;
// int time_now = 0;
// int shift = 0;
// long timestamp = 0;
//
// int i = 1;
//
// HX711 scale;
//
// void setup() {
//   Serial.begin(115200);
//   scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
//   pinMode(13,OUTPUT);
//   digitalWrite(13,HIGH);
//
// }
//
// void loop() {
//
//     shift = millis() - time_now;
//
//     if(shift >= dT)
//     {
//       if (scale.is_ready())
//       {
//         time_now = millis();
//
//         //Serial.print(" " + String(shift));
//         Serial.println(scale.read());
//
//
//       }
//
//
//   }
//
// }
