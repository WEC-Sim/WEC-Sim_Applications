function [damping, overDamping, stiffness, dampingExponent, stiffnessExponent] =...
    fuzzyLogicController(positionIn, velocityIn, waveHeightIn, averagePeriodIn)


%start = tic;
verbose = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define input membership functions %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Waveheight Input %%%

% Low waveheight open trap MF
waveHeight.MFs.low.type = 'down step';
begin = 0.41; finish = 1.40; 
waveHeight.MFs.low.definingPoints = [begin finish];
waveHeight.MFs.low.percentTrue = 0;

% Medium Low (Q1) waveheight triangular MF
waveHeight.MFs.medLow.type = 'triangle';
begin = 0.41; peak = 1.40; finish = 1.88;
waveHeight.MFs.medLow.definingPoints = [begin peak finish];
waveHeight.MFs.medLow.percentTrue = 0;

% Medium (median) waveheight triangular MF
waveHeight.MFs.med.type = 'triangle';
begin = 1.40; peak = 1.88; finish = 2.65;
waveHeight.MFs.med.definingPoints = [begin peak finish];
waveHeight.MFs.med.percentTrue = 0;

% Medium High (Q3) waveheight triangular MF
waveHeight.MFs.medHigh.type = 'triangle';
begin = 1.88; peak = 2.65; finish = 10.43;
waveHeight.MFs.medHigh.definingPoints = [begin peak finish];
waveHeight.MFs.medHigh.percentTrue = 0;

% High waveheight open trap MF
waveHeight.MFs.high.type = 'step';
begin = 2.65; finish = 10.43;
waveHeight.MFs.high.definingPoints = [begin finish];
waveHeight.MFs.high.percentTrue = 0;

%%% Average Wave Period Input %%%

% Low period open trap MF
averagePeriod.MFs.short.type = 'down step';
begin = 3.52; finish = 5.94;
averagePeriod.MFs.short.definingPoints = [begin finish];
averagePeriod.MFs.short.percentTrue = 0;

% Medium Low (Q1) period triangular MF
averagePeriod.MFs.midShort.type = 'triangle';
begin = 3.52; peak = 5.94; finish = 6.81;
averagePeriod.MFs.midShort.definingPoints = [begin peak finish];
averagePeriod.MFs.midShort.percentTrue = 0;

% Medium (median) period triangular MF
averagePeriod.MFs.mid.type = 'triangle';
begin = 5.94; peak = 6.81; finish = 7.89;
averagePeriod.MFs.mid.definingPoints = [begin peak finish];
averagePeriod.MFs.mid.percentTrue = 0;

% Medium High (Q3) period triangular MF
averagePeriod.MFs.midLong.type = 'triangle';
begin = 6.81; peak = 7.89; finish = 12.97;
averagePeriod.MFs.midLong.definingPoints = [begin peak finish];
averagePeriod.MFs.midLong.percentTrue = 0;

% High period open trap MF
averagePeriod.MFs.long.type = 'step';
begin = 7.89; finish = 12.97;
averagePeriod.MFs.long.definingPoints = [begin finish];
averagePeriod.MFs.long.percentTrue = 0;

%%% Velocity Input %%%

% Too fast Negative Velocity Limit
velocity.MFs.fastNeg.type = 'down step';
begin = -1; finish = 0;
velocity.MFs.fastNeg.definingPoints = [begin finish];
velocity.MFs.fastNeg.percentTrue = 0;

% In spec speeds
velocity.MFs.slow.type = 'triangle';
begin = -1; peak = 0; finish = 1;
velocity.MFs.slow.definingPoints = [begin peak finish];
velocity.MFs.slow.percentTrue = 0;

% Too Fast Positive Velocity
velocity.MFs.fastPos.type = 'step';
begin = 0; finish = 1;
velocity.MFs.fastPos.definingPoints = [begin finish];
velocity.MFs.fastPos.percentTrue = 0;

%%% Position Input %%%

% Too Negative Position Limit
position.MFs.low.type = 'down step';
begin = -1; finish = -0.75;
position.MFs.low.definingPoints = [begin finish];
position.MFs.low.percentTrue = 0;

% In spec speeds
position.MFs.middle.type = 'trap';
begin = -1; asc = -0.75; dec = 0.75; finish = 1;
position.MFs.middle.definingPoints = [begin asc dec finish];
position.MFs.middle.percentTrue = 0;

% Too Positive Position
position.MFs.high.type = 'step';
begin = 0.75; finish = 1;
position.MFs.high.definingPoints = [begin finish];
position.MFs.high.percentTrue = 0;

%%%%%%%%%%%%%%%%%%
%% Define Rules %%
%%%%%%%%%%%%%%%%%%
% Define Rules for outputs, Define Fuzzy Operators, (for speed and position, 
% any rule with multiple inputs), define each rule's implication method,
% define aggregation method for determining outputs for all rules 





%%%%%%%%%%%%%%%%%%
%% Fuzzify Inputs %%
%%%%%%%%%%%%%%%%%%
waveHeight.MFs = fuzzifyInputs(waveHeightIn, waveHeight.MFs);
averagePeriod.MFs = fuzzifyInputs(averagePeriodIn, averagePeriod.MFs);
position.MFs = fuzzifyInputs(positionIn, position.MFs);
velocity.MFs = fuzzifyInputs(velocityIn, velocity.MFs);

inputs.waveHeight = waveHeight;
inputs.averagePeriod = averagePeriod;
inputs.position = position;
inputs.velocity = velocity;

if verbose % print percentTrues
    listInputs = fieldnames(inputs);
    
    for i=1:numel(listInputs)
        thisInput = inputs.(listInputs{i});
        disp(listInputs{i});
        listMF = fieldnames(inputs.(listInputs{i}).MFs);
        
        for l=1:numel(listMF)
             MF = inputs.(listInputs{i}).MFs.(listMF{l});
             fprintf('%s %s degree of truth: %f\n',(listInputs{i}),(listMF{l}),(MF.percentTrue));

        end
    end 
end

%% Define Rule antecedents and Apply Fuzzy Operators %%
% Rule 1 antecedent: If velocity is fast positive and position is high
ruleOneInputMFs = [inputs.velocity.MFs.fastPos.percentTrue  position.MFs.high.percentTrue];
ruleOneAntecedent = applyFuzzyOperator(ruleOneInputMFs, 'minAnd');
if verbose
    disp(ruleOneAntecedent);
end

% Rule 2 antecedent: If position is middle
% Sinlge input rule does not require fuzzy operator
ruleTwoInputMF = [position.MFs.middle.percentTrue];
ruleTwoAntecedent = ruleTwoInputMF;
if verbose
    disp(ruleTwoAntecedent);
end

% Rule 1 antecedent: If velocity is fast positive and position is high
ruleThreeInputMFs = [inputs.velocity.MFs.fastNeg.percentTrue  position.MFs.low.percentTrue];
ruleThreeAntecedent = applyFuzzyOperator(ruleThreeInputMFs, 'minAnd');
if verbose
    disp(ruleThreeAntecedent);
end


%% Apply Implication for rules %%
% Specify membership functions for outputs and Generate Consequent Membership Functions

% Rule 1: If velocity is fast positive and position is high damping is
% overdamped
overDamped.type = 'triangle';
begin = 1; peak = 2; finish = 3;
overDamped.definingPoints = [begin peak finish];

% Rule 1 Consequent Membership Function
ruleOne = applyImplicationMethod(ruleOneAntecedent,overDamped,'min');

% Rule 3: If velocity is fast positive and position is high damping is
% overdamped
ruleThree = applyImplicationMethod(ruleThreeAntecedent,overDamped,'min');

% Rule 2:  If position is middle damping is optimal
% Base Membership Function
optimal.type = 'triangle';
begin = 0; peak = 1; finish = 2;
optimal.definingPoints = [begin peak finish];
optimal.antecedent = ruleTwoAntecedent;


% Rule 2 Consequent Membership Function
ruleTwo = applyImplicationMethod(ruleOneAntecedent,optimal,'prod');

if verbose
    disp(ruleOne);
    disp(ruleTwo);
    disp(ruleThree);
end

% organize by: outputs -> membership functions -> rules
overdampingMultiplier.CMFs.overDamped = overDamped;
overdampingMultiplier.CMFs.overDamped.ruleOne = ruleOne;
overdampingMultiplier.CMFs.overDamped.ruleThree = ruleThree;

overdampingMultiplier.CMFs.optimal = optimal;
overdampingMultiplier.CMFs.optimal.ruleTwo = ruleTwo;

% organize by: outputs -> membership functions -> rules
outputs.overdampingMultiplier = overdampingMultiplier;

%% Aggregate outputs for all rules %%

damping = 0; 
overDamping = 0;
stiffness = 0;
dampingExponent = 0;
stiffnessExponent = 0;

%%%%%%%%%%%%%%%%%%
%% End of Main %%
%%%%%%%%%%%%%%%%%%
% begin functions
end
function Evaluated_MFs = fuzzifyInputs(inValue, MFs)
% Function to fuzzify crisp input variables
%
    verbose = 1;
    
    % list of memberships for this input
    listMFs = fieldnames(MFs);

    % go through each membership and 
    for k=1:numel(listMFs)
        thisMF = MFs.(listMFs{k});

        mfType = thisMF.type;
        if verbose
            disp(mfType);
            disp(thisMF);
        end

        %calculate its percentTrue strength based on
        switch mfType
            case 'triangle'
                % TODO: sanitize inputs (if not start -> peak -> finish)
                MFs.(listMFs{k}).percentTrue = tri_MF(inValue,...
                    MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).definingPoints(3), 1);
            case 'step'
                MFs.(listMFs{k}).percentTrue = open_trap_right(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), 1);
            case 'down step'
                 %sanitize inputs (if not start -> peak -> finish)
                 MFs.(listMFs{k}).percentTrue = open_trap_left(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), 1);
            case 'trap'
                 %sanitize inputs (if not start -> peak -> finish)
                 MFs.(listMFs{k}).percentTrue = trap(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).definingPoints(3), MFs.(listMFs{k}).definingPoints(4), 1);
            otherwise
                disp('membership function type not defined');
        end

    end

    Evaluated_MFs = MFs;

end

function membership = tri_MF(inValue, begin, peak, finish, maxTruth)

% Evaluate input according to triangular input MF
if inValue < peak
    if inValue <= begin
        membership = 0;
    else
        membership = (maxTruth/(peak - begin)) * (inValue-peak) + maxTruth;
    end
elseif inValue > peak
    if inValue >= finish
        membership = 0;
    else
        membership = ((-1*maxTruth)/(finish - peak)) * (inValue-peak) + maxTruth;
    end
else
    membership = maxTruth;
    
end

end

function membership = open_trap_left(inValue, begin, finish, maxTruth)

if inValue < begin
     membership = maxTruth;
 elseif inValue > finish
     membership = 0;
 else
     membership = (maxTruth/(begin - finish))*(inValue - begin) + maxTruth;
end

end

function membership = open_trap_right(inValue, begin, finish, maxTruth)
 if inValue < begin
     membership = 0;
 elseif inValue > finish
     membership = maxTruth;
 else
     membership = (maxTruth/(finish - begin))*(inValue - finish) + maxTruth;
 end
end

function membership = trap(inValue, begin, asc, dec, finish, maxTruth)
 if ( inValue < begin ) || ( inValue > finish )
     membership = 0;
 elseif inValue < asc
     membership = (maxTruth/(asc-begin))*(inValue - begin);
 elseif inValue > dec
     membership = (maxTruth/(dec-finish))*(inValue - finish);
 else
     membership = maxTruth;
 end
end


function antecedentTruth = applyFuzzyOperator(inputMembershipTruth, fuzzyOperator)
    % applies a fuzzy operator to produce a single 
    % antecedent value for multi-input fuzzy rules
    % Inputs: 
    %       inputMembershipTruth : vector of analog truth values for
    %       input membership function values relevant to rule
    %       fuzzyOperator: Fuzzy operator to select a single truth value for the
    %       antecedent of the rule
    switch fuzzyOperator
        case 'minAnd'
            antecedentTruth = min(inputMembershipTruth);
        case 'prodAnd'
            antecedentTruth = prod(inputMembershipTruth);
        case 'maxOr'
            antecedentTruth = max(inputMembershipTruth);
        case 'average'
            antecedentTruth = mean(inputMembershipTruth);
        otherwise
            disp('Specified Fuzzy Operator is not defined');
    end
end

function consequentMF = applyImplicationMethod(antecedent, outputMembership, implicationMethod)
    if (antecedent == 1) || strcmp(implicationMethod,'prod')
        outCopy = outputMembership;
        outCopy.maxVal = antecedent;
        consequentMF = outCopy;
    elseif strcmp(implicationMethod,'min')
        switch outputMembership.type
            case 'trap'
                outTrap = outputMembership;
                outTrap.maxVal = antecedent;
                outTrap.definingPoints(2) = antecedent * (outputMembership.definingPoints(2) - outputMembership.definingPoints(1)) + outputMembership.definingPoints(1);
                outTrap.definingPoints(3) = antecedent * (outputMembership.definingPoints(3) - outputMembership.definingPoints(4)) + outputMembership.definingPoints(4);
                consequentMF = outTrap;
            case 'step'
                outStep = outputMembership;
                outStep.maxVal = antecedent;
                outStep.definingPoints(2) = antecedent * (outputMembership.definingPoints(2) - outputMembership.definingPoints(1)) + outputMembership.definingPoints(1);
                consequentMF = outStep;
            case 'down step'
                outDownStep = outputMembership;
                outDownStep.definingPoints(1) = antecedent * (outputMembership.definingPoints(1) - outputMembership.definingPoints(2)) + outputMembership.definingPoints(2);
                outDownStep.maxVal = antecedent;
                consequentMF = outDownStep;
            case 'triangle' % Chop the top off
                outTri.type = 'trap';
                outTri.definingPoints = zeros(4);
                outTri.definingPoints(1) = outputMembership.definingPoints(1);
                outTri.definingPoints(4) = outputMembership.definingPoints(3);
                outTri.definingPoints(2) = antecedent * (outputMembership.definingPoints(2) - outputMembership.definingPoints(1)) + outputMembership.definingPoints(1);
                outTri.definingPoints(3) = antecedent * (outputMembership.definingPoints(2) - outputMembership.definingPoints(3)) + outputMembership.definingPoints(3);
                outTri.maxVal = antecedent;
                consequentMF = outTri;
            otherwise
                disp('membership function specified for output not defined');
        end
    else
        disp('Specified implication method is not defined');
        consequentMF = 0;
    end
end

% classdef generalMF
%     properties
%     end
%     methods
%     end
% end
% 
% classdef consequentMF
% 
% end


