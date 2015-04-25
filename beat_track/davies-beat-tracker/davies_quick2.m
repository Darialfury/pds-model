function beats = davies_quick(df,p,alpha,tightness,twidth)

if nargin<2
  p = bt_parms;
end

% strip any trailing zeros
while (df(end)==0)
  df = df(1:end-1);
end

% get periodicity path
ppath = periodicity_path2(df,p,twidth);

mode = 0; % use this to run normal algorithm.
% find beat locations
beats = dynamic_programming2(df,p,ppath,alpha,tightness);
