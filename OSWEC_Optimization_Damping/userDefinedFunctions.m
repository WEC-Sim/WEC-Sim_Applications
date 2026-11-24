% userDefinedFunctions.m
% For each MCR case:
% calculate mean absorbed power.
% After all MCR cases:
% calculate weighted AEP for each damping value.

%% Detect MCR run

isMcrRun = exist('mcr', 'var') && exist('imcr', 'var') && isfield(mcr, 'cases');

if ~isMcrRun
    return
end

%% Results setup

project_folder = fileparts(which('wecSimInputFile.m'));
results_folder = fullfile(project_folder, 'mcr_results');

if ~exist(results_folder, 'dir')
    mkdir(results_folder);
end

case_results_mat = fullfile(results_folder, 'oswec_mcr_case_results.mat');
case_results_csv = fullfile(results_folder, 'oswec_mcr_case_results.csv');
summary_csv = fullfile(results_folder, 'oswec_damping_summary.csv');
summary_mat = fullfile(results_folder, 'oswec_damping_summary.mat');

nCases = size(mcr.cases, 1);

%% Initialize storage on first MCR case

if imcr == 1

    caseNumber = NaN(nCases, 1);
    Hm0 = NaN(nCases, 1);
    Tp = NaN(nCases, 1);
    Te = NaN(nCases, 1);
    probability = NaN(nCases, 1);
    damping = NaN(nCases, 1);
    meanPower_W = NaN(nCases, 1);

    save(case_results_mat, ...
        'caseNumber', ...
        'Hm0', ...
        'Tp', ...
        'Te', ...
        'probability', ...
        'damping', ...
        'meanPower_W');

end

%% Load accumulated results

load(case_results_mat, ...
    'caseNumber', ...
    'Hm0', ...
    'Tp', ...
    'Te', ...
    'probability', ...
    'damping', ...
    'meanPower_W');

%% Current MCR case metadata

% Python MCR file should use:
%   mcr.header = {'waves.height','waves.period','pto(1).damping'}
%   mcr.cases(:,1) = Hm0
%   mcr.cases(:,2) = Tp
%   mcr.cases(:,3) = PTO damping

caseNumber(imcr) = imcr;
Hm0(imcr) = mcr.cases(imcr, 1);
Tp(imcr) = mcr.cases(imcr, 2);
damping(imcr) = mcr.cases(imcr, 3);

if isfield(mcr, 'Te')
    Te_values = mcr.Te(:);
    Te(imcr) = Te_values(imcr);
else
    Te(imcr) = NaN;
end

if isfield(mcr, 'probability')
    probability_values = mcr.probability(:);
    probability(imcr) = probability_values(imcr);
else
    probability(imcr) = 1;
end

%% Calculate mean absorbed power

flapPitchVelocity = output.bodies(1).velocity(:, 5);

power_W = pto(1).damping .* flapPitchVelocity.^2;
meanPower_W(imcr) = mean(power_W, 'omitnan');

%% Save current case result

save(case_results_mat, ...
    'caseNumber', ...
    'Hm0', ...
    'Tp', ...
    'Te', ...
    'probability', ...
    'damping', ...
    'meanPower_W');

caseResults = table( ...
    caseNumber, ...
    Hm0, ...
    Tp, ...
    Te, ...
    probability, ...
    damping, ...
    meanPower_W, ...
    'VariableNames', { ...
        'caseNumber', ...
        'Hm0', ...
        'Tp', ...
        'Te', ...
        'probability', ...
        'PTO_DAMPING', ...
        'meanPower_W' ...
    });

writetable(caseResults, case_results_csv);

fprintf('Saved MCR result %d of %d\n', imcr, nCases);

%% Final case: summarize AEP by damping

if imcr == nCases

    dampingValues = unique(damping);
    nDamping = numel(dampingValues);

    weightedMeanPower_W = NaN(nDamping, 1);
    weightedMeanPower_kW = NaN(nDamping, 1);
    meanAnnualEnergy_kWh = NaN(nDamping, 1);

    for i = 1:nDamping

        rows = damping == dampingValues(i);

        p = probability(rows);
        p = p ./ sum(p, 'omitnan');

        P = meanPower_W(rows);

        weightedMeanPower_W(i) = sum(p .* P, 'omitnan');
        weightedMeanPower_kW(i) = weightedMeanPower_W(i) / 1000;
        meanAnnualEnergy_kWh(i) = weightedMeanPower_kW(i) * 8760;

    end

    dampingSummary = table( ...
        dampingValues, ...
        weightedMeanPower_W, ...
        weightedMeanPower_kW, ...
        meanAnnualEnergy_kWh, ...
        'VariableNames', { ...
            'PTO_DAMPING', ...
            'weightedMeanPower_W', ...
            'weightedMeanPower_kW', ...
            'meanAnnualEnergy_kWh' ...
        });

    dampingSummary = sortrows(dampingSummary, ...
        'meanAnnualEnergy_kWh', ...
        'descend');

    writetable(dampingSummary, summary_csv);

    save(summary_mat, ...
        'dampingSummary', ...
        'caseResults');

    fprintf('\nMCR damping optimization complete.\n');
    disp(dampingSummary);

    fprintf('Best PTO damping: %.3e\n', dampingSummary.PTO_DAMPING(1));
    fprintf('Best AEP: %.3f kWh/year\n', dampingSummary.meanAnnualEnergy_kWh(1));
    fprintf('Saved summary: %s\n\n', summary_csv);

end