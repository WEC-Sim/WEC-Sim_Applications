function yf = predictor(past_excM, ARorder, Np, t)
% Initial conditions
    persistent EstMdl
    if isempty(EstMdl)
        EstMdl      = ar(past_excM,ARorder); 
    end
    
    t_floor = ceil(t);
    if mod(t,t_floor)==0
        EstMdl      = ar(past_excM,ARorder); 
    end
   
    yf = forecast(EstMdl,past_excM,Np);
