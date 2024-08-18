#include <Arduino.h>

const int potPin = A0;  // Pin connected to the potentiometer's wiper (middle terminal)
int potValue = 0;       // Variable to store the raw potentiometer value
long voltage = 0;       // Variable to store the mapped voltage

void setup() {
  Serial.begin(9600);   // Start serial communication at 9600 baud rate
}

void loop() {
  potValue = analogRead(potPin);   // Read the analog value from the potentiometer
  voltage = map(potValue, 0, 1023, 0, 5000); // Map the value to a range from 0 to 5000 mV (0 to 5V)
  // map funciton in this case is equivalent to voltage = potValue * (5000 / 1023.0); This will Convert the raw value to milli volt (0 to 5000 mV)
  Serial.print("Potentiometer Value: ");
  Serial.print(potValue);          // Print the raw value
  Serial.print(" | Voltage: ");
  Serial.print(voltage / 1000.0);  // Convert mV to V and print the voltage
  Serial.println(" V");            // Print the unit 'V'

  delay(100);  // Add a short delay to stabilize readings
}

