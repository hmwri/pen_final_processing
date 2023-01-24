
String measure() {
  int Duration_Left;
  float Distance_Left;

  int Duration_Right;
  float Distance_Right;

  int Duration_Top;
  float Distance_Top;

    int Duration_Front;
  float Distance_Front;
  digitalWrite(Trig1, LOW);
  delayMicroseconds(1);
  digitalWrite(Trig1, HIGH);
  delayMicroseconds(11);
  digitalWrite(Trig1, LOW);
  Duration_Right = pulseIn(Echo1, HIGH);
  if (Duration_Right > 0) {
    Distance_Right = (float)Duration_Right / 2 * 340 * 100 / 1000000;
  }
  digitalWrite(Trig2, LOW);
  delayMicroseconds(1);
  digitalWrite(Trig2, HIGH);
  delayMicroseconds(11);
  digitalWrite(Trig2, LOW);
  Duration_Top = pulseIn(Echo2, HIGH);
  if (Duration_Top > 0) {
    Distance_Top = (float)Duration_Top / 2 * 340 * 100 / 1000000;
  }
  digitalWrite(Trig3, LOW);
  delayMicroseconds(1);
  digitalWrite(Trig3, HIGH);
  delayMicroseconds(11);
  digitalWrite(Trig3, LOW);
  Duration_Left = pulseIn(Echo3, HIGH);
  if (Duration_Left > 0) {
    Distance_Left = (float)Duration_Left / 2 * 340 * 100 / 1000000;
  }
   digitalWrite(Trig4, LOW);
  delayMicroseconds(1);
  digitalWrite(Trig4, HIGH);
  delayMicroseconds(11);
  digitalWrite(Trig4, LOW);
  Duration_Front = pulseIn(Echo4, HIGH);
  if (Duration_Front > 0) {
    Distance_Front = (float)Duration_Front / 2 * 340 * 100 / 1000000;
  }

  return String((int)Distance_Front)+","+String((int)Distance_Right) + "," + String((int)Distance_Left) + "," + String((int)Distance_Top)+",";
  
}
