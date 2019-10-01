% Make a test signal timeseries, also set up other test inputs

t = 0:0.01:100;
y1 = sin(2*pi*t/10);
y2 = sin(2*pi*t/8);
y3 = sin(2*pi*t/6);
yfin = [ y1 y2 y3 (y1 + 0.5*y2 + 0.5*y3) ((y1 + 2*y2 + 0.5*y3)) ];
yfin = yfin(1:50001);
t = 0:0.01:500;

simu.dt = 0.01; % simulation step
waves.T = 8; % a default, incase we fail to get valid results with fft
waveAmpTime = [t' yfin']; % 500 seconds of waves, period of 10, 8, 6, 10, 8

% Open the viewer
Simulink.sdi.view;

% Run the test
open_system('periodSensor');
sim('periodSensor');