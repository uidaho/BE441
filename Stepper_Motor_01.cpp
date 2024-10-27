#include <Stepper.h>

// Define the number of steps per revolution
const int stepsPerRevolution = 2048; // For 28BYJ-48 with ULN2003

// Create a Stepper object to control the motor
// IN1 to Arduino Pin 8
// IN2 to Arduino Pin 9
// IN3 to Arduino Pin 10
// IN4 to Arduino Pin 11

Stepper myStepper(stepsPerRevolution, 8, 10, 9, 11);

void setup() {
  // Set the speed in RPM
  myStepper.setSpeed(10); // This function sets the motor speed in rotations per minute (RPMs).This function doesn’t make the motor turn, just sets the speed at which it will when you call step().
  Serial.begin(9600);
  Serial.println("Stepper Motor Control:");
}

void loop() {
  Serial.println("Rotating clockwise for one revolution...");
  myStepper.step(stepsPerRevolution); // Rotate one full revolution clockwise
  delay(1000);

  Serial.println("Rotating counterclockwise for one revolution...");
  myStepper.step(-stepsPerRevolution); // Rotate one full revolution counterclockwise
  delay(1000);
}
