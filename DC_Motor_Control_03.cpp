// Define pins for L298N motor driver
const int enA = 9; // Enable pin for motor A
const int in1 = 6; // Input 1 for motor A
const int in2 = 5; // Input 2 for motor A

// Define pins for quadrature encoder
const int encoderA = 2; // Encoder output A
const int encoderB = 3; // Encoder output B

float SetRPM = 500; // Desired RPM, can vary from -500 to +500. Positive for CCW, Negative for CW rotation
char keyinput; // Variable to store serial input

// Define variables to read the count and converted RPM
volatile int Count = 0; // Variable to store encoder position
float RPM; // Variable to store calculated RPM

void setup() {
  // Set motor control pins as outputs
  pinMode(enA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);

  // Attach interrupts for encoder
  attachInterrupt(digitalPinToInterrupt(encoderA), updateEncoder, RISING);
  
  Serial.begin(57600); // Start serial communication at 57600 baud rate
  runMotor(SetRPM); // Run the motor with the initial RPM setting
}

void loop() {
   if (Serial.available()) {
     // Read the most recent byte from the serial buffer
     keyinput = Serial.read();
     
     // Increase RPM by 25, up to a maximum of 500
     if (keyinput == '+') {
      SetRPM = min(SetRPM + 25, 500); 
     }
     // Decrease RPM by 25, down to a minimum of -500
     else if (keyinput == '-') {
      SetRPM = max(SetRPM - 25, -500); 
     }
     // Reverse the direction of the motor
     else if (keyinput == '*') {
      SetRPM = -SetRPM; 
     }
     
     // Update motor speed and direction
     runMotor(SetRPM);
   }
   
   // Calculate RPM from encoder count
   RPM = Count * 0.5102; // Convert count to RPM (based on encoder and gear ratio). Count divided by 12 pulse/rev then dividde by 9.8 (gear ratio) and multiplied by 60 seconds/minute. Count*60/12/9.8 = Count*0.5120
   Count = 0; // Reset counter
   
   // Print the current RPM setting and calculated RPM to the serial monitor
   Serial.print(SetRPM);
   Serial.print(",");
   Serial.println(RPM);
   
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

void updateEncoder() {
  // Read the state of encoder output B
  int stateB = digitalRead(encoderB);

  // Update encoder count based on the direction of rotation
  if (stateB == 1) {
    Count++;
  } else {
    Count--;
  }
}
