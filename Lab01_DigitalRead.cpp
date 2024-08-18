#include <Arduino.h>
// Connect the digital floating or externally pulled-up input to pin D2
const int buttonPin = 2;    // Pin connected to the push button
int buttonState = 0;        // Variable to store the button state

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);  // Set D2 as input with an internal pull-up resistor
  Serial.begin(9600);                // Initialize serial communication at 9600 bps
}

void loop() {
  buttonState = digitalRead(buttonPin);  // Read the state of the push button

  if (buttonState == LOW) {
    Serial.println("Button Pressed");    // Print message if button is pressed
  } else {
    Serial.println("Button Released");   // Print message if button is released
  }

  delay(100);  // Short delay to avoid spamming the serial monitor
}
