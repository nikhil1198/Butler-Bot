//void pid(int err)
//{
//  derr=err-preerr;
//  correction=kp*err+kd*derr;
//  preerr=err;
//  correction;
//}

void pid(int err)
{
  derr=err-preerr;
  correction = kp*err+kd*derr;
  preerr=err;
}


void pidRot(int err)
{
  derrRot=err-preerrRot;
  correctionRot = kpr*err+kdr*derrRot;
  preerrRot=err;
}

