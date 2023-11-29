function [freq,compSpec]=ampSpectraForZcalc(Data,time,rep_len)

%% INPUTS:
% Data: array of 3D matrices. Index 1 is the DOF, index 2 is the test number,
% and index 3 is the time series (along which to take the fft). Ensure it
% is periodic or you'll have spectral leakage, zero padded to reduce
% time: the time series (in s) related to the Data
%% OUTPUTS:
% freq: the vector of frequencies for the one-sided amplitude spectrum
% ampSpec: the one-sided amplitude spectrum

% detrend, zero pad, and fft
Data = Data - mean(Data,3); % detrend
L=length(Data(1,1,:)); 
%Ln=2^nextpow2(L);
compSpec=fft(Data,[],3)./L;
compSpec=compSpec(:,:,(1:L/2+1));

% handles frequency vector
dt=mean(diff(time));
if var(diff(time)) > 1e-5;
    warning('Non-uniform sample time. Must resample data and try again')
end
Fs=1/dt;
df = 1/rep_len; 
freq=0:df:Fs/2;

end

