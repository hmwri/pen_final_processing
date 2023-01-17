//基底クラス
abstract class ArduinoClass {
  ArduinoAPI1 arduino1 ;
  ArduinoAPI2 arduino2 ;
  abstract void draw() ;
  ArduinoClass(ArduinoAPI1 _arduino1, ArduinoAPI2 _arduino2){
    arduino1 = _arduino1;
    arduino2 = _arduino2;
  }
}
