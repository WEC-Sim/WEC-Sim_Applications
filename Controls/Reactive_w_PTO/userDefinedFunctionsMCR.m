%% User Defined Functions for MCR run
controllersOutput = controller1_out;
signals = {'force','power'};
for ii = 1:length(controllersOutput)
    for jj = 1:length(signals)
        controllersOutput(ii).(signals{jj}) =  controllersOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
    end
end

endInd = length(controllersOutput.power);
startTime = controllersOutput.time(end) - 4*waves.period; % select last 4 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));

mcr.meanControlPower(imcr) = mean(controllersOutput.power(startInd:endInd,3));
mcr.maxControlForce(imcr) = max(controllersOutput.force(startInd:endInd,3));

mcr.meanElecPower(imcr) = mean(elecPower);
mcr.maxForce(imcr) = max(genForce);

if imcr == 20

    % Plot surface for controller power at each gain combination
    figure()
    plot(mcr.cases, mcr.meanControlPower)
    hold on
    plot(mcr.cases, mcr.meanElecPower)
    % Create labels
    ylabel('Mean Power (W)');
    xlabel('Resistance (ohms)');
    % Set color bar and color map
    legend('Control Power', 'Elec Power')

    % Plot surface for controller power at each gain combination
    figure()
    plot(mcr.cases, mcr.maxControlForce)
    hold on
    plot(mcr.cases, mcr.maxForce)
    % Create labels
    ylabel('Max Force (N)');
    xlabel('Resistance (ohms)');
    % Set color bar and color map
    legend('Control Force', 'Gen Force')
end