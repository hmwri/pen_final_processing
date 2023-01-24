String note = "000Y0DWC0AKB0DWB0AKA05KC08CB0B4B08CB0C8B09GB0C8C09GB08CA0C8C0G4B0C8B0DWB0AKB0DWB0AKB05KC08CA0B4C08CB0C8B09GB0C8B09GC08CD0OG50G430C860G460IC50KK70ICA0G450G4N0G430GO20GO30GO3000G0C860G460IC50KK60ICB0G460ICB0KKZ0KK30C860G460IC50KK60ICB0G450G4G";
void alterNote(String newNote) {
  playingNote = 0;
  note = newNote;
}



void setPlay(char s) {
  playingNote = 0;
  if (s == '0') {
    playing = true;
  } else {
    playing = false;
  }
}

void play_audio() {
 noTone(SPEAKER_PIN);
  if (playingNote > note.length() - 4) {
    playingNote = 0;
    nextEndPlay = millis() + 1000;
    return;
  }
  Serial.println(note.length());
  String fs = note.substring(playingNote, playingNote + 3);
  String ns = note.substring(playingNote + 3, playingNote + 4);
  playingNote += 4;
  char fBuf[4];
  fs.toCharArray(fBuf, 4);
  char nBuf[2];
  ns.toCharArray(nBuf, 2);
  int f = strtol(fBuf, NULL, 36);
  int l = strtol(nBuf, NULL, 36);
  if (f > 0) {
    tone(SPEAKER_PIN, f, l * 50) ;
  }
  nextEndPlay = millis() + l * 50;
  

}
