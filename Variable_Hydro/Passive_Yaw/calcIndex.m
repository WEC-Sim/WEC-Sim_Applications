function body1_hydroForceIndex  = calcIndex(Rz, waveDirection, bemDirections, previousIndex)
% This case is mimicking passive yaw. Passive yaw is going to interpolate
% and pull BEM data for the incident wave direction closest to the relative
% angle between the incoming wave and the device yaw position. So with an
% incoming wave angle of 10 deg, and some instantaneous yaw position:
% 
% yaw = -10 --> BEM at 20 deg
% yaw = 0   --> BEM at 10 deg
% yaw = 10  --> BEM at 0 deg
% yaw = 20  --> BEM at -10 deg

relativeAngle = waveDirection - Rz*180/pi;

% % This indexing method is indentical to the passive yaw implementation
% % but converges more slowly. To use, add a `memory` block in the simulink
% % model that connects body1_hydroForceIndex to previousIndex.
% previousDir = bemDirections(previousIndex);
% dTheta = bemDirections(2) - bemDirections(1); % assume BEM discretization is constant and equivalent to passive yaw's threshold
% if abs(relativeAngle - previousDir) > dTheta
%     [~, body1_hydroForceIndex] = min(abs(bemDirections-relativeAngle));
% else
%     body1_hydroForceIndex = previousIndex;
% end

% This indexing method (always choosing the closest BEM dataset) is not
% identical to the passive yaw implementation, but is simple, precise, and
% converges quickly.
[~, body1_hydroForceIndex] = min(abs(bemDirections-relativeAngle));

end
