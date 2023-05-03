function pred = fexcPrediction(pastAndCurrentFe, HpInk, Ho, order)
%% Purpose: Prediction excitation force Fe from previous data
    
% ADAPATIVE LEAST SQUARES LINEAR REGRESSION to calculate Alphas
% Build matrices row by row in for loop, then feed to matlab function to
% get linear alpha coefficients (the "B" matrix in Matlab's regression)

for h = 0:Ho                                    % Each loop builds a row to Hp+1 total rows   %100
    Y(h+1,1) = pastAndCurrentFe(end-h);                              % Y Matrix: Fe(k) to Fe(K-h)
    X(h+1,:) = fliplr(pastAndCurrentFe(end-h-order:end-h-1)');
    %X(h+1,:) = fliplr(pastAndCurrentFe(end-h-prediction.order:end-h-1)'); % X Matrix: Ho-1 rows, prediction.order columns
end

alphas = regress(Y,X);

% FE PREDICTION using single set of alpha values
% Fe(k+1|k) = alpha1*Fe(k) + alpha2*Fe(K-1),
% Fe(k+2|k) = alpha1*Fe(k+1|k) + alpha2*Fe(K) ...
% Have to build the pastCurrentAndFuture to accomodate that

pastCurrentAndFuture = pastAndCurrentFe;
indexForCurrentFe = size(pastCurrentAndFuture,1);

for h = 1:HpInk
%for h = 1:mpcStruct.HpSeconds/est.Ts     % Used if trying to run prediction @ %est.Ts instead of mpcStruct.Ts
   pastCurrentAndFuture(indexForCurrentFe+h) = 0;                              
    for j = 1:order
       pastCurrentAndFuture(indexForCurrentFe+h) = pastCurrentAndFuture(indexForCurrentFe+h) + alphas(j)*pastCurrentAndFuture(indexForCurrentFe+h-j); 
    end
end

currentAndFutureFe(:) = pastCurrentAndFuture(indexForCurrentFe:end); % Current = currentAndFutureFe(1). Biggest prediction = currentAndFutureFe(end)

pred = currentAndFutureFe';
%endfunction
