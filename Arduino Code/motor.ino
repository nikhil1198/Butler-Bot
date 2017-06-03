void rotateAntiClock(int pwm){
constrain(pwm, 0, 255); 
analogWrite(mrpwm, pwm);
analogWrite(mlpwm,pwm);
digitalWrite(ml1,0);
digitalWrite(ml2,1);
digitalWrite(mr1,1);
digitalWrite(mr2,0);
}

void rotateClock(int pwm){
constrain(pwm, 0, 255);
analogWrite(mrpwm, pwm);
analogWrite(mlpwm,pwm);
digitalWrite(ml1,1);
digitalWrite(ml2,0);
digitalWrite(mr1,0);
digitalWrite(mr2,1);
}

void moveStraight(){
analogWrite(mrpwm, pwm+correction);
analogWrite(mlpwm,pwm-correction);
digitalWrite(ml1,1);
digitalWrite(ml2,0);
digitalWrite(mr1,1);
digitalWrite(mr2,0);
}

void moveBack(){
analogWrite(mrpwm, pwm);
analogWrite(mlpwm, pwm);
digitalWrite(ml1,0);
digitalWrite(ml2,1);
digitalWrite(mr1,0);
digitalWrite(mr2,1);
}

void stall(){
digitalWrite(ml1,1);
digitalWrite(ml2,1);
digitalWrite(mr1,1);
digitalWrite(mr2,1);
}
