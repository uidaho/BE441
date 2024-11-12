// BE 441/541 Instrumentation and Controls
// Arduino code to collect step response data 

#define pwmPin  3     // Replace with the appropriate pin
#define tempPin  A0   // Replace with the appropriate analog pin
const float u = 0.1;  // Step PWM duty cycle value (between 0 and 1)
const float dt = 0.5; // Sampling interval in seconds
const int t_end = 10 * 60; // Time to record in seconds (converted from 10 minutes)
const float T_Safe = 120; // Safe temperature threshold in °F

unsigned long startTime;
unsigned long currentTime;
unsigned long elapsedTime;
int count = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pwmPin, OUTPUT);
  Serial.println("Time(s), Temperature(°F)");
  analogWrite(pwmPin, u * 255); // Apply the initial PWM signal
  startTime = millis(); // Record the start time
}

void loop() {
  currentTime = millis();
  elapsedTime = (currentTime - startTime) / 1000; // Time elapsed in seconds

  if (elapsedTime < t_end) {
    float voltage = analogRead(tempPin) * (5.0 / 1023.0); // Read the current voltage
    float PV = voltage * 180 + 32; // 10 mV/°C = 100°C/V. Convert temperature to °F

    if (PV > T_Safe) {
      analogWrite(pwmPin, 0); // Stop the PWM signal if temperature is unsafe
      Serial.println("Temperature exceeded safe level...Process stopped.");
      while (true); // Terminate the process
    }

    Serial.print(elapsedTime);
    Serial.print(", ");
    Serial.println(PV);
    delay(dt * 1000); // Pause for the sampling interval
  }
}

    delay(dt * 1000); // Pause for the sampling interval
  }
}
