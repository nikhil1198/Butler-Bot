#include <Servo.h>

//<-- Right motor pin -->
#define mrpwm 5
#define mr1 12
#define mr2 13

//<-- Left motor pin -->
#define mlpwm 6
#define ml1 7
#define ml2 8
#define servoPin 11    //Servo motor pin

//<-- Robot pwm Variable -->
int pwm = 120;
int pwmRot = 125;
int offset = 45;
int input = 248;
Servo servoMotor;
int preerr=0,err=0,derr=0,kp=2.5 ,kd=0.06,correction=0;
int preerrRot = 0;
float kpr = 0.1;float kdr = -0.05;float derrRot = 0;float correctionRot = 0;

void setup() { 
pinMode(mr1,OUTPUT);
pinMode(mr2,OUTPUT);
pinMode(mrpwm,OUTPUT);
pinMode(ml1,OUTPUT);
pinMode(ml2,OUTPUT);
pinMode(mlpwm,OUTPUT);
servoMotor.attach(servoPin);
servoMotor.write(180);
Serial.begin(9600);
}
void loop() {
if(Serial.available()){
  input = Serial.read();
 
}

if(input<=offset){
  if(input==offset)
  rotateClock(pwmRot);
  else
  rotateClock(pwmRot-(offset-input));
}

else if(input> offset && input<=2*offset)
{
  if(input == 2*offset)
  rotateAntiClock(pwmRot);
  else
  rotateAntiClock(pwmRot - (2*offset-input));
}
  
else if(input>2*offset && input<150)
{
  err=120-input;
  pid(err);
  moveStraight(); 
}
else if (input>150 && input<160)
{
  kp=(input%10)/10;
}

else if(input > 160 && input < 170){
  kd = (input%10)/100;
  }

else if(input>170 && input < 180){
kd = (input%10)/10;
}
//  if(input<=offset && input>0 && count == 0){
//    rotateClock(pwm - input);

//  }
//
//  else if(input>offset && input<=2*offset && count == 0){
//    rotateAntiClock(pwm-(input - offset));
//  }
//
//  else if(input>2*offset && input<3*offset && count == 0){
//    //moveStraight(pwm-(input - 2*offset), pwm-(input - 2*offset));
//    preinput = input;
//    count = 1;
//  }
//  
//  else if(count == 2 && input>=0 && input<=10){
//    moveStraight(pwm-(preinput - 2*offset) + input, pwm-(preinput - 2*offset0)-input);
//    }
//
//else if(count == 2 && input>=10 && input<=20){
//    moveStraight(pwm-(preinput - 2*offset) - (input-10), pwm-(preinput - 2*offset0)+(input-10));
//    }
//    
  else if(input == 248){
    stall();
    }

    else if(input == 249){
    moveBack();
    }

//    //To lift Object
  else if(input == 250){
    servoMotor.writeMicroseconds(1500);
    delay(1000);
    }
//
//    //To place Object
  else if(input == 251){
    servoMotor.writeMicroseconds(2000);
    delay(2000);
    }
}
