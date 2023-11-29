function Z_interp = interp_impedance(Z,f,f_interp);

% INPUTS
% Z: the impedance FRF to interpolate, with the frequency content on the
%   third dimensions (i.e., size is [DOF,DOF,nFreq].
% f: the frequency associated with the third dimension of the input
%   impedance model Z.
% f_interp: the frequency to which you should interpolate. f should bound
%   f_vec and be in common units.
% OUTPUTS
% Z_interp: the interpolated Z 

dims = size(Z(:,:,1));

rPart = zeros(dims(1),dims(2),length(f_interp));
iPart = zeros(dims(1),dims(2),length(f_interp));

for k = 1:dims(1)
    for kk = 1:dims(2) 
        rPart(k,kk,:) = interp1(f, squeeze(real(Z(k,kk,:))),f_interp); 
        iPart(k,kk,:) = interp1(f, squeeze(imag(Z(k,kk,:))),f_interp);
    end
end

Z_interp = rPart + 1i * iPart; 

end


        
        
