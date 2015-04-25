function [rcf] = getperiod(acf,wv,timesig,step,pmin,pmax)



rcf = zeros(1,step);

if(~timesig) % timesig unknown, must be general state
    numelem = 4; 

    for i=pmin:pmax-1, % maximum beat period
        for a=1:numelem, % number of comb elements
            for b=1-a:a-1, % gs using normalization of comb elements
                rcf(i) = rcf(i) + (acf(a*i+b)*wv(i))/(2*a-1);
            end
        end
    end

else
    numelem = timesig; % timesig known must be context dependent state

    for i=pmin:pmax-1, % maximum beat period
        for a=1:numelem, % number of comb elements
            for b=1-a:a-1, % cds not normalizing comb elements
                rcf(i) = rcf(i) + acf(a*i+b)*wv(i);
            end
        end
    end

end


