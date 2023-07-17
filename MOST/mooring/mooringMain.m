function  mooringMain(par,x,z,nameline)
   
    % Set optimization options
    options = optimset('MaxIter',4000,'Display','none');
    
    % Define the number of discretization points in the x and z directions
    xdiscr = length(x);
    zdiscr = length(z);
    
    % Initialize arrays to hold the x and z components of the mooring line tension
    fx=zeros(xdiscr,zdiscr);
    fz=zeros(xdiscr,zdiscr);
    
    % Loop over each point in the x and z arrays
    for i=1:xdiscr
        for j=1:zdiscr
            % Use fminsearch to find the minimum of the objective function mooring_obj_func
            % at the current x, z location
            [f]=fminsearch(@(F)mooring_obj_func(F,x(i),z(j),par),[1000,1000,par],options);
            
            % Store the resulting x and z components of the tension in the fx and fz arrays
            fx(i,j)=f(1);
            fz(i,j)=f(2);
        end
    end
    
    % Store the results in a struct
    moor_line.x=x;
    moor_line.z=z;
    moor_line.fx=fx;
    moor_line.fz=fz;
    moor_line.d=par(5);
    moor_line.L=par(2);
    moor_line.linear_mass=par(6);
    moor_line.A_R=par(7);
    % Save the moor_line struct to a file
    save(nameline,'moor_line');

end