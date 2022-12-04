%% INPUT FOR TESTING
waypoints = [25 23;0 15;3 3;5 6;8 10];
dist = 0.01;
waypointsWOW = waypointFactory(waypoints,dist);
index = 40; %input
posList = waypointsWOW(1:index,1:2);
currentPath = [20 22; 19 17];%  0.2758    0.2758
%% nu regelaar met als input :
%posList
%headingErrorList
%currentPath

Kp = 1;minDistance=0.5;check=false;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

headingError = wrapTo360(desiredHeadingCalculator(currentPath,posList))-wrapTo360(headingCalculator(posList));
if headingError>180
    headingError = -(360-headingError);
end
if headingError<-180
    headingError = (headingError+360);
end

angle = Kp*63*headingError/180;

distance = norm(currentPath(end,1:2)-posList(end,1:2));
if distance<minDistance
    check = true;
end

%output : 
%angle
%headingError
%check

%% testing
desiredHeading = desiredHeadingCalculator(currentPath,posList)
heading = wrapTo360(headingCalculator(posList))
headingError = wrapTo360(desiredHeadingCalculator(currentPath,posList))-wrapTo360(headingCalculator(posList))

hold on

plot(posList(:,1),posList(:,2))
title('rood is stuur angle, paars current heading en groen desiredHeading ')
plot(posList(1,1),posList(1,2),'r*')

v1x = cos(deg2rad(heading))/10;
v1y = sin(deg2rad(heading))/10;

v2x = cos(deg2rad(desiredHeading))/10;
v2y = sin(deg2rad(desiredHeading))/10;

v3x = cos(deg2rad(heading+angle))/10;
v3y = sin(deg2rad(angle+heading))/10;
U = currentPath(2,:)-currentPath(1,:);

quiver(currentPath(1,1),currentPath(1,2),U(1),U(2),'b','AutoScale','off')%currentpath;
quiver(posList(end,1),posList(end,2),v1x,v1y,'AutoScale','off')%heading;
quiver(posList(end,1),posList(end,2),v2x,v2y,'AutoScale','off')%desiredheading;
quiver(posList(end,1),posList(end,2),v3x,v3y,'r','AutoScale','off')%angle;

%% FUNCTIONS
function a = offsetCalculator(currentPath,pos)
% local function that calculates offset (double) of the aircraft relative to
% the currentPath en pos 
% !!!! positive value is right, negative value is left !!!
A = currentPath(1,1:2);
B = currentPath(2,1:2);
C = pos;

crossProduct = cross([C-A 0],[B-A 0]);
zValue = crossProduct(3);
offset = zValue/norm(B-A);

a = offset;
end

function a = desiredHeadingCalculator(currentPath,posList)
% calculates desiredheading in site coordinates
outerThreshold=2;
innerThreshold=0.1;
angleCurrentPath=rad2deg(atan((currentPath(2,2)-currentPath(1,2))/(currentPath(2,1)-currentPath(1,1))));
offset=offsetCalculator(currentPath,posList(end,:));
if offset>outerThreshold %buiten outerthreshold
    angle=90+angleCurrentPath;
elseif (offset<innerThreshold) && (offset>-innerThreshold) %binnen innerthreshold
    angle=angleCurrentPath; 
elseif offset<-outerThreshold % buiten outerthreshold
    angle=-90+angleCurrentPath; 
else % lineaire deel (tussen inner en outer)
    angle=(offset*90)/(outerThreshold)+angleCurrentPath;
end
a = angle;%double
end

function angle = headingCalculator(posList)

n = 5;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
l = length(posList(:,1));     
x = posList(l-n:l,1);
y= posList(l-n:l,2);
checkx = x(end)-x(1);
checky = y(end)-y(1);
treshold = 0.000000000001;%!!!!!!!!!!!!!!!!!!!!!!!!!!!
if abs(checkx)<treshold%needs to be checked...
    Y = [ones(length(y),1) y];
    slope = Y\x;
    slope=slope(2);


    slope = slope*sign(checky);
    angle = 90-rad2deg(atan2(slope,sign(checky)));

else
    X = [ones(length(x),1) x];
    slope = X\y;
    slope=slope(2);
    slope = slope*sign(checkx);
    angle = rad2deg(atan2(slope,sign(checkx)));

end

end
