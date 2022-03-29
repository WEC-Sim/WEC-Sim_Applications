function y = NMPC(xk0, excM_pred, A, Bu, Bw, R, Np,alpha_eff, beta_eff, phi_eff, qnl, Umax, Umin)

%Sizes
nx = size( A, 1 );
nu = size( Bu, 2 );
ny = 2;

% Initial conditions
persistent Ubar Xbar
if isempty(Ubar)
    Ubar = zeros( Np*nu, 1 );
    Xbar = zeros( ( Np + 1 )*nx, 1 );
end

%Preallocation of matrices/vectors
Atotal = zeros(nx*Np,nx);
Butotal = zeros(nx*Np,nu);
Bwtotal=zeros(nx*Np,nu);
Ctotal = zeros( Np*ny, nx );
Stotal = zeros( Np, 1 );
Ybar = zeros(Np*ny,1);
D = zeros(Np*nx,1);
Dy = zeros(Np*ny,1);

%%%%    Shifting Xbar, Ubar and optionally lambdas    %%%%
Xbar( 1 : Np*nx, 1 ) = Xbar( nx + 1 : ( Np + 1 )*nx, 1 ) ;
Ubar( 1 : ( Np - 1 )*nu, 1 ) = Ubar( nu + 1 : Np*nu, 1 );
[ Xbar( Np*nx + 1 : end, 1 ), ~, ~, ~ ] = simulate_and_linearise( Xbar( ( Np - 1 )*nx + 1 : Np*nx , 1 ), Ubar(Np*nu-nu+1:Np*nu), excM_pred( Np, 1 ), A, Bu, Bw, alpha_eff, beta_eff, phi_eff);
Xbar( 1 : nx, 1 ) = xk0;
d0 = xk0 - Xbar( 1 : nx, 1 );

    for i = 1 : Np
        %  Compute the indices corresponding to the current prediction step i and i + 1
        range_xk = nx * ( i - 1 ) + 1 : i * nx;
        range_uk = nu * ( i - 1 ) + 1 : i * nu;
        range_yk =  ny * ( i - 1 ) + 1 : i*ny;
        range_xk1 = range_xk + nx;
        %   Extract the values of xk and uk at k to compute x_k + 1
        xk  = Xbar( range_xk, 1 );
        uk = Ubar( range_uk, 1);
        wk = excM_pred( range_uk, 1 );
        %   Simulate one step to compute x_k+1 and the linearisation matrices  Ak and Bk
        [ Xk1, Yk1, Ck, Sk1 ] = simulate_and_linearise( xk, uk, wk, A, Bu, Bw, alpha_eff, beta_eff, phi_eff);
        %   Accomulate the matrices A and B in a vertical vector
        Atotal( range_xk, : ) = A;
        Butotal( range_xk, : ) = Bu;
        Bwtotal( range_xk, : ) = Bw;
        Ctotal( range_yk, : ) = Ck;
        Stotal( i, 1 ) = Sk1;
        Ybar( range_yk, 1 ) = Yk1;
        Xbar( range_xk1, : ) = Xk1;
        D( range_xk, : ) = Xk1 - Xbar( range_xk1, 1 );           %Calculate individual offset at each step
    end

    %%%%    Calculate H - Related to the control input deviation    %%%%   
    Qy = zeros( Np*ny );
    Qytotal=repmat(qnl,Np,1);
    Hu = zeros( Np*nx, Np*nu );
    Huy = zeros( Np*ny, Np*nu );
    QHy = Huy;
    
    for i = 1 : Np
       %Select Ranges
        range_xk =  nx*( i - 1 ) + 1 : i*nx;
        range_uk = nu*( i - 1 ) + 1 : i*nu;
        range_yk =  ny*( i - 1 ) + 1 : i*ny;
        range_x1k = range_xk - nx;
        range_u1k_total = 1 : ( i - 1 )*nu;
        range_u_total = 1 : i*nu;
        %Select matrices
        Ak    = Atotal( range_xk, : );
        Buk  = Butotal( range_xk, : );
        Ck     = Ctotal( range_yk, : );
        qyk = Qytotal( range_yk, : );
          %Compute H
        if i>1
            Hu( range_xk, range_u1k_total ) = Ak*Hu( range_x1k, range_u1k_total );    %Previous row propagated with Ak
        end
        Hu( range_xk, range_uk ) = Buk;                                                                                       %Diagonal term
        Huy( range_yk, range_u_total ) = Ck*Hu( range_xk, range_u_total );                   %Entire output row
        QHy(range_yk,range_u_total) = qyk*Huy( range_yk, range_u_total);             
        Qy(range_yk,range_yk) = qnl;                                                                                        %Output weighting
    end
   
         HtQy = Huy'*Qy;
    
%%%%    Calculate E - Hessian    %%%%
%  O(N^2) Extension of Algorithm3.2, Chapter 3, Oscar's Thesis for Calculating E
        E = zeros( Np*nu );
        Wx = zeros( nx, Np*nu );
        for i=Np:-1:2
            %Ranges    
            range_xk = nx*( i - 1 ) + 1 : i*nx;
            range_yk = ny*( i - 1 ) + 1 : i*ny;
            range_uk = nu*( i - 1 ) +1 : i*nu;

            %Select Matrices 
            Ak    = Atotal( range_xk, : );
            Buk  = Butotal( range_xk, : );
            Ck     = Ctotal( range_yk, : );

            Wx( :, range_uk ) = Ck'*QHy( range_yk, range_uk) + Wx( :, range_uk );       %Last element update (not done inside for loop)
            E( range_uk, range_uk ) = Buk'*Wx( :, range_uk );       %Diagonal Term
            for j = 1 : i - 1
                range_u_j = ( j - 1)*nu + 1 : j*nu;
                Wx( :, range_u_j ) = Ck'*QHy( range_yk, range_u_j ) + Wx( :, range_u_j );
                E( range_uk, range_u_j ) = Buk'*Wx( :, range_u_j );
                Wx( :, range_u_j ) = Ak'*Wx( :, range_u_j );
                E( range_u_j, range_uk ) = E( range_uk, range_u_j )';       %Transposed element copying
            end   
        end
                %Last range
                range_uk = 1 : nu;
                range_yk = 1 : ny;
                range_xk = 1 : nx;
                %Last selection of matrices
                Buk = Butotal( range_xk, : );
                Ck = Ctotal( range_yk, : );
                %Compute
                Wx( :, range_uk ) = Ck'*QHy( range_yk, range_uk ) + Wx( :, range_uk );
                E( range_uk, range_uk ) = Buk'*Wx( :, range_uk );       %Diagonal Term

    E = R + ( E + E' ) / 2;

    %%%%    Form constraint matrix M    %%%%
    M = [ eye( Np*nu );
        -eye( Np*nu )];
    
%% %%%%%%%%%% Algorithm 3.9 Standard RTI NMPC - Feedback Phase %%%%%%%%%%%%
    for i = 1 : Np
        range_xk = nx*( i - 1 ) + 1 : i*nx;
        range_yk = ny*( i - 1 ) + 1 : i*ny;
        range_x1k = range_xk - nx;
        Ak = Atotal( range_xk, : );
        Ck = Ctotal( range_yk, : );
        if i == 1
            D( range_xk, : ) = D( range_xk, : ) + Ak*d0;
            Dy(range_yk,:)=Ck*D(range_xk,:);
        else
            D( range_xk, : ) = D( range_xk, : ) + Ak*D( range_x1k, : );
            Dy(range_yk,:)=Ck*D(range_xk,:);
        end
    end
    
    %%%%    Calculate X error    %%%%
    Ye = Ybar + Dy;
   
    %%%%    Calculate linear term f     %%%%
    f =   HtQy*Ye;
    
    %%%%    Calculate constraint vector gamma     %%%%
    gamma = [ repmat( Umax, Np, 1) - Ubar;
             -repmat( Umin, Np, 1) + Ubar];
    
    %%%%    Solve the Quadratic Programm     %%%%
    options=optimoptions('quadprog','Display','off');
    Aeq = [];
    beq = [];
    lb = [];
    ub = [];
    x0 = []; %Ubar;
    dU = quadprog( E, f, M, gamma, Aeq,beq,lb,ub,x0,options);
    
    %%%%    Calculate new nominal input     %%%%
    Ubar = Ubar + dU;
    %%%%   Standard Condensing - Expansion     %%%%
    dXtilde = Hu*dU;
    %%%%    Calculate new nominal state     %%%%
    Xbar( nx + 1 : ( Np + 1 ) * nx ) = Xbar( nx + 1 : ( Np + 1 ) * nx ) + D + dXtilde;
    y = Ubar;

