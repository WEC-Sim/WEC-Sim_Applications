function body1_hydroForceIndex  = calcIndex(deltaSurge, bemDisps, previousIndex)
% This case is mimicking large xy displacement.

% This indexing method is indentical to the passive yaw implementation
% but converges more slowly. To use, add a `memory` block in the simulink
% model that connects body1_hydroForceIndex to previousIndex.
previousX = bemDisps(previousIndex);
dX = bemDisps(2) - bemDisps(1); % assume BEM discretization is constant and equivalent to passive yaw's threshold
if abs(deltaSurge - previousX) > dX
    [~, body1_hydroForceIndex] = min(abs(bemDisps-deltaSurge));
else
    body1_hydroForceIndex = previousIndex;
end


% This indexing method (always choosing the closest BEM dataset) is simple, precise, and
% converges quickly.
% [~, body1_hydroForceIndex] = min(abs(bemDisps-deltaSurge));

end
