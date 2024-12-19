function pGen = calcTurbPower(omega, controlTorque, PgenRated, TgenMax)

pGen = zeros(1);

% Absolute values were added because the generator only spins in one direction
omega = abs(omega);
T_ctrl = abs(controlTorque);

term1 = 6.280e-10*omega^5 - 1.003e-6*omega^4 + 4.416e-4*omega^3 - 0.07028*omega^2 + 2.106*omega;
term2 = -0.06941*T_ctrl^2 - 6.014*T_ctrl - 4.664e-8*omega^4*T_ctrl + 1.79e-8*omega^3*T_ctrl^2;
term3 = + 2.089e-5*omega^3*T_ctrl - 9.816e-6*omega^2*T_ctrl^2 - 0.003354*omega^2*T_ctrl;
term4 = + 0.001292*omega*T_ctrl^2 + 1.189*omega*T_ctrl - 139.3;

tmp = term1 + term2 + term3 + term4;

% Power can not be more than the maximum allowable
tmp = min([tmp, TgenMax * omega, ones(size(tmp))*PgenRated]);

% We can't have negative power
pGen = max(tmp , 0);

end