function [damping, overDamping, stiffness, dampingExponent, stiffnessExponent] =...
    fuzzyLogicController(positionIn, velocityIn, waveHeightIn, averagePeriodIn)


%start = tic;
verbose = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define input membership functions %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Waveheight Input %%%

    % Low waveheight open trap MF
    fS.inputs.waveHeight.MFs.low.type = 'down step';
    fS.inputs.waveHeight.MFs.low.begin = 0.41;
    fS.inputs.waveHeight.MFs.low.finish = 1.40;
    fS.inputs.waveHeight.MFs.low.firing = 0;

    % Medium Low (Q1) waveheight triangular MF
    fS.inputs.waveHeight.MFs.medLow.type = 'triangle';
    fS.inputs.waveHeight.MFs.medLow.begin = 0.41;
    fS.inputs.waveHeight.MFs.medLow.peak = 1.40;
    fS.inputs.waveHeight.MFs.medLow.finish = 1.88;
    fS.inputs.waveHeight.MFs.medLow.firing = 0;

    % Medium (median) waveheight triangular MF
    fS.inputs.waveHeight.MFs.med.type = 'triangle';
    fS.inputs.waveHeight.MFs.med.begin = 1.40;
    fS.inputs.waveHeight.MFs.med.peak = 1.88;
    fS.inputs.waveHeight.MFs.med.finish = 2.65;
    fS.inputs.waveHeight.MFs.med.firing = 0;

    % Medium High (Q3) waveheight triangular MF
    fS.inputs.waveHeight.MFs.medHigh.type = 'triangle';
    fS.inputs.waveHeight.MFs.medHigh.begin = 1.88;
    fS.inputs.waveHeight.MFs.medHigh.peak = 2.65;
    fS.inputs.waveHeight.MFs.medHigh.finish = 10.43;
    fS.inputs.waveHeight.MFs.medHigh.firing = 0;

    % High waveheight open trap MF
    fS.inputs.waveHeight.MFs.high.type = 'step';
    fS.inputs.waveHeight.MFs.high.begin = 2.65;
    fS.inputs.waveHeight.MFs.high.finish = 10.43;
    fS.inputs.waveHeight.MFs.high.firing = 0;

%%% Average Wave Period Input %%%

    % Low period open trap MF
    fS.inputs.averagePeriod.MFs.short.type = 'down step';
    fS.inputs.averagePeriod.MFs.short.begin = 3.52;
    fS.inputs.averagePeriod.MFs.short.finish = 5.94;
    fS.inputs.averagePeriod.MFs.short.firing = 0;

    % Medium Low (Q1) period triangular MF
    fS.inputs.averagePeriod.MFs.midShort.type = 'triangle';
    fS.inputs.averagePeriod.MFs.midShort.begin = 3.52;
    fS.inputs.averagePeriod.MFs.midShort.peak = 5.94;
    fS.inputs.averagePeriod.MFs.midShort.finish = 6.81;
    fS.inputs.averagePeriod.MFs.midShort.firing = 0;

    % Medium (median) period triangular MF
    fS.inputs.averagePeriod.MFs.mid.type = 'triangle';
    fS.inputs.averagePeriod.MFs.mid.begin = 5.94;
    fS.inputs.averagePeriod.MFs.mid.peak = 6.81;
    fS.inputs.averagePeriod.MFs.mid.finish = 7.89;
    fS.inputs.averagePeriod.MFs.mid.firing = 0;

    % Medium High (Q3) period triangular MF
    fS.inputs.averagePeriod.MFs.midLong.type = 'triangle';
    fS.inputs.averagePeriod.MFs.midLong.begin = 6.81;
    fS.inputs.averagePeriod.MFs.midLong.peak = 7.89;
    fS.inputs.averagePeriod.MFs.midLong.finish = 12.97;
    fS.inputs.averagePeriod.MFs.midLong.firing = 0;

    % High period open trap MF
    fS.inputs.averagePeriod.MFs.long.type = 'step';
    fS.inputs.averagePeriod.MFs.long.begin = 7.89;
    fS.inputs.averagePeriod.MFs.long.finish = 12.97;
    fS.inputs.averagePeriod.MFs.long.firing = 0;

%%% Velocity Input %%%

    % Too fast Negative Velocity Limit
    fS.inputs.velocity.MFs.fastNeg.type = 'down step';
    fS.inputs.velocity.MFs.fastNeg.begin = -1;
    fS.inputs.velocity.MFs.fastNeg.finish = 0;
    fS.inputs.velocity.MFs.fastNeg.firing = 0;
    
    % In spec speeds
    fS.inputs.velocity.MFs.slow.type = 'triangle';
    fS.inputs.velocity.MFs.slow.begin = -1;
    fS.inputs.velocity.MFs.slow.peak = 0;
    fS.inputs.velocity.MFs.slow.finish = 1;
    fS.inputs.velocity.MFs.slow.firing = 0;
    
    % Too Fast Positive Velocity
    fS.inputs.velocity.MFs.fastPos.type = 'step';
    fS.inputs.velocity.MFs.fastPos.begin = 0;
    fS.inputs.velocity.MFs.fastPos.finish = 1;
    fS.inputs.velocity.MFs.fastPos.firing = 0;

%%% Position Input %%%

    % Too Negative Position Limit
    fS.inputs.position.MFs.low.type = 'down step';
    fS.inputs.position.MFs.low.begin = -1;
    fS.inputs.position.MFs.low.finish = -0.75;
    fS.inputs.position.MFs.low.firing = 0;
    
    % In spec speeds
    fS.inputs.position.MFs.middle.type = 'trap';
    fS.inputs.position.MFs.middle.begin = -1;
    fS.inputs.position.MFs.middle.asc = -0.75;
    fS.inputs.position.MFs.middle.dec = 0.75;
    fS.inputs.position.MFs.middle.finish = 1;
    fS.inputs.position.MFs.middle.firing = 0;
    
    % Too Positive Position
    fS.inputs.position.MFs.high.type = 'step';
    fS.inputs.position.MFs.high.begin = 0.75;
    fS.inputs.position.MFs.high.finish = 1;
    fS.inputs.position.MFs.high.firing = 0;

%%%%%%%%%%%%%%%%%%
%% Define Rules %%
%%%%%%%%%%%%%%%%%%
% Define Rules for outputs, Define Fuzzy Operators, (for speed and position, 
% any rule with multiple inputs), define each rule's implication method,
% define aggregation method for determining outputs for all rules 





%%%%%%%%%%%%%%%%%%
%% Fuzzify Inputs %%
%%%%%%%%%%%%%%%%%%
fS.inputs.waveHeight.MFs = evaluate_MFs(waveHeightIn, fS.inputs.waveHeight.MFs);
fS.inputs.position.MFs.high.firing = 0;
fS.inputs.averagePeriod.MFs = evaluate_MFs(averagePeriodIn, fS.inputs.averagePeriod.MFs);
fS.inputs.position.MFs.high.firing = 0;
fS.inputs.position.MFs = evaluate_MFs(positionIn, fS.inputs.position.MFs);
fS.inputs.position.MFs.high.firing = 0;
fS.inputs.velocity.MFs = evaluate_MFs(velocityIn, fS.inputs.velocity.MFs);

damping = 0; 
overDamping = 0;
stiffness = 0;
dampingExponent = 0;
stiffnessExponent = 0;

if verbose % print firings
    listInputs = fieldnames(fS.inputs);
    for i=1:numel(listInputs)
        firings = [];
        thisInput = fS.inputs.(listInputs{i});
        disp(listInputs{i});
        listMF = fieldnames(fS.inputs.(listInputs{i}).MFs);
        for l=1:numel(listMF)
             MF = fS.inputs.(listInputs{i}).MFs.(listMF{l});
             firings = [firings MF.firing];
        end
        disp(listInputs{i})
        disp('firings');
        disp(firings);
        
    end 

end

%% Apply Fuzzy Operator %%

%% Apply Implication for rules %%

%% Aggregation outputs for all rules %%



%%%%%%%%%%%%%%%%%%
%% End of Main %%
%%%%%%%%%%%%%%%%%%
% begin functions

% function Evaluated_MFs = evaluate_MFs(inValue, MFs)
%     listMFs = [];
%     thisMF = [];
%     MF_Type = [];
%     
%     % list of memberships for this input
%     listMFs = fieldnames(MFs);
% 
%     % go through each membership and 
%     for k=1:numel(listMFs)
%         thisMF = MFs.(listMFs{k});
% 
%         MF_Type = thisMF.type;
%         disp(thisMF);
%         disp(MF_Type);
% 
%         %calculate its firing strength based on
%         switch MF_Type
%             case 'triangle'
%                 % TODO: sanitize inputs (if not start -> peak -> finish)
%                 MFs.(listMFs{k}).firing = tri_MF(inValue,...
%                     thisMF.begin, thisMF.peak, thisMF.finish);
%             case 'step'
%                 MFs.(listMFs{k}).firing = open_trap_right(inValue,...
%                      thisMF.begin, thisMF.finish);
%             case 'down step'
%                  %sanitize inputs (if not start -> peak -> finish)
%                  MFs.(listMFs{k}).firing = open_trap_left(inValue,...
%                      thisMF.begin, thisMF.finish);
%             case 'trap'
%                  %sanitize inputs (if not start -> peak -> finish)
%                  MFs.(listMFs{k}).firing = trap(inValue,...
%                      thisMF.begin, thisMF.asc, thisMF.dec, thisMF.finish);
%         end
% 
%     end
% 
%     Evaluated_MFs = MFs;
% 
% end
% 
% function membership = tri_MF(inValue, begin, peak, finish)
% 
% % Evaluate input according to triangular input MF
% if inValue <= peak
%     if inValue < begin
%         membership = 0;
%     else
%         membership = (1/(peak - begin)) * (inValue-peak) + 1;
%     end
% elseif inValue > peak
%     if inValue > finish
%         membership = 0;
%     else
%         membership = (-1/(finish - peak)) * (inValue-peak) + 1;
%     end
% else
%     membership = 1;
% end
% 
% end
% 
% function membership = open_trap_left(inValue, begin, finish)
% 
% if inValue < begin
%      membership = 1;
%  elseif inValue > finish
%      membership = 0;
%  else
%      membership = (1/(begin - finish))*(inValue - begin) + 1;
% end
% 
% end
% 
% function membership = open_trap_right(inValue, begin, finish)
%  if inValue < begin
%      membership = 0;
%  elseif inValue > finish
%      membership = 1;
%  else
%      membership = (1/(finish - begin))*(inValue - finish) + 1;
%  end
% end
% 
% 
% function membership = trap(inValue, begin, asc, dec, finish)
%  if ( inValue < begin ) || ( inValue > finish )
%      membership = 0;
%  elseif inValue < asc
%      membership = (1/(asc-begin))*(inValue - begin);
%  elseif inValue > dec
%      membership = (1/(dec-finish))*(inValue - finish);
%  else
%      membership = 1;
%  end
% end

end
