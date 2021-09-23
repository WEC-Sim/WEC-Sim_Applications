% Example running traditional Morison Element vs hydrodynamic body
% comparison

casedir = {"morisonElement","hydroBody"};

for ii = 1:length(casedir)
    cd(casedir{ii})
    wecSimFcn
    cd ..
end

plotTraditionalME
    