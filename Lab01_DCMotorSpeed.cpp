const int potPin = A0;     // Pin connected to the potentiometer wiper (middle terminal)
const int motorPin = 5;    // Control pin to the motor driver (Gate Pin of IRF840 or Control pin of a relay)

int potValue = 0;          // Variable to store the potentiometer value
int motorSpeed = 0;        // Variable to store the motor speed (PWM value)

void setup() {
  pinMode(motorPin, OUTPUT);   // Set motor pin as an output
  Serial.begin(9600);          // Start serial communication for debugging (optional)
}

void loop() {
  potValue = analogRead(potPin);   // Read the potentiometer value (0 to 1023)

  // Map the potentiometer value to a PWM range (0 to 255)
  motorSpeed = map(potValue, 0, 1023, 0, 255);

  // Set the motor speed using PWM
  analogWrite(motorPin, motorSpeed);

  // Print the potentiometer and motor speed values (for debugging)
  Serial.print("Potentiometer Value: ");
  Serial.print(potValue);
  Serial.print(" | Motor Speed: ");
  Serial.println(motorSpeed);

  delay(100);  // Small delay to stabilize readings
}
