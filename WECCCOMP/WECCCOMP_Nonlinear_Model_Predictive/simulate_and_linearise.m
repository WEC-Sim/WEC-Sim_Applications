function [ Xk1, Yk1, Ck, Sk1 ] = simulate_and_linearise( Xk, Uk, Wk, A, Bu, Bw, alpha_eff, beta_eff, phi_eff)
% Used in wecSim implementation
    Xk1 = A*Xk + Bw*Wk + Bu*Uk;
    v   = Xk1( 2 );                 % Prediction of the velocity at time k + 1
    u   = Xk1( end );               % Control input at time k, here is the same as Uk (due to the form of the matrices A, Bu and Bw).

%%%%  Output vector Yk and the partial derivative of the output function g (x_k) %%%%       
%%%%  Aprroximation using hyperbolic tan function

    Sk1 = alpha_eff + beta_eff*tanh( phi_eff*u*v );
    dgdv = -phi_eff*beta_eff*(u^2)*( tanh( phi_eff*u*v )^2 - 1 );
    dgdu = alpha_eff + beta_eff*tanh(phi_eff*u*v) - phi_eff*beta_eff*u*v*( tanh( phi_eff*u*v)^2 - 1 );
    
    Ck  = [0, 1, 0, 0, 0;
           0, dgdv , 0, 0, dgdu ];
    
    Yk1 = [ v;
            u*Sk1];   
end
