clearvars;
clc;
url = 'http://192.168.59.107:8080/shot.jpg';
coordinateDetect = false;
refCoord = 0;
dim1 = 65; dim2 = 71; dim = 71;           %Dimension of arena
distLed = 7;                              %Distance between led of bot and box
distBotBox = 7;                           %Distance to have between bot and box to stop
distBotStation = 7;                       %Distance to have between bot and station to stop 
hasRotate= false;                         %True if bot point towards station after lifting object                
onDestination = false;                    %True if bot has reached its station
leastAngle = 4;                           %angle between bot and box, station to let they have fallen in same line 
iSVect = 0;                               %Vector between initial position of bot and station
startRotate = false;                      %To check it has started to rotate
listMidGreen = 0;                         %Mid point of led of Box
listMidRed = 0;                           %Mid point of led of Bot when bot first start to rotate 
hasLift = false;                         
textRec = false;
delay = 0;                                %Time for which matlab code has to pause so that it send signal to arduino and it get executed
btooth = Bluetooth('HC-06',1);
fopen(btooth);
minDist = 10;                                  %Distance to have to make robot to move
speed = 150;
sfact = 28;
filterDist = 15;
pidDist = 4;

 task0 = true;
 task1 = false;
 task2 = false;
 stage1 = false;
 stage2 = false;
 stage3 = false;
 stage4 = false;
 lAngle = 5;
 lDist = 10;
 lDist2 = 10;

 stop = false;   
 firstVect = 0;           %Vector along which we have to first travel it
 secondVect = 0;           %Vector along which we have to secondly travel it
 
%% <<-- Variables for calculating PID -->>
% <<-- PID constants -->>
kp=10;
kd=1;
ki=0;

% <<-- Error Determination Variable -->>
serrDist = 5;
serr = zeros(1,9);
lasterr = 0;
err = 0;
ierr = 0;

%%  << -- Main Code -- >>
while(~stop)
    im = imread(url);
    im = imresize(im,[500 500]);
    grayIm = rgb2gray(im);
    
    %<-- Points Detecton -->
    if(~coordinateDetect)
         listCoord = imsubtract(im(:, :, 2), grayIm);  %imsubtract(im(:, :, 2), grayIm); 
    end
    
    if(coordinateDetect)
        listRed = imsubtract(im(:, :, 1), grayIm);
        listGreen = imsubtract(im(:, :, 2), grayIm);
    end
    if(~coordinateDetect)
        listCoord = im2bw(listCoord,0.45);  %im2bw(listGreen,0.05);
        s = regionprops(listCoord, 'centroid');
        listCoord = cat(1,s.Centroid);
    end
    
    if(coordinateDetect)
        listGreen = im2bw(listGreen,0.1);
        listRed = im2bw(listRed,0.1);
        t = regionprops(listRed, 'centroid');
        listRed = cat(1,t.Centroid);
        u = regionprops(listGreen,'centroid');
        listGreen = cat(1,u.Centroid);
    end
    
    if(~coordinateDetect)
     listCoord = distinctPoint(listCoord,20);
     coordSize = size(listCoord);
    end
      
    if((~coordinateDetect && coordSize(1) ~=4))
        continue
    end
    
     if(~coordinateDetect && coordSize(1) == 4)
      refCoord = listCoord;
      refCoord = arrange(refCoord);
      coordinateDetect = true;
      continue
     end
    
    if(coordinateDetect)
      listRed = distinctPoint(listRed, filterDist);
      listGreen = distinctPoint(listGreen, filterDist);
      [redSize, ~] = size(listRed);
      [greenSize, ~] = size(listGreen);
    end
    
    if(coordinateDetect && (redSize ~= 1 || greenSize ~= 3))
        continue
    end
    
    listRed = actualCoord(listRed, refCoord, redSize, dim1,dim2);
    listGreen = actualCoord(listGreen, refCoord, greenSize, dim1,dim2);
    [listRedUp, listGreenUp] = updateList(listRed, listGreen, distLed);
    
    % <-- Mid-Point of bot marker and box marker -->
    midRed = mean(listRedUp);
    midGreen = mean(listGreenUp);
    
%     if(stationOn)
%         listBlue = imsubtract(im(:,:,3), grayIm);
%         listBlue = im2bw(listBlue, 0.75);
%         listBlue = distinctPoint(listBlue, filterDist);
%         blueSize = size(listBlue);
%         if(blueSize(1) ~= 2)
%             continue
%         end
%         listBlueUp = actualCoord(listBlue, refCoord, blueSize, dim1, dim2);
%     end
%     
    
 

vectBot = [listRedUp(1,1) - listRedUp(2,1), listRedUp(1,2) - listRedUp(2,2), 0];
if(task0)
if(distance(midRed(1), midRed(2), midGreen(1), midGreen(2) < minDist)
fwrite(btooth, 249);
pause(0.2);
fwrite(btooth, 248);
else
task0 = false;
task1 = true;
stage1 = true;
end
end

if(firstVect == 0 && secondVect == 0)
if(distance(listGreenUp(1,1), listGreenUp(1,2), listRedUp(1,1),listRedUp(1,2) >= distance(listGreenUp(2,1), listGreenUp(2,2), listRedUp(1,1),listRedUp(1,2))
vab = [listGreenUp(1,1) - listGreenUp(2,1), listGreenUp(1,2) - listGreenUp(2,2), 0];
else
vab = [listGreenUp(2,1) - listGreenUp(1,1), listGreenUp(2,2) - listGreenUp(1,2), 0];

cr = cross(vab, vectBot);
vpb = cross(vab, cr);
end

if(pDist(midRed, [midGreen, 0; vab]) <= pDist([midRed, midGreen, 0; vpb]))
firstVect = vpb;
secondVect = vab;
else 
firstVect = vab;
secondVect = vpb;
end
end


if(task1)
if(stage1)
% rotate until its angle with firstVect become 'lAngle'
pAngle = findAngleVect(vectBot, firstVect);
dirVect = cross(vectBot, firstVect);
if(pAngle > lAngle)
    if(dirVect(3) > 0)
        fwrite(btooth, sfact + 10);
        pause(0.3);
        fwrite(btooth, 248);
    else if(dirVect(3) < 0)
        fwrite(btooth, 10);
        pause(0.3);
        fwrite(btooth, 248); 
        else
            stage1 = false;
            stage2 = true;
        end
    end
end
end

if(stage2)
% move until its distance with secondVect become 'lDist'
if(pDist(listRedUp(1,:), secondVect) > lDist)
fwrite(btooth, 2*sfact + 10);
pause(0.35);
fwrite(btooth, 248);
else
stage2 = false;
task1 = false;
task2 = true;
end
end
end


if(task2)
if(stage3)
% rotate until its angle with secondVect become 'lAngle'
pAngle = findAngleVect(vectBot, secondVect);
dirVect = cross(vectBot, secondVect);
if(pAngle > lAngle)
    if(dirVect(3) > 0)
        fwrite(btooth, sfact + 10);
        pause(0.3);
        fwrite(btooth, 248);
    else if(dirVect(3) < 0)
        fwrite(btooth, 10);
        pause(0.3);
        fwrite(btooth, 248); 
        else
            stage3 = false;
            stage4 = true;
        end
    end
end
end

if(stage4)
% move until its distance with midGreen become 'lDist2'
currDist = dist(listRedUp(1,:), listGreenUp(1,:));
if(currDist > lDist2)
 fwrite(btooth, 2*sfact + 10);
pause(0.35);
fwrite(btooth, 248);   
else
    stage4 = false;
    task2 = false;
    onDestination = true;
end
end
end
% end
% 
% if(~textRec)
%     %% Text Recognisation Code
% end
%     %% Call Servo motor function in arduino
%    if(~hasLift)
%     fwrite(btooth, 250);
%     pause(0.2);
%     hasLift = true;
%    end
%    
%    if(~hasRotate)
%    if(~startRotate)
% listMidRed = mean(listRedUp);
% listMidBlue = mean(listBlueUp);
% listMid = [listMidBlue; listMidRed];
% iSVect = [listMidBlue(1)-listMidRed(1), listMidBlue(2)-listMidRed(2),0];
% startRotate = true;
%    end
% 
% angle1 = findAngle(listRedUp, listMid);
% if(angle1 >= 0 && angle1 <= leastAngle)
%     hasRotate = true;
%     fwrite(btooth, 248);
%     continue
% end
%     dir = rotate(listRedUp, vect);
%     if(dir)
%     speedFact = scale(d, sfact, 0, 180, 0);
%     fwrite(btooth, speed);
%     pause(0.25);
%     else
%         speedFact = scale(d, 2*sfact, sfact, 180, 0);
%         fwrite(btooth, speed);
%         pause(0.25);
%     end
%     angle1 = findAngle(listRedUp, listMid);
%     if(angle1>=0 && angle1 <= 20)
%         hasRotate = true;
%         fwrite(btooth, 248);
%         continue
%     end
%    end
%    
%    if(hasRotate && ~onDestination)
%      dis = dist(midBlue,midRed);
%    if(dist <= distBotStation)
%          fwrite(btooth, 248);
%          onDestination = true;
%    else
%      serr = calSerr(pidDist, [midRed; listRedUp(1,1)-listRedUp(2,1),listRedUp(1,2) - listRedUp(2,2)], listMid(1,:), listMid(2,:));
%      [err, ierr, efact] = pwmCal(kp,kd,ki,serr, ierr, err);
%      speedFact = scale(dis, 3*sfact, 2*sfact, 150, 0);
%      fwrite(btooth, speed);
%      pause(delay);
%      fwrite(btooth, err);
%    end
%    end
   
    if(onDestination)
        fwrite(btooth, 248);
        stop = true;
    end
end    
 %end