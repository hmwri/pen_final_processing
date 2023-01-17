import processing.serial.*;


//Operator : Arduinoの操作を行う
Operator operator ;
//WebAPI : webAPI の操作を行う
WebAPI webapi;
//設定時刻
String AlarmTime = "9999";
//設定時刻がアラームされたかどうか
boolean alarmed = false;
//webAPIのURL
String url = "https://hmwri.com/pen_final/setting.xml";

void setup() {
  printArray(Serial.list());
  Serial s_arduino1 = new Serial(this, "COM6", 9600);
  Serial s_arduino2 = new Serial(this, "COM4", 9600);
  //モーター及びスピーカーを司るArduinoの操作をするAPIクラス
  ArduinoAPI1 arduino1 = new ArduinoAPI1(s_arduino1);
  //LEDテープ及び距離センサを司るArduinoの操作をするAPIクラス
  ArduinoAPI2 arduino2 = new ArduinoAPI2(s_arduino2);
  frameRate(10);
  delay(2000);
  
  operator = new Operator(arduino1, arduino2);
  webapi = new WebAPI(url);
  
  //デバッグ用GUI
  size(400,400);
  ellipse(width/4,height/2, 100,100);
  ellipse(width/4*3,height/2, 100,100);
}

void mousePressed() {
  if(dist(width/4, height/2, mouseX, mouseY) < 50) {
    operator.on();
  }
  if(dist(width/4*3, height/2, mouseX, mouseY) < 50) {
    operator.off();
  }
}

void draw() {
  // 1秒ごとに実行
  if (frameCount % int(frameRate) == 0) {
     
    
    // webAPIから設定値を取得
    SettingData data = webapi.getData();
    // 設定値に変更がある場合
    if (data != null) {
        // 楽譜を書き換え
      operator.changeNote(data.note);
      // 設定時刻を書き換え
      AlarmTime = data.time;
      // アラーム状態をリセット
      alarmed = false;
    }
    // 現在時刻を4桁文字列形式で取得
    String now = getTime();
    // 現在時刻と設定時刻が等しく、アラームされていなければ
    if(now.equals(AlarmTime) && !alarmed){
      //アラームされた
      alarmed = true;
      //アラーム時に起こる挙動を始める
      operator.on();
    }
  }
  //オペレータで各フレームごとに行う操作を呼び出す
  operator.draw();
}

//現在時刻を4桁文字列の形で取得する
//12:32 -> "1232" 02:03 = "0203"
String getTime() {
  String t = "";
  int m = minute();
  int h = hour();
  if (h < 10) {
    t = "0" + str(h);
  } else {
    t = str(h);
  }
  if (m < 10) {
    t = t + "0" + str(m);
  } else {
    t = t + str(m);
  }
  return t;
}
