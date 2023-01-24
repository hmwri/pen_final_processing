const int RIGHT_IN1 = 3;        // IN1ピンをD3に
const int RIGHT_IN2 = 4;        // IN2ピンをD4に
const int LEFT_IN1 = 5;        // IN3ピンをD5に
const int LEFT_IN2 = 6;



enum Motor_Side {
  RIGHT,
  LEFT
};

enum Mode {
  TO_FRONT,
  TO_BACK,
  TURN_RIGHT,
  TURN_LEFT,
  STOP
};

enum Motor_Status {
  FORWARD,
  REVERSE,
  OFF,
  BRAKE,
};


const int SPEAKER_PIN = 11;
int playingNote = 0;
unsigned long nextEndPlay = 0;
bool playing = false;
bool led_light = false;




void setup() {
  // put your setup code here, to run once:

  // put your setup code here, to run once:
  pinMode(RIGHT_IN1, OUTPUT);   // デジタルピンを出力に設定
  pinMode(RIGHT_IN2, OUTPUT);
  pinMode(LEFT_IN1, OUTPUT);
  pinMode(LEFT_IN2, OUTPUT);
  pinMode(SPEAKER_PIN, OUTPUT);
  Serial.begin(19200);
}

// モータ制御
void loop() {
  if (Serial.available()) {
    String message = Serial.readStringUntil('\n');
    message.trim();

    if (message.length() >= 2) {
      char header =  message.charAt(0);

      switch (header) {
        case '0':
          alterNote(message.substring(1, message.length()));
          break;
        case '1':
          setPlay(message.charAt(1));
          break;
        case '2':
          drive(message.charAt(1));
      }
    } else {

    }
  }
  if (millis() > nextEndPlay) {
    if (playing) {
      play_audio();
    }
  }

}
