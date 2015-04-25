function [beats,localscore,cumscore] = dynamic_programming(df,p,ppath,alpha,tightness);

% function to calculate beat locations given the periodicity path
% based on Ellis "beat tracking using dynamic programming"
% but using a variable periodicity path and an optional expressive
% mode which can follow greater tempo changes


tempmat = (ppath'*ones(1,p.step))';
pd = round(tempmat(:));

mpd = round(median(ppath));
templt = exp(-0.5*(([-mpd:mpd]/(mpd/32)).^2));
localscore = conv(templt,df);

localscore = localscore(round(length(templt)/2)+[1:length(df)]);

backlink = zeros(1,length(localscore));
cumscore = zeros(1,length(localscore));

starting = 1;
for i = 1:length(localscore)

	prange = round(-2*pd(i)):-round(pd(i))/2;
	mu = -pd(i);
%	txwt = exp( -0.5*  (  (  ( tightness    - 0* log(1+dp(ceil(i/p.step))) )   *   log(prange/-pd(i))).^2)  );
	txwt = exp( -0.5*  (  (  ( tightness  )   *   log(prange/-pd(i))).^2)  );

	timerange = i + prange;

	zpad = max(0, min(1-timerange(1),length(prange)));
  scorecands = txwt .* [zeros(1,zpad),cumscore(timerange(zpad+1:end))];

	[vv,xx] = max(scorecands);

	cumscore(i) = alpha*vv + (1-alpha)*localscore(i);

	if starting == 1 & localscore(i) < 0.01*max(localscore);
		backlink(i) = -1;
	else
		backlink(i) = timerange(xx);
		starting = 0;
    end

end

align = getalignment2(localscore(end-512:end),ones(1,1*pd(end)),1*pd(end),0);

b = [];
b = length(localscore) - align;

while backlink(b(end)) > 0
b = [b,backlink(b(end))];
end

% put the beat times into seconds
beats = sort(b)*512/44100;

