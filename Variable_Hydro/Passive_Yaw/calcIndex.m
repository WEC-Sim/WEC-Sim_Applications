function body1_hydroForceIndex  = calcIndex(Rz,theta)
% This case is mimicking passive yaw. Passive yaw is going to interpolate
% and pull BEM data from the direction corresponding to the relative angle
% between the incoming wave and the device yaw position:. So with an
% incoming wave angle of 10 deg, and some instantaneous yaw position:
% yaw = -10 --> BEM at 20 deg
% yaw = 0   --> BEM at 10 deg
% yaw = 10  --> BEM at 0 deg
% yaw = 20  --> BEM at -10 deg

relativeAngle = theta - Rz*180/pi;

dataDirs = -2:0.25:15;
[~,dataInd] = min(abs(dataDirs-relativeAngle));
body1_hydroForceIndex = dataInd;

% % wave directions of h5 files, in order: 350 (-10), 0, 10, 20
% if relativeAngle >= 185 || relativeAngle < -5
%     body1_hydroForceIndex = 1;
% elseif relativeAngle >= -5 && relativeAngle < 5
%     body1_hydroForceIndex = 2;
% elseif relativeAngle >= 5 && relativeAngle < 15
%     body1_hydroForceIndex = 3;
% elseif relativeAngle >= 15 && relativeAngle < 185
%     body1_hydroForceIndex = 4;
% else
%     body1_hydroForceIndex = 3; % default case
% end

end
