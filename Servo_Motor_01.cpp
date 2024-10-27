#include <Servo.h> // Available to download for PlatformIO from https://github.com/arduino-libraries/Servo

Servo myServo;  // Create a servo object

void setup() {
  myServo.attach(9,500,2500);  // Attach the servo to pin 9
}

void loop() {
  myServo.write(0);    // Move servo to 0 degrees
  delay(1000);         // Wait for 1 second
  myServo.write(90);   // Move servo to 90 degrees
  delay(1000);         // Wait for 1 second
  myServo.write(180);  // Move servo to 180 degrees
  delay(1000);         // Wait for 1 second
}
