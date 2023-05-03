%% User Defined Functions for MCR run
controllersOutput = controller1_out;
signals = {'force','power'};
for ii = 1:length(controllersOutput)
    for jj = 1:length(signals)
        controllersOutput(ii).(signals{jj}) =  controllersOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
    end
end

endInd = length(controllersOutput.time);
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time - startTime));

mcr.meanPower(imcr) = mean(controllersOutput.power(startInd:endInd,3));
mcr.meanForce(imcr) = mean(controllersOutput.force(startInd:endInd,3));

mcr.maxPower(imcr) = max(controllersOutput.power(startInd:endInd,3));
mcr.maxForce(imcr) = max(controllersOutput.force(startInd:endInd,3));

if imcr == length(mcr.cases)
    figure()
    plot(mcr.cases,mcr.meanPower)
    title('Mean Power vs. Latching Time')
    xlabel('Latching Time (s)')
    ylabel('Mean Power (W)')
    xline(2.6666, '--')
    legend('','Theoretical Optimal')
end