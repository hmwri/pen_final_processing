void drive(char s) {
    switch (s) {
      case 'f':
        operate(TO_FRONT);
        break;
      case 's':
        operate(STOP);
        break;
      case 'b':
        operate(TO_BACK);
        break;
      case 'r':
        operate(TURN_RIGHT);
        break;
      case 'l':
        operate(TURN_LEFT);
        break;
    }
}

void operate(Mode m) {
  switch (m) {
    case TO_FRONT:
      operateChata(RIGHT, FORWARD);
      operateChata(LEFT, FORWARD);
      break;
    case TO_BACK:
      operateChata(RIGHT, REVERSE);
      operateChata(LEFT, REVERSE);
      break;
    case TURN_RIGHT:
      operateChata(RIGHT, OFF);
      operateChata(LEFT, FORWARD);
      break;
    case TURN_LEFT:
      operateChata(RIGHT, FORWARD);
      operateChata(LEFT, OFF);
      break;
    case STOP:
      operateChata(RIGHT, OFF);
      operateChata(LEFT, OFF);
      break;

  }
}

void operateChata(Motor_Side side, Motor_Status s) {
  int IN1 = 0;
  int IN2 = 0;
  if (side == RIGHT) {
    IN1 = RIGHT_IN1;
    IN2 = RIGHT_IN2;
  } else if (side == LEFT) {
    IN1 = LEFT_IN1;
    IN2 = LEFT_IN2;
  }
  switch (s) {
    case FORWARD:
      digitalWrite(IN1, HIGH);
      digitalWrite(IN2, LOW);
      break;
    case REVERSE:
      digitalWrite(IN1, LOW);
      digitalWrite(IN2, HIGH);
      break;
    case OFF:
      digitalWrite(IN1, LOW);
      digitalWrite(IN2, LOW);
      break;
    case BRAKE:
      digitalWrite(IN1, HIGH);
      digitalWrite(IN2, HIGH);
      break;
  }
}
