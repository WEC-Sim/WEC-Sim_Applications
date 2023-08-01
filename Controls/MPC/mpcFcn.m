function [y, currentIteration, infeasibleCount] = mpcFcn(x_k, v_arrow_k, Sx, Su, Sv, Q, HpInk, H, yLen, maxVel, maxPos, maxPTOForce, maxPTOForceChange, Ho, order, outputSize, currentIteration, time, infeasibleCount)
%% Run 2nd formulation of mpcStruct to find Fpto which maximizes Force*Velocity                    

%% Create cost matrices for mpcStructStruct objective function
f = Su'*Q*(Sx*x_k+Sv*v_arrow_k);

%% Hessian check for convex solver 
if issymmetric(H) == 0
    H_Memory = H;
    checkH=(H+H')/2;
    if abs(H-H_Memory) < 1e-15
        %display('H was symetric to within a 1e-15 tolerance');
        H=(H+H')/2;
    else 
        hello = 1;
    end
end

if all(eig(H) >= 0) == 0
    eig(checkH)
    issymmetric(checkH)
    display('PSD Condition violated on checkH!')
end

%% Create constraint matrices for mpcStruct

I = eye(HpInk+1);%length of prediction horizon
Zero = zeros(HpInk+1);

% Create y_max vector [dZb,max; Zb,max; Fpto,max] to Hp
iterationCounter = 1;
for i = 1:1:((HpInk)*yLen)

   % Single pod
         if iterationCounter == 1
            y_arrow_upperbound(i,1) = maxVel;
         elseif iterationCounter == 2
            y_arrow_upperbound(i,1) = maxPos;
         elseif iterationCounter == 3
            y_arrow_upperbound(i,1) = maxPTOForce;
         end
    
    iterationCounter = iterationCounter + 1;
    if mod(i,yLen) == 0
        iterationCounter = 1;
    end
end

% Simple dFpto max
u_arrow_upperbound = maxPTOForceChange*ones(HpInk+1,1); % dFpto upper limit

% REACTIVE POWER LIMIT: Determine the sign to limit the velocity at k+1
% based on what it is here at time k
if x_k(1) >= 0
    signOfReactivePowerLimit = -1; % If v is pos, Fpto must be negative
else 
    signOfReactivePowerLimit = 1;
end

A = [...
    I; ...
    -I; ...
    Su; ...
    -Su; ...
    ];

B = [...
    u_arrow_upperbound; ...
    u_arrow_upperbound; ...
    y_arrow_upperbound-Sx*x_k-Sv*v_arrow_k; ...
    y_arrow_upperbound+Sx*x_k+Sv*v_arrow_k];


%% Run quadprog
if currentIteration > (Ho + order) % Only run mpcStruct after buffer is full, otherwise Fe predictions are not accurate
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off', 'MaxIter', 600); % Can't set x0 w/ interior-point-convex 
    [dFpto_cmd,FVAL,EXITFLAG, OUTPUT] = quadprog(H,f,A,B,[],[],[],[],[],options);
    if all(eig(H) >= 0) == 0
        eig(H)
        issymmetric(H)
        display('PSD Condition violated on H!')
    end
    if (EXITFLAG ~= 1) && (EXITFLAG ~= 2)
        display('!!!!!!!!!!!!!!!! START ERROR - Infeasible !!!!!!!!!!!!')
        %EXITFLAG    % Display exit flag
        %OUTPUT      % Display output - detailed info from this solution attempt
        %OUTPUT.message
        %TimeOfError = currentIteration % Show the time at which this happened
        %infeasibleCount = infeasibleCount+1 % Keep track of how many times we couldn't get a solution
        %totalRuns = currentIteration/(0.5) % Show how many iterations have run (to compare with the # of errors, above)
        dFpto_cmd = zeros(outputSize,1);
        infeasibilityMessage = sprintf('Output: %s \n Time: %.2f, Infeasible Count: %d, Total Runs: %d',OUTPUT.message,time,infeasibleCount,currentIteration)
        display('-------------------END ERROR -  Infeasible -------------------')
        infeasibleCount = infeasibleCount + 1;
    end

else
    dFpto_cmd = zeros(outputSize,1);
end

y = dFpto_cmd(1);
currentIteration = currentIteration + 1;
%endfunction
