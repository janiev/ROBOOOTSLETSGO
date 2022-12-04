function waypointsWOWoutput = waypointFactory(waypoints,dist)
%input : waypoints en dist..

%output : 
waypointsWOW = []; %waypoints met alle kleine stapjes erbij

for i = 2:length(waypoints)
    A = waypoints(i-1,1:2);
    B = waypoints(i,1:2);
    vector = B-A;

    LenghtVector = (vector(1)^2+vector(2)^2)^(1/2);
    vectorNormalized = vector/LenghtVector;
    jMax = fix(LenghtVector/dist); %jMax = hoeveelheid punten dat je wilt maken

    pointList = [];
    nextPoint=A;
    for j = 1:jMax
        pointList(j,1:2)=nextPoint;
        nextPoint = nextPoint+vectorNormalized*dist;
     

    end
    
    for j = 1:jMax
        pointList(j,1:2)=pointList(j,1:2)+[rand*0.05 rand*0.05];

    end
    pointList(jMax,1:2) = B;

    waypointsWOW = [waypointsWOW;pointList];


end

waypointsWOWoutput = waypointsWOW;


end

