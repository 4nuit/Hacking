//
// hello.RP204-XIAO.blink-echo.ino
//
// Seeed XIAO RP2040 blink and echo hello-world
//
// Neil Gershenfeld 2/12/23
//
// This work may be reproduced, modified, distributed,
// performed, and displayed for any purpose, but must
// acknowledge this project. Copyright is retained and
// must be preserved. The work is provided as is; no
// warranty is provided, and users accept all liability.
//
#include <Adafruit_NeoPixel.h>
//
// globals
//
#define numpixels 1
#define pixelpower 11
#define pixelpin 16
#define bufsize 25
char buf[bufsize];
int count=0;
//
// setup
//
Adafruit_NeoPixel pixel(numpixels,pixelpin,NEO_GRB+NEO_KHZ800);
void setup() {
   Serial.begin();
   pixel.begin();
   pinMode(pixelpower,OUTPUT);
   digitalWrite(pixelpower,HIGH);
   }
//
// main loop
//
void loop() {
   char chr;
   //
   // check for a char
   //
   if (Serial.available()) {
      //
      // read, save, and send char
      //
      chr = Serial.read();
      buf[count] = chr;
      count += 1;
      buf[count] = 0;
      if (count == (bufsize-1))
         count = 0;
      Serial.print("hello.RP2040-XIAO.blink-echo.ino: you typed ");
      Serial.println(buf);
   }
      //
      // blink LED red green blue white black
      //
      pixel.setPixelColor(0,pixel.Color(255,0,0));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(0,255,0));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(0,0,255));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(255,255,255));
      pixel.show();
      delay(200);  
      //
      pixel.setPixelColor(0,pixel.Color(0,255,255));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(255,0,255));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(255,255,0));
      pixel.show();
      delay(200);
      //
      pixel.setPixelColor(0,pixel.Color(0,0,0));
      pixel.show();
//      pixel.show();
      
   }
