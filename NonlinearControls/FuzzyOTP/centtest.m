
curve = [ 0 3 5 8 9 11 15
          0 0 .5 0.5 .4 1 1]; 


%function to return output value corresponding to MF centroid

    

    polyin = polyshape(polydCurve','Simplify',true);
    polyin = simplify(polyin,'KeepCollinearPoints',false);
    plot(polyin)
    [x,~] = centroid(polyin);    
