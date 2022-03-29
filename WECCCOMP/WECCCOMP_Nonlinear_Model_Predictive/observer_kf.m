function y = observer_kf( ctrlInput, u, Ad, Bd,  Qkf, Rkf ) 
%#codegen
% Adding noise to the measurements
 r = chol( Rkf, 'lower' );
 miuM = 0*r*randn( 2, 1 );
 u = u + miuM;

% Initialize state transition matrix and Input To State Matrix
A = [Ad, Bd;
     zeros(1, size(Ad,1)) , 1 ];
B = [Bd;0];

nx_obs = size(A,2);

% Measurement matrix
H = [ 1, zeros( 1, nx_obs - 1 );
      0, 1, zeros( 1, nx_obs - 2 )];

% Initial conditions
persistent x_est p_est
if isempty(x_est)
    x_est = zeros( nx_obs, 1 );
    p_est = Qkf;
end

% Predicted state and covariance
x_prd = A * x_est + B * ctrlInput;
p_prd = A * p_est * A' + Qkf;

% Estimation
S = H * p_prd' * H' + Rkf;
B = H * p_prd';
klm_gain = (S \ B)';

% Estimated state and covariance
x_est = x_prd + klm_gain * (u - H * x_prd);
p_est = p_prd - klm_gain * H * p_prd;

% Compute the estimated measurements
x_est(end) = x_est(end) - 0.6979;
y = x_est;
end