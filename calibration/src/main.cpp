#include <Arduino.h>

/*==========================================
 * Arduino Labview Voltage Display
 * Created by zxlee (iamzxlee.wordpress.com)
 *
 * Demonstrate how to display Arduino analog
 * inputs, A0 and A1 to Labview using Serial
 * communication
============================================*/

#define input0 A0
#define input1 A1

unsigned long previousCount = 0;

/**==========================================
 * Constants for interval between samples
 * 50000 microseconds = 50 milliseconds
 * equivalent to 20 samples per second
 *
 * Sample rate is controlled using the
 * method similar to example BlinkWithoutDelay
============================================*/

const unsigned long interval = 20000;

void setup()
{
  Serial.begin(115200);
  delay(1000);
}

void loop()
{
  unsigned long currentCount = micros();

  //Calculates the time difference since last serial data sent
  unsigned long countDiff = currentCount - previousCount;

  if(countDiff >= interval)
  {
    //Create a buffer to store string
    char buffer[50];

    //Format the data into string
    sprintf(buffer, "$%d,%d,%u\r\n", analogRead(input0), analogRead(input1), countDiff);

    //Write string into COM port
    Serial.write(buffer);

    //Update new previous count
    previousCount = currentCount;
  }

}


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
 //
 // int sensorPin = A0;   // select the analog input pin for the photoresistor
 // int laserPin = 10;
 //
 //
 // void setup() {
 //   Serial.begin(9600);
 //   //analogWrite(laserPin,200);
 // }
 //
 //
 // void loop() {
 //   Serial.print(analogRead(sensorPin));
 //
 //   Serial.println(analogRead(A1));
 //   delay(100);
 // }

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
