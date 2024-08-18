const int buttonPin = 2;          // Pin D2 is the interrupt pin
const int ledPin = LED_BUILTIN;   // Built-in LED pin (pin 13)
volatile bool ledState = LOW;     // LED state, volatile because it's used in ISR
unsigned long lastDebounceTime = 0; // Timestamp of the last debounce check
const unsigned long debounceDelay = 100; // Debounce time in milliseconds

void setup() {
  pinMode(buttonPin, INPUT_PULLUP); // Set D2 as input with internal pull-up resistor
  pinMode(ledPin, OUTPUT);          // Set LED pin as output

  attachInterrupt(digitalPinToInterrupt(buttonPin), toggleLED, FALLING); 
  // Attach interrupt on falling edge (button press)
}

void loop() {
  // Main loop can perform other tasks
  // The LED state is handled in the interrupt service routine (ISR)
}

void toggleLED() {
  // Debounce logic: Ignore interrupts that happen too quickly
  unsigned long currentTime = millis();
  if ((currentTime - lastDebounceTime) > debounceDelay) {
    // Toggle the LED state
    ledState = !ledState;
    digitalWrite(ledPin, ledState);

    // Update the last debounce time
    lastDebounceTime = currentTime;
  }
}
