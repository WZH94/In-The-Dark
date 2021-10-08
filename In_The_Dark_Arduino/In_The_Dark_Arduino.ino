/******************************************************************************/
/*!
\file   In_The_Dark_Arduino.ino
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the main loop of the Arduino program, which receives signals
  from an electret mic, averages them to detect spikes and sends them, along
  with a button signal to Processing.
*/
/******************************************************************************/

const int MIC_PIN = A2;
const int BUTTON = 2;
// UP DOWN LEFT RIGHT
const int LED_PINS[4] = {3, 4, 5, 6};

// Holds the total of every recorded input from the mic
unsigned long long total_db = 0;
// Counts how many records there has been
unsigned int num_counts = 0;
// Average of total against number of counts
float average_db;

// Current button read
bool button_read;
// Previous button read
bool old_button;
// Whether button state has changed
bool button_changed;

// Min number of records to hold before allowing to detect spikes. 2s
const int min_records = 2000;

// Keeps track of time, sends Serial data every 1/60s
unsigned long time = 0;

// Seperates comma seperated values
byte current_read = 0;
// Holds the pin number to light up
byte pin = 0;
// UNUSED, analogRead inteferes with mic output
byte pwm = 0;

void setup()
{
  Serial.begin(9600);

  for (int i = 0; i < 4; ++i)
  {
    pinMode(LED_PINS[i], OUTPUT);
  }

  button_read = true;
  old_button = true;
  button_changed = false;
}

void loop()
{
  // Read data from Processing
  while (Serial.available())
  {
    // Comma seperated values
    if (Serial.peek() == ',')
    {
      Serial.read();
      ++current_read;
    }

    // End of line, decode message
    else if (Serial.peek() == 10)
    {
      Serial.read();

      switch (pin)
      {
        // UP
        case 1: 
          digitalWrite(3, HIGH);
          digitalWrite(4, 0);
          digitalWrite(5, 0);
          digitalWrite(6, 0);
          break;

        // DOWN
        case 2: 
          digitalWrite(4, HIGH);
          digitalWrite(3, 0);
          digitalWrite(5, 0);
          digitalWrite(6, 0);
          break;

        // LEFT
        case 3: 
          digitalWrite(5, HIGH);
          digitalWrite(3, 0);
          digitalWrite(4, 0);
          digitalWrite(6, 0);
          break;

        // RIGHT
        case 4: 
          digitalWrite(6, HIGH);
          digitalWrite(3, 0);
          digitalWrite(4, 0);
          digitalWrite(5, 0);
          break;
      }

      current_read = 0;
    }

    else
    {
      pin = Serial.read();
//      switch (current_read)
//      {
        // Read pin number
//        case 0: pin = Serial.read();
//          break;
//
//        case 1: pwm = Serial.read();
//          break;
//
//        default:
//          pin = 0;
//          pwm = 0;
//          current_read = 0;
//      }
    }
  }

  int mic_level = analogRead(MIC_PIN);
  button_read = digitalRead(BUTTON);

  if (old_button != button_read)
  {
    old_button = button_read;
    button_changed = true;
  }

  else button_changed = false;

  // Record mic output
  total_db += mic_level;
  ++num_counts;
  
  // Average out the levels to prevent overflow
  if (num_counts >= 60000)
  {
    total_db /= 60000;
    num_counts /= 60000;
  }

  // Holds the amount of any spikes in audio
  int current_spike = 0;

  // Button changed check is to try to prevent as much audio from being picked up when pressing the button
  if (millis() > time + 16 && button_changed == false)
  {
    average_db = total_db / num_counts;
    
    if (num_counts > min_records)
    {
      // Check the current mic level if it is significantly different from the average volume
      current_spike = mic_level - average_db;

      // Change to unsigned
      current_spike = current_spike > 0 ? current_spike : -current_spike;

      // 40 is the threshold to start picking up signals
      if (current_spike > 40)
      {
        current_spike -= 40;

        // Limit the max send value
        if (current_spike > 450)
          current_spike = 450;
      }

      else current_spike = 0;
    }

    Serial.print(current_spike);
    Serial.print(',');
    Serial.println(digitalRead(BUTTON));

    time = millis();
  }
}
