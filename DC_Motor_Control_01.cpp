// Define pins for L298N
const int enA = 9; // Enable pin for motor A
const int in1 = 6; // Input 1 for motor A
const int in2 = 5; // Input 2 for motor A

float SetRPM = 500; // Can vary from -500 to +500. Positive for CCW, Negative for CW rotation

void setup() {
  // Set motor control pins as outputs
  pinMode(enA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
 
  Serial.begin(57600); // Start serial communication at 57600 baud rate
  runMotor(SetRPM); // Run the motor with the initial RPM setting
}

void loop() {
  // Print the current RPM setting to the serial monitor
  Serial.println(SetRPM);
  delay(1000); // Delay for a second
}

void runMotor(int SetRPM) {
  // Set motor direction based on the sign of SetRPM
  if (SetRPM > 0) {
    digitalWrite(in1, HIGH); // Set IN1 high
    digitalWrite(in2, LOW);  // Set IN2 low
  } else {
    digitalWrite(in1, LOW);  // Set IN1 low
    digitalWrite(in2, HIGH); // Set IN2 high
  }

  // Ensure SetRPM is within the range of 0 to 500
  SetRPM = min(abs(SetRPM), 500);
  
  // Map the RPM value to a PWM value (0-255)
  int pwm = map(SetRPM, 0, 500, 0, 255);
  analogWrite(enA, pwm); // Set the PWM value to control motor speed
}
