function [ Xk1, Yk1, Ck, Sk1 ] = simulate_and_linearise( Xk, Uk, Wk, A, Bu, Bw, offset_eff, scaler_eff, alpha_efft)
% Used in wecSim implementation
    Xk1 = A*Xk + Bw*Wk + Bu*Uk;
    v   = Xk1( 2 );                 % Prediction of the velocity at time k + 1
    u   = Xk1( end );               % Control input at time k, here is the same as Uk (due to the form of the matrices A, Bu and Bw).

%%%%  Output vector Yk and the partial derivative of the output function g (x_k) %%%%       
%%%%  Aprroximation using hyperbolic tan function

    Sk1 = offset_eff + scaler_eff*tanh( alpha_efft*u*v );
    dgdv = -alpha_efft*scaler_eff*(u^2)*( tanh( alpha_efft*u*v )^2 - 1 );
    dgdu = offset_eff + scaler_eff*tanh(alpha_efft*u*v) - alpha_efft*scaler_eff*u*v*( tanh( alpha_efft*u*v)^2 - 1 );
    
    Ck  = [0, 1, 0, 0, 0;
           0, dgdv , 0, 0, dgdu ];
    
    Yk1 = [ v;
            u*Sk1];   
end
