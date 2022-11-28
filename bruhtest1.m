%% INPUT 
waypoints = [0 0;1 1;2 2;3 3;5 6;8 10];
dist = 0.01;
waypointsWOW = waypointFactory(waypoints,dist);
%% steerangle

index = 3; %input
posList = waypointsWOW(1:index,1:2); %input (here simulated)
heading = 5;

currentPath = [5 43; 2 2];
pos = [9 12];
bruh = offsetCalculator(currentPath,pos)

%plot(waypointsWOW(:,1),waypointsWOW(:,2))
%plot(currentPath(:,1),currentPath(:,2))
%hold on
%plot(pos(1),pos(2),'r*')


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

function a = desiredHeadingCalculator(currentPath,pos)

end

function agraad = headingCalculator(posList,n)
%calculates current heading of vehicle using the posList
%currently only works for positive X
%n is dimension of the regression matrix
for i=1:n
    X=[]
    Y=[]
lastx=([posList(end-(n)+i,1)])
lasty=([posList(end-(n)+i,2)])
X=[X, lastx]
Y=[Y, lasty]

coef=polyfit(X,Y,1)
slope=coef(1)
a=atan(slope)
agraad=rad2deg(a)

end
