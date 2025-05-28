function [phiInt, piInt, etaInt] = fitCurves(psiInstantaneous, psiVec, etaTurbVec, piVarVec, phiVec)
    % psiInstantaneous = clip(psiInstantaneous, min(psi), max(psi));
    if psiInstantaneous > max(psiVec)
        psiInstantaneous = max(psiVec);
    elseif psiInstantaneous < min(psiVec)
        psiInstantaneous = min(psiVec);
    end
    
    % Interpolate for the phi Value
    phiInt = interp1(psiVec, phiVec, psiInstantaneous);
    
    % Interpolate for the Pi Value
    piInt = interp1(psiVec, piVarVec, psiInstantaneous);
    
    % Interpolate for the eta Value
    etaInt = interp1(psiVec, etaTurbVec, psiInstantaneous);

end