function aggregatedMF = aggregateCMFs(outputName)

listCMFs = fieldnames(outputName.CMFs);
outMin = outputName.range(1);
outMax = outputName.range(2);

%get these from struct
fullOutRange = [];
for p=1:numel(listCMFs)
    thisCMF = outputName.CMFs.(listCMFs{p});
    
    fullOutRange = unique([fullOutRange thisCMF.definingPoints]);
end

% Get these with functions (but each for all x3)
for p=1:numel(listCMFs)
    CMF1 = outputName.CMFs.(listCMFs{p});
    
    for q = (p+1):numel(listCMFs)
        CMF2 = outputName.CMFs.(listCMFs{q});
        CMF1_Truth = [];
        CMF2_Truth = [];
        
        for m = 1:numel(fullOutRange)
           CMF1_Truth = [CMF1_Truth evalMF(fullOutRange(m),CMF1)];
           CMF2_Truth = [CMF2_Truth evalMF(fullOutRange(m),CMF2)];
        end
        
        CMF_Intersections = InterX([fullOutRange;CMF1_Truth],[fullOutRange; CMF2_Truth]);
        
        fullOutRange = unique([fullOutRange CMF_Intersections(1,:)]);
        
        fullOutRange = fullOutRange(fullOutRange >= outMin);
        fullOutRange = fullOutRange(fullOutRange <= outMax);
    end
end


for m = 1:numel(x3)
    y1(m) = trap(x3(m), 3, 5, 8, 10, 0.5);
    y2(m) = tri_MF(x3(m), 6, 11, 15, 1);
end

y3 = max(y1,y2);

plot(x3,y1,x3,y2,x3,y3);

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

function mfTruth = evalMF(inValue, MF)
% Function to fuzzify crisp input variables
%
        %calculate its percentTrue strength based on
        switch mfType
            case 'triangle'
                % TODO: sanitize inputs (if not start -> peak -> finish)
                mfTruth = tri_MF(inValue,...
                    MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).definingPoints(3),  MFs.(listMFs{k}).maxVal);
            case 'step'
                mfTruth = open_trap_right(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).maxVal);
            case 'down step'
                 %sanitize inputs (if not start -> peak -> finish)
                 mfTruth = open_trap_left(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).maxVal);
            case 'trap'
                 %sanitize inputs (if not start -> peak -> finish)
                 mfTruth = trap(inValue,...
                     MFs.(listMFs{k}).definingPoints(1), MFs.(listMFs{k}).definingPoints(2), MFs.(listMFs{k}).definingPoints(3), MFs.(listMFs{k}).definingPoints(4), MFs.(listMFs{k}).maxVal);
            otherwise
                disp('membership function type not defined');
        end
end