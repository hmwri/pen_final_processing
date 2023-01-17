//ArduinoAPIを通じてArduinoを適切に操作するクラス
class Operator extends ArduinoClass {
  //アラームがONかOFFか
  boolean on = false;
  Operator(ArduinoAPI1 _arduino1, ArduinoAPI2 _arduino2) {
    super(_arduino1, _arduino2);
  }
  //毎フレーム呼び出される
  void draw() {
    //アラーム機能がONなら
    if (on) {
      //センサーデータを取得する
      ArduinoData data = arduino2.getData();
      //センサーデータを受信していたならば
      if (data != null) {
        // driverクラスを作り、どの方向に動くべきかを取得する
        Driver driver = new Driver(data);
        Direction d = driver.getNextDirection();
        //その方向にモーターを動かす
        arduino1.handle(d);
        //もし、スイッチが押されていたならばアラーム機能をオフにする
        if(data.isSwitchPushed){
          off();
        }
      };
    }
  }
  
  //楽譜を更新する
  void changeNote(String note) {
    println("changeNote",note);
    arduino1.changeNote(note);
  }
  
  //アラーム機能をオンにする
  void on() {
    println("ON");
    on = true;
    arduino1.setSpeaker(true);
    arduino2.setLed(true);
    //センサーデータ送信のリクエストを送っておく
    arduino2.requestData();
  }
  
  //アラーム機能をオフにする
  void off() {
    println("OFF");
    on = false;
    arduino1.setSpeaker(false);
    arduino2.setLed(false);
    //モータを停止させる
    arduino1.handle(Direction.Stop);
  }
}
