// ArduinoAPI
// Arduinoとのシリアル通信を行うAPI
// 詳しい通信の取り決めは下記リンクにまとめてあります
abstract class ArduinoAPI {
  Serial arduino;
  // シリアルクラスを指定する
  ArduinoAPI(Serial _arduino) {
    arduino = _arduino;
  }
  //　char型のデータを送る
  void send(char data) {
    println("sended:"+data);
    arduino.write(data);
  }
  // Stringのデータを送る(自動的に改行を付与する)
  // Arduinoは改行コードまでStringを読み込む
  void send(String data) {
    println("sended:"+data);
    arduino.write(data + "\n");
  }
}

// ArduinoAPI1
// モーターとスピーカーを操作するArduinoとのシリアル通信を行うAPI
class ArduinoAPI1 extends ArduinoAPI {
  ArduinoAPI1(Serial arduino) {
    super(arduino);
  }
  //スピーカーのON/OFFを切り替え
  void setSpeaker(boolean on) {
    println("スピーカー:" + (on ? "true" : "false"));
    if (on) {
      send("10");
    } else {
      send("11");
    }
  }
  //楽譜の書き換え
  void changeNote(String note) {
    println("楽譜書き換え:" + note);
    send("0" + note);
  }
  //モーターの操作
  void handle(Direction d) {
    println("ハンドル:" + d);
    switch(d) {
    case Front:
      send("2f");
      break;
    case Right:
      send("2r");
      break;
    case Left:
      send("2l");
      break;
    case Back:
      send("2b");
      break;
    case Stop:
      send("2s");
      break;
    }
  }
}

// ArduinoAPI1
// LEDテープとセンサーを操作するArduinoとのシリアル通信を行うAPI
class ArduinoAPI2 extends ArduinoAPI {
  ArduinoAPI2(Serial arduino) {
    super(arduino);
  }

  //データ送信要求
  void requestData() {
    println("データ送信要求");
    send("1");
  }

  //LEDのON/OFF切り替え
  void setLed(boolean on) {
    println("LED:" + (on ? "true" : "false"));
    if (on) {
      send("20");
    } else {
      send("21");
    }
  }

  //センサー、スイッチからのデータ取得
  ArduinoData getData() {
    println("データ取得");
    //データが来ていた場合
    if (arduino.available() > 0) {
      //改行コードが含まれるまで読み込む
      String inString = arduino.readStringUntil('\n');
      //次のデータを要求する
      requestData();
      println("inString:", inString);
      if (inString != null) {
        inString = trim(inString);

        //受信したデータを','で区切って配列に保存
        int data[] = int(split(inString, ','));

        //受信データが不足しているのならエラー
        if (data.length < 5) {
          print("ERROR!");
          println(data);
          return null;
        }
        println("front=", data[0], "right=", data[1], "left=", data[2], "back=", data[3], "switch~", data[4] == 1);
        return new ArduinoData(data[0], data[1], data[2], data[3], data[4] == 1);
      }
    }
    println("データなし");
    return null;
  }
}

//Arduinoから受信するデータを定義したクラス
class ArduinoData {
  //各方面への距離センサの値
  int front;
  int right;
  int left;
  int back;

  //Switchが押されたかどうか
  boolean isSwitchPushed;

  ArduinoData(int _f, int _r, int _l, int _b, boolean _st) {
    front = _f;
    right = _r;
    left = _l;
    back = _b;
    isSwitchPushed = _st;
  }
}
