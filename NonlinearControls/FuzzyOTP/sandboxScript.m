clear
clc

global verbose
verbose = 0;

positionIn = -0.88;
velocityIn = -1;
waveHeightIn = 2.3;
averagePeriodIn = 4.5;

overDamping = 0;

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

% if verbose % print percentTrues
%     listInputs = fieldnames(inputs);
%     
%     for i=1:numel(listInputs)
%         thisInput = inputs.(listInputs{i});
%         disp(listInputs{i});
%         listMF = fieldnames(inputs.(listInputs{i}).MFs);
%         
%         for l=1:numel(listMF)
%              MF = inputs.(listInputs{i}).MFs.(listMF{l});
%              fprintf('%s %s degree of truth: %f\n',(listInputs{i}),(listMF{l}),(MF.percentTrue));
% 
%         end
%     end 
% end

%% Define Rule antecedents and Apply Fuzzy Operators %%
% Rule 1 antecedent: If velocity is fast positive and position is high
ruleOneInputMFs = [inputs.velocity.MFs.fastPos.percentTrue  position.MFs.high.percentTrue];
ruleOneAntecedent = applyFuzzyOperator(ruleOneInputMFs, 'minAnd');
% if verbose
%     disp(ruleOneAntecedent);
% end

% Rule 2 antecedent: If position is middle
% Sinlge input rule does not require fuzzy operator
ruleTwoInputMF = [position.MFs.middle.percentTrue];
ruleTwoAntecedent = ruleTwoInputMF;
% if verbose
%     disp(ruleTwoAntecedent);
% end

% Rule 1 antecedent: If velocity is fast positive and position is high
ruleThreeInputMFs = [inputs.velocity.MFs.fastNeg.percentTrue  position.MFs.low.percentTrue];
ruleThreeAntecedent = applyFuzzyOperator(ruleThreeInputMFs, 'minAnd');
% if verbose
%     disp(ruleThreeAntecedent);
% end


%% Apply Implication for rules %%
% Specify membership functions for outputs and Generate Consequent Membership Functions

% Rule 1: If velocity is fast positive and position is high damping is
% overdamped
overDamped.type = 'triangle';
begin = 1; peak = 2; finish = 3;
overDamped.definingPoints = [begin peak finish];

% Rule 1 Consequent Membership Function
ruleOne = applyImplicationMethod(ruleOneAntecedent,overDamped,'min');

% if verbose
%     disp('rule one antecedent:')
%     disp(ruleOneAntecedent);
%     disp('rule one MF:');
%     disp(overDamped);
%     disp('Rule one implication: min');
%     disp(ruleOne);
% end

% Rule 3: If velocity is fast positive and position is high damping is
% overdamped
ruleThree = applyImplicationMethod(ruleThreeAntecedent,overDamped,'min');

% if verbose
%     disp('rule three antecedent:')
%     disp(ruleThreeAntecedent);
%     disp('rule three MF:');
%     disp(overDamped);
%     disp('Rule three implication: min');
%     disp(ruleThree);
% end

% Rule 2:  If position is middle damping is optimal
% Base Membership Function
optimal.type = 'triangle';
begin = 0; peak = 1; finish = 2;
optimal.definingPoints = [begin peak finish];

% Rule 2 Consequent Membership Function
ruleTwo = applyImplicationMethod(ruleTwoAntecedent,optimal,'min');

% if verbose
%     disp('rule two antecedent:')
%     disp(ruleTwoAntecedent);
%     disp('rule two MF:');
%     disp(optimal);
%     disp('Rule two implication: min');
%     disp(ruleTwo);
% end

% organize by: outputs -> membership functions -> rules
overdampingMultiplier.baseMFs.overDamped = overDamped;
overdampingMultiplier.CMFs.overDamped.ruleAggregation = 'max';
overdampingMultiplier.CMFs.overDamped.rules.ruleOne = ruleOne;
overdampingMultiplier.CMFs.overDamped.rules.ruleThree = ruleThree;

overdampingMultiplier.baseMFs.optimal = optimal;
overdampingMultiplier.CMFs.optimal.rules.ruleTwo = ruleTwo;
% organize by: outputs -> membership functions -> rules
overdampingMultiplier.range = [1 2];

%% Aggregate outputs for all rules %%

overdampingMultiplier2.aggregatedFunction = aggregateCMFs(overdampingMultiplier, 'sum');


%% Defuzzify aggregated output membership functions

 damping = 0;
 overDamping = 1%defuzzify(overdampingMultiplier, 'MOM');
 stiffness = 0;
 dampingExponent = 1;
 stiffnessExponent = 1;


%%%%%%%%%%%%%%%%%%
%% End of Main %%
%%%%%%%%%%%%%%%%%%
% begin functions
function fuzzufiedInput = fuzzifyInputs(inValue, MFs)
% Function to fuzzify crisp input variables
%
    % list of memberships for this input
    listMFs = fieldnames(MFs);

    % go through each membership and 
    for k=1:numel(listMFs)
        thisMF = MFs.(listMFs{k});

        mfType = thisMF.type;
%         if verbose
%             disp(mfType);
%             disp(thisMF);
%         end

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

    fuzzufiedInput = MFs;

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
    if (antecedent == 1) || (antecedent == 0) || strcmp(implicationMethod,'prod')
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
                outTri.definingPoints = zeros(1,4);
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

function mfTruth = evalMF(inValue, MF)
% Function to fuzzify crisp input variables
%
mfType = MF.type;
        %calculate its percentTrue strength based on
        switch mfType
            case 'triangle'
                % TODO: sanitize inputs (if not start -> peak -> finish)
                mfTruth = tri_MF(inValue,...
                    MF.definingPoints(1), MF.definingPoints(2), MF.definingPoints(3),  MF.maxVal);
            case 'step'
                mfTruth = open_trap_right(inValue,...
                     MF.definingPoints(1), MF.definingPoints(2), MF.maxVal);
            case 'down step'
                 %sanitize inputs (if not start -> peak -> finish)
                 mfTruth = open_trap_left(inValue,...
                     MF.definingPoints(1), MF.definingPoints(2), MF.maxVal);
            case 'trap'
                 %sanitize inputs (if not start -> peak -> finish)
                 mfTruth = trap(inValue,...
                     MF.definingPoints(1), MF.definingPoints(2), MF.definingPoints(3), MF.definingPoints(4), MF.maxVal);
            otherwise
                mfTruth = NaN;
                disp('membership function type not defined');
        end
end

function singleTruthFunction = performAgg(truthMatrix, aggregationMethod)
    switch aggregationMethod
        case 'max'
            singleTruthFunction = max(truthMatrix,[],1);
        case 'min'
            singleTruthFunction = min(truthMatrix,[],1);
        case 'mean'
            singleTruthFunction = mean(truthMatrix,[],1);
        case 'prod'
            singleTruthFunction = truthMatrix(1,:)
            for r = 2:length(truthMatrix(:,1))
                singleTruthFunction = truthMatrix(r,:).*singleTruthFunction;
            end
        case 'sum'
            singleTruthFunction = truthMatrix(1,:);
            if length(truthMatrix(:,1)) > 1
                for r = 2:length(truthMatrix(:,1))
                    singleTruthFunction = truthMatrix(r,:) + singleTruthFunction;
                end
            end
        otherwise
            disp('specified aggregation method not defined');
    end
end

function aggregatedMF = aggregateCMFs(outputName, aggregationMethod)

% aggregate rules for each MF of output
% aggregate MFs for each output

listStates = fieldnames(outputName.CMFs);
outMin = outputName.range(1);
outMax = outputName.range(2);

%get these from struct

% Loop to aggregate rules for each state/MF
for p=1:numel(listStates)
    thisCMF = outputName.CMFs.(listStates{p});
    
    listRules = fieldnames(thisCMF.rules);
    if numel(listRules) > 1
        if (thisCMF.ruleAggregation)
            ruleAgg = thisCMF.ruleAggregation;
        else
            disp('If multiple rules affect a member function a rule aggregation must be specified');
        end
    end
    
    % get unique list of defining points for this state (from all rules for
    % this state)

    ruleRangeMaxLength = 0;
    % loop to get the length of all defining points for this state
    for s=1:numel(listRules)
        thesePoints = outputName.CMFs.(listStates{p}).rules.(listRules{s}).definingPoints;
        ruleRangeMaxLength = ruleRangeMaxLength + numel(thesePoints);
    end
    
    %Assign all points to range vector
    fullRuleRange = NaN(1,ruleRangeMaxLength);
    fullRuleRangeIndex=1;
    for s=1:numel(listRules)
        thesePoints = outputName.CMFs.(listStates{p}).rules.(listRules{s}).definingPoints;
        for t = 1:numel(thesePoints)
            fullRuleRange(fullRuleRangeIndex) = thesePoints(t);
            fullRuleRangeIndex = fullRuleRangeIndex+1;
        end
        
    end
    
    % remove duplicates
    uniqueRuleRange = unique(fullRuleRange(~isnan(fullRuleRange)));

    
    % loop through comparing each rule and add any intersections to
    % defining points
    
    % first count the max number of points the intersections could add
    ruleIntersectionsMaxLength = 0;
    disp('counting intersections');
    for s=1:numel(listRules)
        compareRuleOne = thisCMF.rules.(listRules{s})
        
        for t = (s+1):numel(listRules)
            compareRuleTwo = thisCMF.rules.(listRules{t})
            
            ruleOneTruth = NaN(1,numel(uniqueRuleRange));
            ruleTwoTruth = NaN(1,numel(uniqueRuleRange));
            
            % create y values for each rule MF
            for m = 1:numel(uniqueRuleRange)
               uniqueRuleRange(m)
               ruleOneTruth(m) = evalMF(uniqueRuleRange(m),compareRuleOne);
               ruleTwoTruth(m) = evalMF(uniqueRuleRange(m),compareRuleTwo);
            end
            
            
            [ruleX, ~] = intersections(uniqueRuleRange, ruleOneTruth, uniqueRuleRange, ruleTwoTruth, true);
            ruleIntersectionsMaxLength = ruleIntersectionsMaxLength + numel(ruleX);
        end
    end
    
    rangeWithIntersections = NaN(1,numel(ruleIntersectionsMaxLength));
    
    % Now go through and assign
    intersectionIndex = 1;
    disp('assigning intersections');
    for s=1:numel(listRules)
        compareRuleOne = thisCMF.rules.(listRules{s})
        
        for t = (s+1):numel(listRules)
            compareRuleTwo = thisCMF.rules.(listRules{t})
            
            ruleOneTruth = NaN(1,numel(uniqueRuleRange));
            ruleTwoTruth = NaN(1,numel(uniqueRuleRange));
            
            % create y values for each rule MF
            for m = 1:numel(uniqueRuleRange)
               uniqueRuleRange(m)
               ruleOneTruth(m) = evalMF(uniqueRuleRange(m),compareRuleOne);
               ruleTwoTruth(m) = evalMF(uniqueRuleRange(m),compareRuleTwo);
            end
            
            
            [ruleX, ~] = intersections(uniqueRuleRange, ruleOneTruth, uniqueRuleRange, ruleTwoTruth, true);
            ruleIntersections = ruleX'
            for n = 1:numel(ruleIntersections(1,:))
                rangeWithIntersections(intersectionIndex) = ruleIntersections(1,n);
            end
        end
    end
    
    % eliminate duplicates
    uniqueRangeIntersections = unique(rangeWithIntersections( ~isnan(rangeWithIntersections)));
    
    % Now we have the list of output values which define the corners and
    % possible intersections of all rules for this MF state
    finalOutRange = [uniqueRangeIntersections  uniqueRuleRange];
    uniqueFinalRange = unique(finalOutRange(~isnan(finalOutRange)));
    
    
    stateRulesMat = zeros(numel(listRules),numel(uniqueFinalRange));
    
    for row=1:numel(listRules)
        thisRule = thisCMF.rules.(listRules{row});
        for col = 1:numel(uniqueFinalRange)
            stateRulesMat(row,col) = evalMF(uniqueFinalRange(col),thisRule)
        end
    end
    
%     if 1
%         disp('rule range');
%         disp(uniqueFinalRange);
%         disp('state Rules Mat');
%         disp(stateRulesMat);
%         disp('aggregated');
%         disp(performAgg(stateRulesMat, aggregationMethod));
%     end
    % aggregate them
    outVari.(listStates{p}).func = [uniqueFinalRange; performAgg(stateRulesMat, aggregationMethod)];
        
%end
% TODO I'm going to need the intersections here too...?
% outRange = [outMin outMax];
% stateList = fieldnames(outVari);
% 
% for p = 1:numel(stateList)
%     thisState = outVari.(stateList{p});
%     outRange = unique([outRange thisState.func(1,:)]);
% end
% 
% %outRange = outRange(outRange >= outMin);
% %outRange = outRange(outRange <= outMax);
% 
% stateOutMat = zeros(numel(stateList),numel(outRange));
% for row = 1:numel(stateList)
%     thisFuncX = outVari.(stateList{row}).func(1,:);
%     thisFuncT = outVari.(stateList{row}).func(2,:);
%     for col = 1:numel(outRange)
%         if (outRange(col) > max(thisFuncX)) || (outRange(col) < min(thisFuncX))
%             stateOutMat(row,col) = interp1(thisFuncX,thisFuncT,outRange(col),'nearest','extrap');
%         else
%             stateOutMat(row,col) = interp1(thisFuncX,thisFuncT,outRange(col),'linear');
%         end
%     end
 end
% 
% aggregatedFunction = performAgg(stateOutMat, aggregationMethod);
% aggregatedMF = [outRange; aggregatedFunction];
aggregatedMF = 0;
 end
% 
% function crisp = defuzzify(outputFun, defuzzificationMethod)
% outMin = outputFun.range(1);
% outMax = outputFun.range(2);
% func = outputFun.aggregatedFunction;
% switch defuzzificationMethod
%     case 'centroid'
%         crisp = getCentroidX(func);
%     case 'bisector'
%         crisp = bisectSearch(func,min(func(1,:)),max(func(1,:)));
%     case 'LOM'
%         crisp = maxima(func,'largest');
%     case 'MOM'
%         crisp = maxima(func,'mean');
%     case 'SOM'
%         crisp = maxima(func,'smallest');
%     otherwise disp('Specified defuzzification method not defined');
% end
% 
% if crisp > outMax
%     crisp = outMax;
% elseif crisp < outMin
%     crisp = outMin;
% end
% 
% end
% 
% function centroX = getCentroidX(curve)
% 
%     polyin = polyshape(curve','Simplify',true);
%     polyin = simplify(polyin,'KeepCollinearPoints',false);
%     [x,~] = centroid(polyin);    
%     centroX = x;
% end
% 
% function xBisect = bisectSearch(curve,searchMin,seaarchMax)
%     
%     fullX = curve(1,:);
%     fullY = curve(2,:);
% 
%     totalArea = trapz(fullX,fullY);
%     
%     midX = (searchMin + seaarchMax)/2;
%     midY = interp1(fullX,fullY,midX,'linear');
%     
%     
%     halfXTest = [fullX(fullX < midX) midX];
%     halfYTestLen = numel(fullX(fullX < midX));
%     halfYTest = [fullY(1:halfYTestLen) midY];
%     halfAreaTest = trapz(halfXTest,halfYTest);
%     
%     if round(halfAreaTest,4) == round(0.5*totalArea,4)
%         xBisect = midX;
%     elseif halfAreaTest > 0.5*totalArea
%         xBisect = bisectSearch(curve,searchMin,midX);
%     elseif halfAreaTest < 0.5*totalArea
%         xBisect = bisectSearch(curve,midX,seaarchMax);
%     end
% end
% 
% function aMax = maxima(curve,type)
% 
% fullX = curve(1,:);
% fullY = curve(2,:);
% 
% % if there is a single most true point
% if size(fullY(fullY == max(fullY))) == 1
%     % return the x
%     aMax = fullX(find(fullY==max(fullY)));
% else
%     switch type
%         case 'largest'
%             % largest = highest absolute value 
%             maximaXs = fullX(find(fullY==max(fullY)));
%             maximaXsMag = abs(maximaXs);
%             
%             if size(maximaXsMag(maximaXsMag == max(maximaXsMag))) == 1
%                 % if there's only 1, return the x
%                 aMax = maximaXs(find(maximaXsMag==max(maximaXsMag)));
%             else
%                 % if there's a tie (i.e. the corresponding positive and
%                 % negative x are both the most true) return the negative
%                 % one
%                 aMax = maximaXs(find(maximaXs==-1*max(maximaXsMag)));
%             end
%         case 'mean'
%             maximaXs = fullX(find(fullY==max(fullY)));
%             aMax = (max(maximaXs) + min(maximaXs))/2;
%             %if there are two separate max plateaus, should their average be
%             %weighted?, like find the middle of both plateaus, and take an average
%             %of the MOMs weighted by their length?? too complicated
%         case 'smallest'
%             % smallest = lowest absolute value 
%             maximaXs = fullX(find(fullY==max(fullY)));
%             maximaXsMag = abs(maximaXs);
%             
%             if size(maximaXsMag(maximaXsMag == max(maximaXsMag))) == 1
%                 % if there's only 1, return the x
%                 aMax = maximaXs(find(maximaXsMag==max(maximaXsMag)));
%             else
%                 % if there's a tie (i.e. the corresponding positive and
%                 % negative x are both the most true values) return the 
%                 % negative one
%                 aMax = maximaXs(find(maximaXs==-1*max(maximaXsMag)));
%             end
%     end
% 
% end
% 
% end
% 
% 
% % classdef generalMF
% %     properties
% %     end
% %     methods
% %     end
% % end
% % 
% % classdef consequentMF
% % 
% % end

