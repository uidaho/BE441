// BE 441/541: Instrumentation and Controls
// PI controller implementation 

#define pwmPin  3     // Replace with the appropriate pin
#define tempPin  A0   // Replace with the appropriate analog pin
float x = 100; // Setpoint temperature in °F
const float Kp = 2.0;  // Proportional gain
const float Ki = 0.5;  // Integral gain
const float dt = 0.5;  // Sampling interval in seconds
const int t_end = 10 * 60; // Time to record in seconds (converted from 10 minutes)
const float T_Safe = 120; // Safe temperature threshold in °F


unsigned long startTime;
unsigned long currentTime;
unsigned long elapsedTime;
float integral = 0;
float previous_error = 0;
int count = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pwmPin, OUTPUT);
  Serial.println("Time(s), Temperature(°F)");
  startTime = millis(); // Record the start time
}

void loop() {
  currentTime = millis();
  elapsedTime = (currentTime - startTime) / 1000; // Time elapsed in seconds

  if (elapsedTime < t_end) {
    float voltage = analogRead(tempPin) * (5.0 / 1023.0); // Read the current voltage
    float y = voltage * 180 + 32; // Convert voltage to temperature in °F

    // Calculate the error
    float error = x - y;

    // Update integral term
    integral += error * dt;

    // Calculate control output
    float u = Kp * error + Ki * integral;

    // Limit the control output to be between 0 and 1
    u = constrain(u, 0, 1);

    // Apply the control output to the heater
    analogWrite(pwmPin, u * 255);

    // Check if the temperature exceeds the safe threshold
    if (y > T_Safe) {
      analogWrite(pwmPin, 0); // Stop the PWM signal if temperature is unsafe
      Serial.println("Temperature exceeded safe level...Process stopped.");
    }

    // Log the time and temperature
    Serial.print(elapsedTime);
    Serial.print(", ");
    Serial.println(y);

    delay(dt * 1000); // Pause for the sampling interval
  }
}
