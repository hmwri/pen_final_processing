#include <Adafruit_NeoPixel.h>
#define PIN1 4
#define PIN2 13
#define NUMPIXELS 15
Adafruit_NeoPixel pixels1(NUMPIXELS, PIN1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel pixels2(NUMPIXELS, PIN2, NEO_GRB + NEO_KHZ800);


const int strength = 100;

//スイッチが前押されていたか
bool switchPushed = false;

const int SWITCH_PIN = 12;

int Trig1=5;
int Echo1=8;

int Trig2=6;
int Echo2=9;

int Trig3=7;
int Echo3=10;

int Trig4=3;
int Echo4=2;

//LEDテープが光るかどうか
bool led_light = false;

//LEDテープの色が変わるタイミング
unsigned long nextledtime = 0;

void setup() {
  // put your setup code here, to run once:
  pixels1.begin();
  pixels2.begin();
  pinMode(8, OUTPUT);
  pinMode(Trig1,OUTPUT);
  pinMode(Echo1,INPUT);
  pinMode(Trig2,OUTPUT);
  pinMode(Echo2,INPUT);
  pinMode(Trig3,OUTPUT);
  pinMode(Echo3,INPUT);
  pinMode(Trig4,OUTPUT);
  pinMode(Echo4,INPUT);
  Serial.begin(19200);
  

}

void loop() {
  

  // put your main code here, to run repeatedly:
  // put your main code here, to run repeatedly:
  String message = "";
  String sensordata = "";
  bool nowSwitch = false;
  if (Serial.available()) {
    String message = Serial.readStringUntil('\n');
    message.trim();
    if (message.length() >= 1) {
      char header =  message.charAt(0);
      
      switch (header) {
        case '1':
          sensordata = measure();
          nowSwitch = (digitalRead(SWITCH_PIN) == HIGH);
          if (switchPushed && !nowSwitch) {
            sensordata += "1";
          }else{
            sensordata += "0";
          }         
          switchPushed = nowSwitch;
          Serial.println(sensordata);
          break;
        case '2':
          setLed(message.charAt(1));
          break;
      }
    }
  }
  
  if (millis() > nextledtime) {
    if(led_light){
      
    led();
    }else{
      led_off();
      }
    
  }
}
