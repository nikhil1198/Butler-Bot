clearvars;
clc;
arena=arduino('COM6');
url = 'http://192.168.173.44:8080/shot.jpg';
pins = [9,10,11,12];
coordinateDetect = false;
refCoord = 0;
dim1 = 144; dim2 = 144; dim = 122;        %Dimension of arena
hasRotate= false;                         %True if bot point towards station after lifting object
onDestination = false;                    %True if bot has reached its station
leastAngle = 4;                           %angle1 between bot and box, station to let they have fallen in same line
vect = 0;                                 %Vector between initial position of bot and box
startRotate = false;                      %To check it has started to rotate
listMidGreen = 0;                         %Mid point of led of Box
listMidRed = 0;                           %Mid point of led of Bot when bot first start to rotate
hasLift = false;
textRec = false;
delay = 0;
straightCheck_1=true;
straightCheck_2=true;

minDist = 10;    %Distance to have to make robot to move
minStationDist = 10;
speed = 130;
offset = 70;
filterDist = 15;
pidDist = 4;
stage0=true;
stage1=false;
stage2=false;
stage3=false;
stage4=false;
stage5=false;
stage6=false;
stop = false;
thresh=0.6;
listBlue = [];
flag=true;
stationOn=false;
fwrite(btooth,251);
flag1=true;

%%  << -- Main Code -- >>

while(~stop)
    im = imread(url);
    grayIm = rgb2gray(im);
    
    %<-- Points Detecton -->
    if(~coordinateDetect)
        bwredFrame = im2bw(im(:,:,1), thresh); % obtain the white component from red layer
        bwgreenFrame = im2bw(im(:,:,2), thresh); % obtain the white component from green layer
        bwblueFrame = im2bw(im(:,:,3), thresh); % obtain the white component from blue layer
        binFrame = bwredFrame & bwgreenFrame & bwblueFrame; % get the common region
        binFrame = medfilt2(binFrame, [4 4]);
        listWhite=binFrame;
    end
    
    if(coordinateDetect)
        listRed = imsubtract(im(:, :, 1), grayIm);
        listGreen = imsubtract(im(:, :, 2), grayIm);
    end
    if(~coordinateDetect)
        s = regionprops(listWhite, 'centroid');
        listWhite = cat(1,s.Centroid);
    end
    
    if(coordinateDetect)
        listGreen = im2bw(listGreen,0.1);
        listGreen = medfilt2(listGreen,[5 5]);
        listRed = im2bw(listRed,0.15);
        t = regionprops(listRed, 'centroid');
        listRed = cat(1,t.Centroid);
        u = regionprops(listGreen,'centroid');
        listGreen = cat(1,u.Centroid);
    end
    
    if(~coordinateDetect)
        listWhite = distinctPoint(listWhite,20);
        whiteSize = size(listWhite);
    end
    
    if((~coordinateDetect && whiteSize(1) ~=4))
        fprintf('no');
        continue
    end
    
    if(~coordinateDetect && whiteSize(1) == 4)
        refCoord = listWhite;
        refCoord = arrange(refCoord);
        coordinateDetect = true;
        fprintf('no');
        continue
    end
    
    if(coordinateDetect)
        listRed = distinctPoint(listRed, filterDist);
        listGreen = distinctPoint(listGreen, 8);
        [redSize, ~] = size(listRed);
        [greenSize, ~] = size(listGreen);
    end
    
    if(coordinateDetect && (redSize ~= 1 || greenSize ~= 3))
        continue
    end
    
    listRed = actualCoord(listRed, refCoord, redSize, dim1,dim2);
    listGreen = actualCoord(listGreen, refCoord, greenSize, dim1,dim2);
    [listRedUp, listGreenUp] = updateList(listRed, listGreen, 14);
    
    % <-- Mid-Point of bot marker and box marker -->
    midRed = listRedUp(2,:);
    midGreen = mean(listGreenUp);
    
    [g1,g2,g3] = stline(listGreenUp(1,1),listGreenUp(1,2), listGreenUp(2,1),listGreenUp(2,2));
    [b1,b2,b3] = stline(listRedUp(1,1),listRedUp(1,2),listRedUp(2,1),listRedUp(2,2));   %Line of bot
    [p1,p2,p3] = normal(g1,g2,midRed(1),midRed(2));
    [insx,insy] = intersection(g1,g2,g3,p1,p2,p3);
    
    
    vectbot = [listRedUp(1,1)-listRedUp(2,1),listRedUp(1,2)-listRedUp(2,2),0] ;
    vectnorm = [insx-midRed(1,1),insy-midRed(1,2),0];
    
    d1=distance(listRedUp(1,1),listRedUp(1,2),listGreenUp(1,1),listGreenUp(1,2));
    d2=distance(listRedUp(1,1),listRedUp(1,2),listGreenUp(2,1),listGreenUp(2,2));
    
    if(d1>d2)
        vectbox = [listGreenUp(1,1)-listGreenUp(2,1),listGreenUp(1,2)-listGreenUp(2,2),0];
    else
        vectbox = [-listGreenUp(1,1)+listGreenUp(2,1),-listGreenUp(1,2)+listGreenUp(2,2),0];
    end
    
    [dir1,theta,v1] = angle1(vectbot,vectnorm);
    
    [dir2,theta1,v2] = angle1(vectbot,vectbox);
    
    if(stage0)
        dist(midGreen,midRed)
        
        if(dist(midGreen,midRed) <= 40)
            fwrite(btooth, 249);
            pause(0.5);
            continue
        elseif(dist(midGreen,midRed) > 40)
            fwrite(btooth, 248);
            inx=insx;
            iny=insy;
            stage0=false;
            stage1=true;
            stage2=false;
            stage3=false;
        end
    end
    
    if(stage1)
        if((theta > 15 && straightCheck_1) || (theta > 50))
            fwrite(btooth,248);
            if(dir1 < 0)
                fwrite(btooth, 45);
                pause(0.001);
                fwrite(btooth, 20);
            else
                fwrite(btooth, 90);
                pause(0.001);
                fwrite(btooth,65);
            end
            
        elseif( sqrt((insx - midRed(1,1))^2 + (insy - midRed(1,2))^2)>=1.5 )
            if(straightCheck_1)
                fprintf('stage1straight');
                fwrite(btooth,248);
            end
            
            straightCheck_1=false;
            theta=floor(theta);
            if(dir1 > 0)
                fwrite(btooth, 120+theta);
            else
                fwrite(btooth, 120-theta);
            end
            stage2=false;
            stage3=false;
        else
            fwrite(btooth,120);
            pause(0.25);
            fwrite(btooth,248);
            stage1=false;
            stage2=true;
            stage3=false;
            fprintf('stage1 over\n');
        end
    end
    
    if(stage2)
        if(flag)
            fwrite(btooth,248);
            fprintf('stage2');
         
            dis = sqrt((insx - midRed(1,1))^2 + (insy - midRed(1,2))^2)
            flag=false;
        end
        
        if(theta1 >=10)
            if(dir2 < 0)
                fwrite(btooth, 42);
                pause(0.001);
                fwrite(btooth, 20);
            else
                fwrite(btooth, 87);
                pause(0.001);
                fwrite(btooth,55);
            end
            stage1=false;
            stage3=false;
        else
            fprintf('stage2_over\n');
            stage1=false;
            stage2=false;
            stage3=true;
        end
    end
    
    if(stage3)
        if(flag1)
            fprintf('afterstage2rotation ');
            fwrite(btooth,248);
            flag1=false;
        end
        if(dist(midGreen,midRed) > 40)
            
            thta1=floor(theta1);
            if(dir2 > 0)
                fwrite(btooth, 120+thta1);
            else
                fwrite(btooth, 120-thta1);
            end
            
            stage1=false;
            stage2=false;
        else
            
            fwrite(btooth,248);
            fprintf('stage3_over \n');
            stage3=false;
            stage4=true;
        end
    end
    
    if(stage4)
        if(theta1 >=2)
            if(dir2 < 0)
                fwrite(btooth, 40);
                pause(0.001);
                fwrite(btooth, 10);
                pause(0.1);
                fwrite(btooth, 248);
            else
                fwrite(btooth, 85);
                pause(0.001);
                fwrite(btooth,55);
                pause(0.1);
                fwrite(btooth, 248);
            end
        else
            fprintf('stage4_over\n');
            stage1=false;
            stage2=false;
            stage4=false;
            stage5=true;
        end
        
        if(stage5)
            fwrite(btooth, 120);
            t=1.2;                %Specify the time for which it should move to get the box on lifter
            pause(t);
            stage3=false;
            fwrite(btooth, 248);
            text=imread(url2);
            n=textrec(text);
            station = listBlue(n,:);
            writeDigitalPin(arena,pins(1,n),1);
            stationOn=true;
            
            %Call Servo motor function in arduino
            
            fwrite(btooth, 250);
            hasLift = true;
            stage4=false;
            stage5=false;
            stage6=true;
        end
    end
    
    if(stage6)
        
        vectstation=[station(1,1)-midRed(1,1),station(1,2)-midRed(1,2),0];
        [dir3,theta2,v3] = angle1(vectbot,vectstation);
        if(theta2 > 10)
            if(dir3 < 0)
                fwrite(btooth, 45);
                pause(0.01);
                fwrite(btooth, 20);
                fprintf('stage6\n');
            else
                fwrite(btooth, 90);
                pause(0.01);
                fwrite(btooth, 65);
            end
            
        elseif(theta2 < 20 && sqrt((station(1,1) - midRed(1,1))^2 + (station(1,1) - midRed(1,2))^2)>= minStationDist)
            fprintf('stage6ptonline\n');
            fwrite(btooth,120);
            stage2=false;
            stage3=false;
        else
            stage1=false;
            stage2=false;
            stage3=false;
            stage5=false;
            stage6=false;
            stage7=true;
        end
    end
    
    if(stage7)
        fwrite(btooth, 251);
        
        fwrite(btooth,249);
        pause(1);
        
        stage6=false;
        onDestination=true;
        stop= true;
    end
end
if(stop)
    fwrite(btooth,248);
end