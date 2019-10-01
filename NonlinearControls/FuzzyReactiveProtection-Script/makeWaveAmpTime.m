t = 0:0.01:100;
y1 = sin(2*pi*t/10);
y2 = sin(2*pi*t/8);
y3 = sin(2*pi*t/6);
yfin = [ y1 y2 y3 (y1 + 0.5*y2 + 0.5*y3) ((y1 + 2*y2 + 0.5*y3)) ];
yfin = yfin(1:50001);
t = 0:0.01:500;

dt = 0.01;

waveAmpTime = [t' yfin'];

%% %%%%%
curSimTime = 350;
%% %%%%%
fullt = waveAmpTime(:,1);
fulleta = waveAmpTime(:,2);

% All values up to now
allPastt = fullt(fullt<=curSimTime);
allPastSamples = numel(allPastt);
allPastEta = fulleta(1:allPastSamples);

% A 10s sample window (simulation sample time .01s)
if curSimTime < 50
    windowSamples = allPastSamples; % use what we got
else
    windowSamples = 5001;
end

windowPastt = allPastt(end-windowSamples+1:end);
windowPastEta = allPastEta(end-windowSamples+1:end);

% Sampling frequency
fs = 1/Ts;

%Signal Length
L = windowSamples;

% Calculate fft
eta_dft_mags = abs(fft(windowPastEta));

%% Single-sided magnitude spectrum with frequency axis in Hertz
% Each bin frequency is separated by fs/N Hertz.
bin_vals = [0 : L-1];
fax_Hz = bin_vals*fs/L;
L_2 = ceil(L/2);

freqs = fax_Hz(1:L_2);
mags = eta_dft_mags(1:L_2);

[~, dPd] = max(mags);
T = 1/freqs(dPd)

% plot(fax_Hz(1:N_2), eta_dft_mags(1:N_2))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude');
% title('Single-sided Magnitude spectrum (Hertz)');
% axis tight

