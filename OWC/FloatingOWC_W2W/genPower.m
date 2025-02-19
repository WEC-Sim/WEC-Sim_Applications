function P_gen = genPower(omega, T_ctrl, TgenMax, PgenTated)

term1 = 6.280e-10 * omega^5 - 1.003e-6 * omega^4 + 4.416e-4 * omega^3 - 0.07028 * omega^2 + 2.106 * omega;
term2 = -0.06941 * T_ctrl^2 - 6.014 * T_ctrl - 4.664e-8 * omega^4 * T_ctrl + 1.79e-8 * omega^3 * T_ctrl^2;
term3 = + 2.089e-5 * omega^3 * T_ctrl - 9.816e-6 * omega^2 * T_ctrl^2 - 0.003354 * omega^2 * T_ctrl;
term4 = + 0.001292 * omega * T_ctrl^2 + 1.189 * omega * T_ctrl - 139.3;

tmp = term1 + term2 + term3 + term4;

P_gen = min(tmp, TgenMax * omega);

end