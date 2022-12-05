
%posList
%headingErrorList
%currentPath
Kp = 2;minDistance=0.5;check=false;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%offset
A = currentPath(1,1:2);
B = currentPath(2,1:2);
C = posList(end,:);

crossProduct = cross([C-A 0],[B-A 0]);
zValue = crossProduct(3);
offset = zValue/norm(B-A);

%desiredheading
outerThreshold=2;
innerThreshold=0.1;
angleCurrentPath=rad2deg(atan2((currentPath(2,2)-currentPath(1,2)),(currentPath(2,1)-currentPath(1,1))));
if offset>outerThreshold %buiten outerthreshold
    angle=90+angleCurrentPath;
elseif (offset<innerThreshold) && (offset>-innerThreshold) %binnen innerthreshold
    angle=angleCurrentPath; 
elseif offset<-outerThreshold % buiten outerthreshold
    angle=-90+angleCurrentPath; 
elseif ((offset<-innerThreshold) && (offset>-outerThreshold)) % lineaire deel (tussen outer en inner)
    angle=(offset*90)/(outerThreshold-innerThreshold)+(90*innerThreshold)/(outerThreshold-innerThreshold)+angleCurrentPath;
else % lineaire deel (tussen inner en outer)
   angle=(offset*90)/(outerThreshold-innerThreshold)-(90*innerThreshold)/(outerThreshold-innerThreshold)+angleCurrentPath;
end
desiredHeading = angle;

%heading
n = 20;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

heading = angle;


%k regelaar
headingError = wrapTo360(desiredHeading)-wrapTo360(heading);
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

