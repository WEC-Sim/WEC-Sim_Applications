% Example running traditional Morison Element vs hydrodynamic body
% comparison

casedir = {"morisonElement","monpile"};

for ii = 1:length(casedir)
    cd(casedir{ii})
    wecSimFcn
    cd ..
end

plotMorisonElement