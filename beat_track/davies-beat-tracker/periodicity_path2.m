function [ppath,obs] = periodicity_path2(df,p,twidth);

% function to calculate the best periodicity path through time
% using viterbi decoding

step = p.step;
winlen = p.winlen;

n = [1:p.step];

% rayleigh weighting curve
wv = (n ./ p.rayparam .^ 2) .* exp(-n .^ 2 ./ (2*p.rayparam .^ 2));

% sum to unity
wv = sunity(wv);

pin = 0;
pend = length(df) - winlen;


% split df into overlapping frames
% find the autocorrelation function
% apply comb filtering and store output in a matrix 'obs'

ct = 0;
while(pin<pend)


  ct = ct+1;
	segment = (df(pin+1:pin+winlen));
	acf(:,ct) = ftacf(segment(:));
	[rcf] = getperiod(acf(:,ct),wv,0,step,p.pmin,p.pmax);
  obs(:,ct) = sunity(adapt_thresh(rcf));

	pin = pin+step;

end


% make transition matrix
tmat = zeros(step);

% as a diagonal guassian
for i=28:108, 
  tmat(:,i) = (normpdf(n,i,twidth)); 
end; 

tmat(1:28,:) = 0;
tmat(:,1:28) = 0;
tmat(108:128,:) = 0;
tmat(:,108:128) = 0;


% work out best path
[ppath] = viterbi_path(wv,tmat,obs+0.01*max(max(obs))*rand(size(obs)));

% add on a few values at the end, to deal with final overlapping frames
ppath = [ppath ppath(end)*ones(1,4)];
