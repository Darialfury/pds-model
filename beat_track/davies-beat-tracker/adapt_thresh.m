function [dfout,m] = adapt_thresh(df,pre,post);




df = df(:)';

alpha = 9;
thresh=0.033;
fn = @mean;

if(nargin<2)
    pre = 8;
    post = 7;
end

% moving mean threshold

N=length(df);

for i=1:min(post,N)
	k=min(i+pre,N);
	m(i)=feval(fn,df(1:k));
end

if N>(post+pre)
	m=[m feval(fn,buffer(df,post+pre+1,post+pre,'nodelay'))];
end

for i=N+(1-pre:0)
	j=max(i-post,1);
	m(i)=feval(fn,df(j:end));
end

df = df-m;

dfout = (df>0).*df;

