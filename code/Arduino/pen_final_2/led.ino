void led() {
  pixels1.clear();
  pixels2.clear();
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels1.setPixelColor(i, pixels1.Color(random(strength), random(strength), random(strength)));
    pixels2.setPixelColor(i, pixels1.Color(random(strength), random(strength), random(strength)));
  }
  pixels1.show();
  pixels2.show();
  nextledtime = millis() + 100;
}

void led_off() {
  pixels1.clear();
  pixels2.clear();
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels1.setPixelColor(i, pixels1.Color(0,0,0));
    pixels2.setPixelColor(i, pixels1.Color(0,0,0));
  }
  pixels1.show();
  pixels2.show();
}



void setLed(char s) {
  if (s == '0') {
    led_light = true;
    
  } else {
    led_light = false;
  }
  
}
