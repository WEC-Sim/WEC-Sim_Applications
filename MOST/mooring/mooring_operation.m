function [x,z,Txa,Tza,Tmax] = mooring_operation(H, V, par)

% Masciola, Marco, Jason Jonkman, and Amy Robertson. "Implementation of a multisegmented, quasi-static cable model." The Twenty-third International Offshore and Polar Engineering Conference. OnePetro, 2013.

% This is a function that takes in the horizontal load (H), vertical load
% (V), and a parameter array (par) as inputs, and outputs the position of a
% mooring line (x and z) and the tension on the anchor (Txa), tension on the
% line (Tza), and maximum tension on the line (Tmax).

% Extract the parameters from the parameter array
w=par(1); L=par(2); EA=par(3); discr=par(4);

% Generate a discretized vector of positions along the mooring line
s=linspace(0,L,discr);

% Calculate the bottom friction coefficient
CB=1;

% Initialize the position and depth arrays
x=zeros(1,length(s));
z=zeros(1,length(s));

% Calculate the length of the bottom segment of the line
LB=L-V/w;

% If the line touches the seabed
if LB > 0
    % Calculate the length of the line in contact with the seabed
    g=LB-H/CB/w;
    if(g>0) 
        lambda=g;
    else 
        lambda=0;
    end
    
    % Iterate through each position along the mooring line
    for i=1:length(s)
        % If the line is in the bottom segment
        if(s(i)<g)
            % Calculate the x position using a quadratic equation
            x(i)=s(i);
        % If the line is in the middle segment
        elseif (s(i)<LB)
            % Calculate the x position using an integral
            x(i)=s(i)+CB*w/2/EA*(s(i).^2-2*s(i)*g+g*lambda);
        % If the line is in the top segment
        else  
            % Calculate the x position using an inverse hyperbolic sine
            x(i)=LB+H/w*asinh(w*(s(i)-LB)/H)+H*s(i)/EA+CB*w/2/EA*(g*lambda-LB^2);
        end
        
        % If the line is in the bottom segment, set the depth to 0
        if s(i)<LB
            z(i)=0;
        % If the line is in the top segment, calculate the depth using a
        % square root function
        else
            z(i)=H/w*((sqrt(1+(w*(s(i)-LB)/H).^2))-1)+w*(s(i)-LB).^2/2/EA;
        end
    end
else 
    % If the line does not touch the seabed, calculate the position and
    % depth using hyperbolic functions
    Va=V-w*L;
    x = H/w * (asinh((Va+w*s)/H) - asinh((Va)/H )) + H*s/EA;
    z = H/w * (sqrt(1+((Va+w*s)/H).^2) - sqrt(1+(Va/H)^2)) + (Va*s+w*s.^2/2)/EA;
end

% Calculate the tension on the anchor and the line, and the maximum tension
% on the line
if(LB>0)
    Txa=max([H-CB*w*LB,0]);
    Tza=0;
    Tmax=sqrt(H^2+w*(L-LB^2));
else
    Txa=H;
    Tza=Va;
    Tmax=sqrt(H^2+V^2);
end

end